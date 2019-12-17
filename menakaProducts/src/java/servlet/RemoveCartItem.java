/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.Cart;
import pojos.CartHasItem;
import pojos.CartHasPackages;
import pojos.CartHasPackets;
import pojos.LooseStock;
import pojos.Packages;
import pojos.PacketStock;
import pojos.User;

/**
 *
 * @author nipun
 */
@WebServlet(name = "RemoveCartItem", urlPatterns = {"/RemoveCartItem"})
public class RemoveCartItem extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");
            int id = Integer.parseInt(req.getParameter("id"));
            String type = req.getParameter("type");

            Session s = NewHibernateUtil.getSessionFactory().openSession();
            Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();
            
            if (user != null) {  // user logged in, DB cart

                if (type.equals("loose item")) {
                    
                    CartHasItem cartItem = (CartHasItem) s.createCriteria(CartHasItem.class)
                            .add(Restrictions.eq("cart", cart))
                            .add(Restrictions.eq("idCartItem", id))
                            .add(Restrictions.eq("status", "pending")).uniqueResult();
                            
                    
                    s.delete(cartItem);
                    s.beginTransaction().commit();
                    s.flush();
                    s.close();

                    System.out.println("db cart loose item remoed");
                    resp.getWriter().write("removed@1");

                } else if (type.equals("spicy packet")) {

                    CartHasPackets cartPackets = (CartHasPackets) s.createCriteria(CartHasPackets.class)
                            .add(Restrictions.eq("cart", cart))
                            .add(Restrictions.eq("id", id))
                            .add(Restrictions.eq("status", "pending")).uniqueResult();
                            
                    
                    s.delete(cartPackets);
                    s.beginTransaction().commit();
                    s.flush();
                    s.close();

                    System.out.println("db cart packet item remoed");
                    resp.getWriter().write("removed@1");

                } else if (type.equals("package")) {

                    
                    CartHasPackages cartPackages = (CartHasPackages) s.createCriteria(CartHasPackages.class)
                            .add(Restrictions.eq("id", id))
                            .add(Restrictions.eq("status", "pending")).uniqueResult();

                    s.delete(cartPackages);
                    s.beginTransaction().commit();
                    s.flush();
                    s.close();
                    System.out.println("db cart package item remoed");
                    resp.getWriter().write("removed@1");
                }

            } else { // session Cart

                if (type.equals("loose item")) {

                    ArrayList<LooseSessionCart> looseCart = (ArrayList<LooseSessionCart>) req.getSession().getAttribute("looseCart");

                    for (LooseSessionCart looseSessionCart : looseCart) {
                        if (looseSessionCart.getLooseStock().getIditem() == id) { // item found on session cart
                            looseCart.remove(looseSessionCart);

                            System.out.println("session cart loose item remoed");
                            resp.getWriter().write("removed@1");
                            break;
                        }
                    }

                } else if (type.equals("spicy packet")) {

                    ArrayList<PacketSessionCart> looseCart = (ArrayList<PacketSessionCart>) req.getSession().getAttribute("packetCart");

                    for (PacketSessionCart packetSessionCart : looseCart) {
                        if (packetSessionCart.getPacketStock().getId() == id) { // item found on session cart
                            looseCart.remove(packetSessionCart);

                            System.out.println("session cart packet item remoed");
                            resp.getWriter().write("removed@1");
                            break;
                        }
                    }

                }

            }
        } catch (NullPointerException e) {
            System.out.println("nullpointer");
            resp.getWriter().write("@refresh");
        }

    }
}
