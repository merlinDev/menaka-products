/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
@WebServlet(name = "das", urlPatterns = {"/das"})
public class login extends HttpServlet {

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
            

            if (c.list().isEmpty() || c.list().size() > 1) {
                // password not match or more results than 1
                resp.getWriter().write("paswordmatch@0");
                System.out.println("pasword or email not correct");
            } else {
                // user found

                User user = (User) c.uniqueResult();
                
                if (user.getUsertype().getIdusertype() == 1) {
                    resp.getWriter().write("redirect@admin");
                }

                //if (user.getOoStatus().equals("online")) {
                //  System.out.println("already logged in");
                //  resp.getWriter().write("you're logged in with another device alerady.");
                // } else {
                // getting user cart
                Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();

                if (cart == null) { // user doesn't has a cart
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    s.save(newCart);
                    s.beginTransaction().commit();

                    cart = newCart;
                }

                // getting user type  // 2 : local , 3 : shop
                Usertype usertype = user.getUsertype();
                int userType = usertype.getIdusertype();

                // getting limitations
                Limit limit = (Limit) s.createCriteria(Limit.class)
                        .add(Restrictions.eq("usertype", usertype)).uniqueResult();

                if (userType == 2) { // local user
                    System.out.println("local user");

                    if (req.getSession().getAttribute("looseCart") != null) { // session cart : loose found
                        System.out.println("session cart : loose found");
                        ArrayList<LooseSessionCart> sessionCartList = (ArrayList<LooseSessionCart>) req.getSession().getAttribute("looseCart");

                        List<CartHasItem> dbCartList = s.createCriteria(CartHasItem.class)
                                .add(Restrictions.eq("cart", cart))
                                .add(Restrictions.eq("status", "pending")).list();

                        if (dbCartList.isEmpty()) {  // user's loose item dbCart is empty
                            System.out.println("user's loose item dbCart is empty");

                            // adding session cart items to db cart
                            System.out.println("adding session cart items to db cart");
                            for (LooseSessionCart item : sessionCartList) {
                                CartHasItem cartItem = new CartHasItem();
                                cartItem.setLooseStock(item.getLooseStock());
                                cartItem.setDate(new Date());
                                cartItem.setCart(cart);
                                cartItem.setStatus("pending");

                                // checking user limitations
                                if (item.getLooseStockQty() < limit.getTotalQty()) {
                                    cartItem.setQty(item.getLooseStockQty());
                                    System.out.println("limitation okay");
                                } else {
                                    cartItem.setQty(limit.getTotalQty());
                                    System.out.println("qty set to limit");
                                }
                                s.save(cartItem);
                                s.beginTransaction().commit();
                            }

                        } else { // user's loose item db cart is not empty

                            System.out.println("user's loose item db cart is not empty");
                            for (CartHasItem dbCart : dbCartList) {
                                for (LooseSessionCart sessionCart : sessionCartList) {

                                    // checking for duplicates
                                    System.out.println("checking for duplicates");
                                    if (dbCart.getLooseStock().getIditem().equals(sessionCart.getLooseStock().getIditem())) { // duplicate item found
                                        System.out.println("duplicate item found");

                                        // updating qty
                                        System.out.println("updating qty");
                                        double qty = dbCart.getLooseStock().getQty() + sessionCart.getLooseStockQty();

                                        // checking user limitations
                                        if (qty < limit.getTotalQty()) {
                                            dbCart.setQty(qty);
                                            System.out.println("limitations okay");
                                        } else {
                                            dbCart.setQty(limit.getTotalQty());
                                            System.out.println("qty set to limit");
                                        }
                                        dbCart.setDate(new Date());
                                        s.update(dbCart);
                                        s.beginTransaction().commit();

                                        System.out.println("loose db cart qty updated via session cart");
                                    }
                                }
                            }
                        }

                    }

                } else if (userType == 3) { // shop user
                    System.out.println("shop user");

                    if (req.getSession().getAttribute("looseCart") != null) { // session cart : loose found
                        System.out.println("session cart : loose found");
                        ArrayList<LooseSessionCart> sessionCartList = (ArrayList<LooseSessionCart>) req.getSession().getAttribute("looseCart");

                        List<CartHasItem> dbCartList = s.createCriteria(CartHasItem.class)
                                .add(Restrictions.eq("cart", cart))
                                .add(Restrictions.eq("status", "pending")).list();

                        if (dbCartList.isEmpty()) {  // user's loose item dbCart is empty
                            System.out.println("user's loose item dbCart is empty");

                            // adding session cart items to db cart
                            System.out.println("adding session cart items to db cart");
                            for (LooseSessionCart item : sessionCartList) {
                                CartHasItem cartItem = new CartHasItem();
                                cartItem.setLooseStock(item.getLooseStock());
                                cartItem.setDate(new Date());
                                cartItem.setCart(cart);
                                cartItem.setStatus("pending");

                                // checking user limitations
                                if (item.getLooseStockQty() > limit.getTotalQty()) {
                                    cartItem.setQty(item.getLooseStockQty());
                                    System.out.println("limitation okay");
                                } else {
                                    cartItem.setQty(limit.getTotalQty());
                                    System.out.println("qty set to limit");
                                }
                                s.save(cartItem);
                                s.beginTransaction().commit();
                            }

                        } else { // user's loose item db cart is not empty

                            System.out.println("user's loose item db cart is not empty");
                            for (CartHasItem dbCart : dbCartList) {
                                for (LooseSessionCart sessionCart : sessionCartList) {

                                    // checking for duplicates
                                    System.out.println("checking for duplicates");
                                    if (dbCart.getLooseStock().getIditem().equals(sessionCart.getLooseStock().getIditem())) { // duplicate item found
                                        System.out.println("duplicate item found");

                                        // updating qty
                                        System.out.println("updating qty");
                                        double qty = dbCart.getLooseStock().getQty() + sessionCart.getLooseStockQty();

                                        // checking user limitations
                                        if (qty > limit.getTotalQty()) {
                                            dbCart.setQty(qty);
                                            System.out.println("limitations okay");
                                        } else {
                                            dbCart.setQty(limit.getTotalQty());
                                            System.out.println("qty set to limit");
                                        }
                                        dbCart.setDate(new Date());
                                        s.update(dbCart);
                                        s.beginTransaction().commit();

                                        System.out.println("loose db cart qty updated via session cart");
                                    }
                                }
                            }
                        }

                    }
                }

                // ************* packet qty check *********** //
                if (req.getSession().getAttribute("packetCart") != null) { // session cart : packet found
                    System.out.println("session cart : packet found");
                    ArrayList<PacketSessionCart> sessionCartList = (ArrayList<PacketSessionCart>) req.getSession().getAttribute("packetCart");
                    List<CartHasPackets> dbCartList = s.createCriteria(CartHasPackets.class)
                            .add(Restrictions.eq("cart", cart))
                            .add(Restrictions.eq("status", "pending")).list();

                    if (dbCartList.isEmpty()) {  // user's packet item dbCart is empty
                        System.out.println("user's packet item dbCart is empty");

                        // adding session cart items to db cart
                        System.out.println("adding session cart items to db cart");
                        for (PacketSessionCart item : sessionCartList) {
                            CartHasPackets cartItem = new CartHasPackets();
                            cartItem.setPacketStock(item.getPacketStock());
                            cartItem.setDate(new Date());
                            cartItem.setCart(cart);
                            cartItem.setQty(item.getPacketQty());
                            cartItem.setStatus("pending");

                            s.save(cartItem);
                            s.beginTransaction().commit();
                        }

                    } else { // user's packet item db cart is not empty

                        System.out.println("user's packet item db cart is not empty");
                        for (CartHasPackets dbCart : dbCartList) {
                            for (PacketSessionCart sessionCart : sessionCartList) {

                                // checking for duplicates
                                System.out.println("checking for duplicates");
                                if (dbCart.getPacketStock().getId().equals(sessionCart.getPacketStock().getId())) { // duplicate item found
                                    System.out.println("duplicate item found");

                                    // updating qty
                                    System.out.println("updating qty");
                                    int qty = dbCart.getPacketStock().getQty() + sessionCart.getPacketQty();

                                    dbCart.setQty(qty);
                                    dbCart.setDate(new Date());
                                    s.update(dbCart);
                                    s.beginTransaction().commit();

                                    System.out.println("packet db cart qty updated via session cart");
                                }
                            }
                        }
                    }

                }

                // ******** cart qty updated ********** //
                // setting user online
                user.setOoStatus("online");
                // removing session carts
                req.getSession().removeAttribute("looseCart");
                req.getSession().removeAttribute("packetCart");

                // creating user session
                req.getSession().setAttribute("user", user);
                // sending respond
                resp.getWriter().write("login@1");
                servlet.Logger.doLog(user.getEmail(), "logged in");

            }

        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(login.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
