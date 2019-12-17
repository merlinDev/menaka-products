/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.Cart;
import pojos.CartHasItem;
import pojos.CartHasPackets;
import pojos.Limit;
import pojos.User;
import pojos.Usertype;

/**
 *
 * @author nipun
 */
@WebServlet(name = "login", urlPatterns = {"/login"})
public class login_original extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String email = req.getParameter("email");
            String pass = req.getParameter("password");
            String password = DatatypeConverter.printHexBinary(MessageDigest.getInstance("MD5").digest(pass.getBytes("UTF-8"))).toLowerCase();
            Session s = NewHibernateUtil.getSessionFactory().openSession();

            Criteria c = s.createCriteria(User.class);
            c.add(Restrictions.eq("email", email));
            c.add(Restrictions.eq("password", password));
            c.add(Restrictions.eq("status", true));

            if (c.list().isEmpty() || c.list().size() > 1) {
                // password not match or more results than 1
                resp.getWriter().write("paswordmatch@0");
                System.out.println("pasword or email not correct");
            } else {
                // user found

                User user = (User) c.uniqueResult();
                
                if (user.getUsertype().getIdusertype() == 1) {
                    resp.getWriter().write("redirect@admin");
                    
                }else if (user.getUsertype().getIdusertype() == 4) {
                    resp.getWriter().write("redirect@emp");
                }
                
                // checking cart
                if (req.getSession().getAttribute("looseCart") != null || req.getSession().getAttribute("packetCart") != null) {
                    if (user.getCarts().isEmpty()) {
                        Cart cart = new Cart();
                        cart.setUser(user);
                        s.save(cart);
                        s.flush();
                        
                        System.out.println("user doesn't has a cart. assigning new cart");
                    }
                }

                // checking online status
                //if (user.getOoStatus().equals("online")) {
                 //   System.out.println("already logged in");
                  //  resp.getWriter().write("you're logged in with another device alerady.");
               // } else {

                    if (req.getSession().getAttribute("looseCart") != null) {  // loose item session cart found
                        System.out.println("loose item session cart found...");
                        Criteria crt = s.createCriteria(Cart.class);
                        crt.add(Restrictions.eq("user", user));

                        Cart cart = (Cart) crt.uniqueResult();
                        System.out.println("user cart id :" + cart.getIdcart());
                        
                        
                        Criteria chi = s.createCriteria(CartHasItem.class);
                        chi.add(Restrictions.eq("cart", cart));
                        chi.add(Restrictions.eq("status", "pending"));
                        List<CartHasItem> list = chi.list();

                        Usertype localUserType = (Usertype) s.load(Usertype.class, 2);
                        Usertype shopUserType = (Usertype) s.load(Usertype.class, 3);

                        Limit localULimit = (Limit) s.createCriteria(Limit.class).add(Restrictions.eq("usertype", localUserType)).uniqueResult();
                        Limit shopULimit = (Limit) s.createCriteria(Limit.class).add(Restrictions.eq("usertype", shopUserType)).uniqueResult();

                        List<LooseSessionCart> tempCart = (ArrayList<LooseSessionCart>) req.getSession().getAttribute("looseCart");
                        if (list.isEmpty()) {  // db cart does not has any items

                            for (LooseSessionCart sess : tempCart) {
                                CartHasItem add = new CartHasItem();
                                if (user.getUsertype().getIdusertype() == 2) { // local user
                                    if (localULimit.getTotalQty() < sess.getLooseStockQty()) {

                                        add.setQty(localULimit.getTotalQty());
                                    } else {
                                        add.setQty(sess.getLooseStockQty());
                                    }

                                } else if (user.getUsertype().getIdusertype() == 3) { // shop user
                                    if (shopULimit.getTotalQty() > sess.getLooseStockQty()) {
                                        System.out.println("shop limit > session qty");
                                        if (sess.getLooseStock().getQty() < shopULimit.getTotalQty()) {
                                            System.out.println("shop limit > stock qty");
                                            add.setQty(sess.getLooseStock().getQty());
                                        } else {
                                            System.out.println("shop limit < stock qty");
                                            System.out.println(shopULimit.getTotalQty() +"&&&&&&&&&&&&&&&&&&777");
                                            add.setQty(shopULimit.getTotalQty());
                                        }
                                    } else {
                                        System.out.println("shop limit < session qty");
                                        add.setQty(sess.getLooseStockQty());
                                    }
                                }

                                add.setCart(cart);
                                add.setDate(new Date());
                                add.setLooseStock(sess.getLooseStock());
                                add.setIdCartItem(sess.getLooseStock().getIditem());

                                add.setStatus("pending");

                                s.save(add);
                                s.beginTransaction().commit();

                                System.out.println("db cart han no items.....");
                                System.out.println("session cart added to db cart.....");
                            }
                        } else { // db cart has items

                            for (CartHasItem cartHasItem : list) {
                                for (LooseSessionCart temp : tempCart) {
                                    if (Objects.equals(temp.getLooseStock().getIditem(), cartHasItem.getLooseStock().getIditem())) { // session item already in db cart
                                        if (temp.getLooseStockQty() + cartHasItem.getQty() > cartHasItem.getLooseStock().getQty()) {  // qty overloaded

                                            if (user.getUsertype().getIdusertype() == 2) { // local user
                                                if (temp.getLooseStockQty() + cartHasItem.getQty() > localULimit.getTotalQty()) {
                                                    cartHasItem.setQty(localULimit.getTotalQty());
                                                } else {
                                                    cartHasItem.setQty(cartHasItem.getLooseStock().getQty() + temp.getLooseStockQty());
                                                }
                                            } else if (user.getUsertype().getIdusertype() == 3) { // shop user
                                                if (temp.getLooseStockQty() + cartHasItem.getQty() < shopULimit.getTotalQty()) {
                                                    cartHasItem.setQty(shopULimit.getTotalQty());
                                                } else {

                                                    if (cartHasItem.getLooseStock().getQty() < shopULimit.getTotalQty()) {
                                                        System.out.println("lol lol l ol oolol ol ol ol o");
                                                    } else {
                                                        cartHasItem.setQty(cartHasItem.getLooseStock().getQty() + temp.getLooseStockQty());
                                                    }

                                                }
                                            }

                                        } else {

                                            if (user.getUsertype().getIdusertype() == 2) { // local user
                                                if (temp.getLooseStockQty() + cartHasItem.getQty() > localULimit.getTotalQty()) {
                                                    cartHasItem.setQty(localULimit.getTotalQty());
                                                } else {
                                                    cartHasItem.setQty(cartHasItem.getQty() + temp.getLooseStockQty());
                                                }
                                            } else if (user.getUsertype().getIdusertype() == 3) { // shop user
                                                if (temp.getLooseStockQty() + cartHasItem.getQty() < shopULimit.getTotalQty()) {
                                                    cartHasItem.setQty(shopULimit.getTotalQty());
                                                } else {

                                                    if (cartHasItem.getLooseStock().getQty() < shopULimit.getTotalQty()) {
                                                        cartHasItem.setQty(cartHasItem.getLooseStock().getQty());
                                                    } else {
                                                        cartHasItem.setQty(cartHasItem.getQty() + temp.getLooseStockQty());
                                                    }

                                                }
                                            }

                                        }
                                        cartHasItem.setDate(new Date());
                                        s.update(cartHasItem);
                                        s.beginTransaction().commit();
                                        System.out.println("db cart qty updated from session cart..........");
                                    }
                                }
                            }
                        }
                        req.getSession().removeAttribute("looseCart"); // session cart removed...
                        System.out.println("loose session removed");
                    }

                    if (req.getSession().getAttribute("packetCart") != null) {  // packet session cart found
                        System.out.println("packet session cart found...");
                        List<PacketSessionCart> tempCart = (ArrayList<PacketSessionCart>) req.getSession().getAttribute("packetCart");
                        Criteria crt = s.createCriteria(Cart.class);
                        crt.add(Restrictions.eq("user", user));

                        Cart cart = (Cart) crt.uniqueResult();
                        
                        Criteria chi = s.createCriteria(CartHasPackets.class);
                        chi.add(Restrictions.eq("cart", cart));
                        chi.add(Restrictions.eq("status", "pending"));
                        List<CartHasPackets> list = chi.list();

                        if (list.isEmpty()) {  // db cart does not has any packets
                            for (PacketSessionCart sess : tempCart) {
                                CartHasPackets add = new CartHasPackets();
                                add.setCart(cart);
                                add.setDate(new Date());
                                add.setPacketStock(sess.getPacketStock());
                                add.setId(sess.getPacketStock().getId());
                                add.setQty(sess.getPacketQty());
                                add.setStatus("pending");

                                s.save(add);
                                s.beginTransaction().commit();

                                System.out.println("session cart added to db cart.....");
                            }
                        } else { // db cart has items
                            for (CartHasPackets cartHasPacket : list) {
                                for (PacketSessionCart temp : tempCart) {
                                    if (temp.getPacketStock().getId().equals(cartHasPacket.getPacketStock().getId())) { // packet item already in db cart
                                        if (temp.getPacketQty() + cartHasPacket.getQty() > temp.getPacketStock().getQty()) {  // qty overloaded
                                            cartHasPacket.setQty(cartHasPacket.getPacketStock().getQty());
                                        } else {
                                            cartHasPacket.setQty(cartHasPacket.getQty() + temp.getPacketQty());
                                        }
                                        cartHasPacket.setDate(new Date());
                                        s.update(cartHasPacket);
                                        s.beginTransaction().commit();
                                        System.out.println("db cart qty updated from session cart..........");
                                    }
                                }
                            }
                        }
                        req.getSession().removeAttribute("packetCart"); // session cart removed...
                        System.out.println("packet session removed");
                    }
                    System.out.println("user set to online");
                    user.setOoStatus("online");
                    s.update(user);
                    s.beginTransaction().commit();
                    s.flush();
                    s.close();

                    // creating user session
                    req.getSession().setAttribute("user", user);

                    resp.getWriter().write("login@1");
                //}

            }

        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(login_original.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
