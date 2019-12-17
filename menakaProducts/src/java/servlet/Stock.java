/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import pojos.Category;
import pojos.LooseStock;
import pojos.Packages;
import pojos.Packet;
import pojos.PacketStock;
import pojos.Product;

/**
 *
 * @author nipun
 */
@WebServlet(name = "Stock", urlPatterns = {"/Stock"})
public class Stock extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String search = req.getParameter("search");
        String status = req.getParameter("status");
        String category = req.getParameter("cat");
        String type = req.getParameter("type");
        String exp = req.getParameter("exp");
        String man = req.getParameter("man");
        String gram = req.getParameter("gram");
        String priceFrom = req.getParameter("pFrom");
        String priceTo = req.getParameter("pTo");
        
        System.out.println("pricefrom ::: "+priceFrom);
        System.out.println("priceTo ::: "+priceTo);

        Session s = NewHibernateUtil.getSessionFactory().openSession();

        if (status.equals("n/a")) {
            status = "na";
        } else if (status.equals("all")) {
            status = "";
        }

        System.out.println(status);
        System.out.println(category);
        JSONArray array = new JSONArray();

        if (type.equals("loose")) {
            // load loose stock
            List<Product> list_p = s.createCriteria(Product.class)
                    .add(Restrictions.like("productname", search, MatchMode.START)).list();

            for (Product product : list_p) {
                Criteria looseCriteria = s.createCriteria(LooseStock.class).add(Restrictions.eq("product", product))
                        .add(Restrictions.like("status", status, MatchMode.START));

                if (!priceFrom.equals("") && !priceTo.equals("")) {
                    looseCriteria.add(Restrictions.between("uprice", Double.parseDouble(priceFrom), Double.parseDouble(priceTo)));
                }
                List<LooseStock> list = looseCriteria.list();
                for (LooseStock looseStock : list) {
                    if (!looseStock.getStatus().equals("delete")) {
                        JSONObject jo = new JSONObject();
                        jo.put("id", looseStock.getIditem());
                        jo.put("name", looseStock.getProduct().getProductname());
                        jo.put("qty", looseStock.getQty());
                        jo.put("price", looseStock.getUprice());
                        jo.put("status", looseStock.getStatus());
                        jo.put("typ", looseStock.getProduct().getType());
                        array.add(jo);
                    }

                }
            }

        } else if (type.equals("pkt")) {
            // load pkt stock

            Criteria crt_pkt = s.createCriteria(Packet.class)
                    .add(Restrictions.like("name", search, MatchMode.START))
                    .add(Restrictions.sqlRestriction("weight LIKE '" + gram + "%'"));

            
            List<Packet> list_pkt = crt_pkt.list();

            for (Packet packet : list_pkt) {
               Criteria cr = s.createCriteria(PacketStock.class).add(Restrictions.eq("packet", packet))
                        .add(Restrictions.like("status", status, MatchMode.START))
                        .add(Restrictions.sqlRestriction("exp LIKE '" + exp + "%'"))
                        .add(Restrictions.sqlRestriction("man LIKE '" + man + "%'"));
               
               if (!priceFrom.equals("") && !priceTo.equals("")) {
                cr.add(Restrictions.between("price", Double.parseDouble(priceFrom), Double.parseDouble(priceTo)));
            }
               
               List<PacketStock> list = cr.list();
               
                for (PacketStock packetStock : list) {
                    System.out.println(packetStock.getPacket().getName());
                    if (!packetStock.getStatus().equals("delete")) {
                        JSONObject jo = new JSONObject();
                        jo.put("id", packetStock.getId());
                        jo.put("name", packetStock.getPacket().getName());
                        jo.put("qty", packetStock.getQty());
                        jo.put("price", packetStock.getPrice());
                        jo.put("status", packetStock.getStatus());
                        jo.put("exp", packetStock.getExp().toString());
                        jo.put("man", packetStock.getMan().toString());
                        jo.put("gram", packetStock.getPacket().getWeight());
                        jo.put("typ", packetStock.getPacket().getType());
                        array.add(jo);
                    }
                }
            }

        } else if (type.equals("pkg")) {
            // load pkg stock
            Category cat = (Category) s.createCriteria(Category.class).add(Restrictions.eq("type", category)).uniqueResult();
            Criteria pkg_crt = s.createCriteria(Packages.class)
                    .add(Restrictions.like("packageName", search, MatchMode.START))
                    .add(Restrictions.like("status", status, MatchMode.START));

            if (!priceFrom.equals("") && !priceTo.equals("")) {
                pkg_crt.add(Restrictions.between("price", Double.parseDouble(priceFrom), Double.parseDouble(priceTo)));
            }

            if (!category.equals("all")) {
                System.out.println(category);
                pkg_crt.add(Restrictions.eq("category", cat));
            }

            List<Packages> list = pkg_crt.list();

            for (Packages Packages : list) {
                if (!Packages.getStatus().equals("delete")) {
                    JSONObject jo = new JSONObject();
                    jo.put("id", Packages.getIdpackages());
                    jo.put("name", Packages.getPackageName());
                    jo.put("price", Packages.getPrice());
                    jo.put("desc", Packages.getDescription());
                    jo.put("cat", Packages.getCategory().getType());
                    jo.put("status", Packages.getStatus());
                    jo.put("img", "../" + Packages.getPackageImage().replace("\\", "/"));
                    jo.put("typ", "package");
                    array.add(jo);
                }
            }
        }

        s.flush();
        s.close();
        resp.getWriter().write(array.toJSONString());
        System.out.println("stock loaded");

    }
}
