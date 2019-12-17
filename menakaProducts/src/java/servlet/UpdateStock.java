/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
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
@WebServlet(name = "UpdateStock", urlPatterns = {"/UpdateStock"})
public class UpdateStock extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Session s = NewHibernateUtil.getSessionFactory().openSession();
            int id = Integer.parseInt(req.getParameter("id"));
            String type = req.getParameter("type");
            String status = req.getParameter("status");

            if (status.equals("n/a")) {
                status = "na";
            }

            if (type.equals("loose")) {
                // updating loose items
                System.out.println("updating loose items");

                String product = req.getParameter("name").split("\\.")[0];
                String qty = req.getParameter("qty");
                String price = req.getParameter("price");

                Criteria prCriteria = s.createCriteria(Product.class).add(Restrictions.eq("idproduct", Integer.parseInt(product)));

                if (prCriteria.list().size() > 1) {
                    resp.getWriter().write("there are more products in this product name");
                } else {
                    Product pr = (Product) prCriteria.uniqueResult();
                    LooseStock stock = (LooseStock) s.load(LooseStock.class, id);

                    stock.setProduct(pr);
                    stock.setQty(Double.parseDouble(qty));
                    stock.setUprice(Double.parseDouble(price));
                    stock.setStatus(status);

                    s.update(stock);
                    s.beginTransaction().commit();
                    System.out.println("stock updated");
                    resp.getWriter().write("stock updated.");

                }

            } else if (type.equals("pkt")) {
                // updating pkt items
                System.out.println("updating pkt items");

                String packetid = req.getParameter("name").split("\\.")[0];
                String qty = req.getParameter("qty");
                String exp = req.getParameter("exp");
                String man = req.getParameter("man");
                String price = req.getParameter("price");

                Criteria pktCriteria = s.createCriteria(Packet.class).add(Restrictions.eq("id", Integer.parseInt(packetid)));
                if (pktCriteria.list().size() > 1) {
                    resp.getWriter().write("there are more packets in this name");
                } else {

                    Packet packet = (Packet) pktCriteria.uniqueResult();
                    PacketStock stock = (PacketStock) s.load(PacketStock.class, id);

                    stock.setPacket(packet);
                    stock.setPrice(Double.parseDouble(price));
                    stock.setQty(Integer.parseInt(qty));
                    Date expDate = new SimpleDateFormat("yyyy-MM-dd").parse(exp);
                    Date manDate = new SimpleDateFormat("yyyy-MM-dd").parse(man);

                    System.out.println("date compare :" + expDate.compareTo(manDate));

                    if (expDate.compareTo(manDate) == -1) {
                        resp.getWriter().write("expire date is wrong");
                    } else {
                        stock.setExp(expDate);
                        stock.setMan(manDate);

                        s.update(stock);
                        s.beginTransaction().commit();
                        System.out.println("stock updated");
                        resp.getWriter().write("stock updated");
                    }

                }

            }
            s.flush();
            s.close();

        } catch (NumberFormatException e) {
            resp.getWriter().write("inputwrong");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // updating pkg items
            Session s = NewHibernateUtil.getSessionFactory().openSession();

            System.out.println("updating pkg items");

            String id = null;
            String packageName = null;
            String price = null;
            String status = null;
            String desc = null;
            String cat = null;

            String image = null;
            String imgePath = null;

            boolean imgCreated = false;
            Category category = null;

            DiskFileItemFactory dfi = new DiskFileItemFactory();
            ServletFileUpload sfu = new ServletFileUpload(dfi);

            List<FileItem> list = sfu.parseRequest(req);

            for (FileItem i : list) {

                if (i.isFormField()) {

                    // is text
                    if (i.getFieldName().equals("id")) {
                        id = i.getString();
                        System.out.println("id is :" + id);
                    } else if (i.getFieldName().equals("name")) {
                        packageName = i.getString();
                        System.out.println("name is " + packageName);
                    } else if (i.getFieldName().equals("price")) {
                        price = i.getString();
                        System.out.println("price is " + price);
                    } else if (i.getFieldName().equals("status")) {
                        status = i.getString().replace("/", "");
                        System.out.println("status is " + status);
                    } else if (i.getFieldName().equals("desc")) {
                        desc = i.getString().replace("/", "");
                        System.out.println("desc is " + desc);
                    } else if (i.getFieldName().equals("cat")) {
                        cat = i.getString();
                        category = (Category) s.createCriteria(Category.class).add(Restrictions.eq("type", cat)).uniqueResult();
                        System.out.println("cat is " + cat);
                    } else if (i.getFieldName().equals("imgType")) {
                        image = i.getString();
                        System.out.println("imgeType is " + image);

                    }

                } else {
                    // is file

                    String mainPath = req.getServletContext().getRealPath("/").replace("build\\", "");
                    imgePath = mainPath + "img/itemImages/" + image;
                    System.out.println("main path " + mainPath);
                    File file = new File(imgePath);
                    i.write(file);
                    imgCreated = true;
                }

            }
            Packages stock = (Packages) s.load(Packages.class, Integer.parseInt(id));
            stock.setCategory(category);
            stock.setDescription(desc);
            stock.setPackageName(packageName);
            stock.setPrice(Double.parseDouble(price));
            stock.setStatus(status);
            if (imgCreated) {
                stock.setPackageImage("img\\itemImages\\" + image);
            }

            s.update(stock);
            s.beginTransaction().commit();
            System.out.println("stock updated");
            resp.getWriter().write("stock updated");

        } catch (NumberFormatException e) {
            resp.getWriter().write("input@0");
        } catch (FileUploadException ex) {
            Logger.getLogger(UpdateStock.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(UpdateStock.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
