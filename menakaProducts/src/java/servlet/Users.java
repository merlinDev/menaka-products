/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Disjunction;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import pojos.Cart;
import pojos.CartHasItem;
import pojos.Invoice;
import pojos.InvoiceHasCartItem;
import pojos.Limit;
import pojos.Location;
import pojos.User;
import pojos.Usertype;

/**
 *
 * @author nipun
 */
@WebServlet(name = "Users", urlPatterns = {"/Users"})
public class Users extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        System.out.println("user ser");
        String type = req.getParameter("type");
        Session s = NewHibernateUtil.getSessionFactory().openSession();

        if (type.equals("search")) {

            String search = req.getParameter("search");
            String block = req.getParameter("status");
            String online = req.getParameter("online");
            String usertype = req.getParameter("usertype");
            String invoices = req.getParameter("invoices");

            Criteria c = s.createCriteria(User.class);
            Disjunction disjunction = Restrictions.disjunction();
            disjunction.add(Restrictions.like("name", search, MatchMode.START));
            disjunction.add(Restrictions.like("email", search, MatchMode.START));

            c.add(disjunction);
            Usertype admin = (Usertype) s.load(Usertype.class, 1);
            
            c.add(Restrictions.ne("usertype", admin));
            
            if (block.equals("blocked")) {
                System.out.println("showing blocked");

                c.add(Restrictions.eq("status", false));
            } else if (block.equals("active")) {
                System.out.println("showing active");
                c.add(Restrictions.eq("status", true));
            }

            if (online.equals("online")) {
                c.add(Restrictions.eq("ooStatus", "online"));
            } else if (online.equals("offline")) {
                c.add(Restrictions.eq("ooStatus", "offline"));
            }

            if (usertype.equals("local users")) {
                System.out.println("local users");
                Usertype utype = (Usertype) s.load(Usertype.class, 2);
                c.add(Restrictions.eq("usertype", utype));
            } else if (usertype.equals("shop users")) {
                System.out.println("shop users");
                Usertype utype = (Usertype) s.load(Usertype.class, 3);
                c.add(Restrictions.eq("usertype", utype));
            } else if (usertype.equals("employees")) {
                System.out.println("emp users");
                Usertype utype = (Usertype) s.load(Usertype.class, 4);
                c.add(Restrictions.eq("usertype", utype));
            }

            List<User> list = c.list();
            JSONArray array = new JSONArray();
            for (User user : list) {

                int invoiceTotal = user.getInvoices().size();
                System.out.println("invoices : " + invoiceTotal);
                try {
                    int inv = Integer.parseInt(invoices);

                    if (inv == invoiceTotal) {
                        JSONObject jo = new JSONObject();
                        jo.put("id", user.getIduser());
                        jo.put("name", user.getName());
                        jo.put("email", user.getEmail());
                        jo.put("invoices", invoiceTotal);
                        jo.put("date", user.getDate().toString());

                        String status = user.getStatus().toString();
                        System.out.println("status : " + status);
                        if (!status.equals("false")) {
                            status = "active";
                        } else {
                            status = "blocked";
                        }
                        jo.put("status", status);
                        jo.put("oo", user.getOoStatus());
                        array.add(jo);
                    }

                } catch (NumberFormatException e) {
                    JSONObject jo = new JSONObject();
                    jo.put("id", user.getIduser());
                    jo.put("name", user.getName());
                    jo.put("email", user.getEmail());
                    jo.put("date", user.getDate().toString());
                    jo.put("invoices", invoiceTotal);

                    String status = user.getStatus().toString();
                    System.out.println("status : " + status);
                    if (!status.equals("false")) {
                        status = "active";
                    } else {
                        status = "blocked";
                    }
                    jo.put("status", status);
                    jo.put("oo", user.getOoStatus());
                    array.add(jo);
                }

            }
            System.out.println(array.toJSONString());
            resp.getWriter().write(array.toJSONString());

        } else if (type.equals("location")) {
            User user = (User) s.load(User.class, Integer.parseInt(req.getParameter("id")));
            List<Location> list = s.createCriteria(Location.class).add(Restrictions.eq("user", user)).list();
            JSONArray array = new JSONArray();
            for (Location location : list) {
                JSONObject jo = new JSONObject();
                jo.put("address", location.getAddress());
                jo.put("zip", location.getZip());
                jo.put("tel", location.getTel());
                jo.put("street", location.getStreet());
                try {
                    jo.put("long", location.getLang());
                    jo.put("lat", location.getLat());
                } catch (NullPointerException e) {
                    System.out.println("no map");
                }
                array.add(jo);
            }

            resp.getWriter().write(array.toJSONString());

        } else if (type.equals("status")) {
            String status = req.getParameter("status");
            User user = (User) s.createCriteria(User.class)
                    .add(Restrictions.eq("iduser", Integer.parseInt(req.getParameter("id")))).uniqueResult();

            if (status.equals("1")) {
                user.setStatus(true);
            } else {
                user.setStatus(false);
            }
            s.update(user);
            s.beginTransaction().commit();
            s.flush();
            s.close();
            System.out.println("done");
            resp.getWriter().write("done");

        } else if (type.equals("limit")) {
            try {
                String value = req.getParameter("value");
                String limitype = req.getParameter("limitype");
                Usertype usrtype;
                Limit limit = null;
                if (limitype.equals("shop-user-qty")) {
                    usrtype = (Usertype) s.load(Usertype.class, 3);
                    limit = (Limit) s.createCriteria(Limit.class)
                            .add(Restrictions.eq("usertype", usrtype)).uniqueResult();

                    limit.setTotalQty(Double.parseDouble(value));

                } else if (limitype.equals("local-user-qty")) {
                    usrtype = (Usertype) s.load(Usertype.class, 2);
                    limit = (Limit) s.createCriteria(Limit.class)
                            .add(Restrictions.eq("usertype", usrtype)).uniqueResult();

                    limit.setTotalQty(Double.parseDouble(value));

                } else if (limitype.equals("local-user-price")) {
                    usrtype = (Usertype) s.load(Usertype.class, 2);
                    limit = (Limit) s.createCriteria(Limit.class)
                            .add(Restrictions.eq("usertype", usrtype)).uniqueResult();

                    limit.setTotalPrice(Double.parseDouble(value));

                } else if (limitype.equals("shop-user-price")) {
                    usrtype = (Usertype) s.load(Usertype.class, 3);
                    limit = (Limit) s.createCriteria(Limit.class)
                            .add(Restrictions.eq("usertype", usrtype)).uniqueResult();

                    limit.setTotalPrice(Double.parseDouble(value));
                }

                if (limit != null) {
                    s.update(limit);
                }else{
                     
                }

                s.beginTransaction().commit();
                s.flush();
                s.close();

                resp.getWriter().write("limits were updated");
            } catch (NumberFormatException e) {
                resp.getWriter().write("input@0");
            }

        }

    }
}
