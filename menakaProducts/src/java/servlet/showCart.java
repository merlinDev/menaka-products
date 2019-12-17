/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import pojos.Cart;
import pojos.CartHasItem;
import pojos.CartHasPackages;
import pojos.CartHasPackets;
import pojos.User;

/**
 *
 * @author nipun
 */
@WebServlet(name = "showCart", urlPatterns = {"/showCart"})
public class showCart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Session s = NewHibernateUtil.getSessionFactory().openSession();
        JSONArray array = new JSONArray();

        if (req.getSession().getAttribute("user") != null) { // user logged in.
            User user = (User) req.getSession().getAttribute("user");
            Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();

            // showing db cart....
            System.out.println("showing db cart.....");

            // loose items cart
            List<CartHasItem> cartItems = s.createCriteria(CartHasItem.class).add(Restrictions.eq("cart", cart)).list();

            for (CartHasItem cartHasItem : cartItems) {
                String status = cartHasItem.getLooseStock().getStatus();
                if (status.equals("available") && cartHasItem.getStatus().equals("pending")) {
                    JSONObject jo = new JSONObject();
                    jo.put("type", "loose item");
                    jo.put("itemId", cartHasItem.getLooseStock().getIditem());
                    jo.put("itemName", cartHasItem.getLooseStock().getProduct().getProductname());
                    jo.put("uPrice", cartHasItem.getLooseStock().getUprice());
                    jo.put("qty", cartHasItem.getQty());
                    jo.put("qtyPrice", cartHasItem.getQty() * cartHasItem.getLooseStock().getUprice());
                    jo.put("itemImg", cartHasItem.getLooseStock().getProduct().getImg().replace("\\", "/"));
                    array.add(jo);
                }
            }

            // packets cart
            List<CartHasPackets> cartPackets = s.createCriteria(CartHasPackets.class).add(Restrictions.eq("cart", cart)).list();

            for (CartHasPackets cartHasPackets : cartPackets) {
                String status = cartHasPackets.getPacketStock().getStatus();
                if (status.equals("available") && cartHasPackets.getStatus().equals("pending")) {
                    JSONObject jo = new JSONObject();
                    jo.put("type", "spicy packet");
                    System.out.println("cart packet id  : " +cartHasPackets.getId());
                    jo.put("itemId", cartHasPackets.getPacketStock().getId());
                    jo.put("itemName", cartHasPackets.getPacketStock().getPacket().getName());
                    jo.put("uPrice", cartHasPackets.getPacketStock().getPrice());
                    jo.put("qty", cartHasPackets.getQty());
                    jo.put("exp", cartHasPackets.getPacketStock().getExp().toString());
                    jo.put("man", cartHasPackets.getPacketStock().getMan().toString());
                    jo.put("qtyPrice", cartHasPackets.getQty() * cartHasPackets.getPacketStock().getPrice());
                    jo.put("itemImg", cartHasPackets.getPacketStock().getPacket().getImg().replace("\\", "/"));
                    array.add(jo);
                }
            }

            // package cart
            List<CartHasPackages> cartPackages = s.createCriteria(CartHasPackages.class).add(Restrictions.eq("cart", cart)).list();

            for (CartHasPackages cartHasPackages : cartPackages) {
                String status = cartHasPackages.getPackages().getStatus();
                if (status.equals("available") && cartHasPackages.getStatus().equals("pending")) {
                    JSONObject jo = new JSONObject();
                    jo.put("type", "package");
                    jo.put("itemId", cartHasPackages.getPackages().getIdpackages());
                    jo.put("itemName", cartHasPackages.getPackages().getPackageName());
                    jo.put("uPrice", cartHasPackages.getPackages().getPrice());
                    jo.put("qty", cartHasPackages.getQty());
                    jo.put("qtyPrice", cartHasPackages.getQty() * cartHasPackages.getPackages().getPrice());
                    jo.put("itemImg", cartHasPackages.getPackages().getPackageImage().replace("\\", "/"));
                    array.add(jo);
                }
            }
            s.flush();
            s.close();
        } else {

            // showing session cart.
            System.out.println("showing session cart....");

            if (req.getSession().getAttribute("looseCart") != null) {

                ArrayList<LooseSessionCart> list = (ArrayList<LooseSessionCart>) req.getSession().getAttribute("looseCart");
                System.out.println("list :" + list.size());

                for (LooseSessionCart sessionCart : list) {

                    // loose items
                    if (sessionCart.getLooseStock().getProduct().getStatus().equals("available")) {
                        JSONObject jo = new JSONObject();
                        jo.put("type", "loose item");
                        jo.put("itemId", sessionCart.getLooseStock().getIditem());
                        jo.put("itemName", sessionCart.getLooseStock().getProduct().getProductname());
                        jo.put("uPrice", sessionCart.getLooseStock().getUprice());
                        jo.put("qty", sessionCart.getLooseStockQty());
                        jo.put("qtyPrice", sessionCart.getLooseStockQty() * sessionCart.getLooseStock().getUprice());
                        jo.put("itemImg", sessionCart.getLooseStock().getProduct().getImg().replace("\\", "/"));
                        array.add(jo);
                    }
                }

            }

            if (req.getSession().getAttribute("packetCart") != null) {
                ArrayList<PacketSessionCart> list = (ArrayList<PacketSessionCart>) req.getSession().getAttribute("packetCart");

                for (PacketSessionCart sessionCart : list) {
                    //packets
                    if (sessionCart.getPacketStock().getPacket().getStatus().equals("available")) {
                        JSONObject jo = new JSONObject();
                        jo.put("type", "spicy packet");
                        jo.put("itemId", sessionCart.getPacketStock().getId());
                        jo.put("itemName", sessionCart.getPacketStock().getPacket().getName());
                        jo.put("uPrice", sessionCart.getPacketStock().getPrice());
                        jo.put("qty", sessionCart.getPacketQty());
                        jo.put("exp", sessionCart.getPacketStock().getExp().toString());
                        jo.put("man", sessionCart.getPacketStock().getMan().toString());
                        jo.put("qtyPrice", sessionCart.getPacketQty() * sessionCart.getPacketStock().getPrice());
                        jo.put("itemImg", sessionCart.getPacketStock().getPacket().getImg().replace("\\", "/"));
                        array.add(jo);
                    }
                }
            }

        }

        resp.getWriter().write(array.toJSONString());

    }

}
