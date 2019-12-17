/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.File;
import java.io.IOException;
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
import pojos.Product;

/**
 *
 * @author nipun
 */
@WebServlet(name = "saveProduct", urlPatterns = {"/saveProduct"})
public class saveProduct extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {

            Session s = NewHibernateUtil.getSessionFactory().openSession();

            DiskFileItemFactory dfi = new DiskFileItemFactory();
            ServletFileUpload sfu = new ServletFileUpload(dfi);

            List<FileItem> list = sfu.parseRequest(req);

            String name = null;
            String type = null;
            
            String imgeType = null;
            String imgePath = null;

            boolean imgCreated = false;

            for (FileItem i : list) {

                if (i.isFormField()) {

                    // is text
                    if (i.getFieldName().equals("prname")) {
                        name = i.getString();
                    } else if (i.getFieldName().equals("imgType")) {
                        imgeType = i.getString();
                    } else if (i.getFieldName().equals("type")) {
                        type = i.getString();
                    }

                } else {
                    // is file
                    String mainPath = req.getServletContext().getRealPath("/").replace("build\\", "");
                    imgePath = mainPath + "img/itemImages/" + imgeType;
                    System.out.println("main path " + mainPath);
                    File file = new File(imgePath);
                    i.write(file);
                    imgCreated = true;
                }

            }

            System.out.println("name : " + name);
            
            
            if (name == null) {
                resp.getWriter().write("");
                resp.getWriter().write("fields are empty..");
            } else {
                Criteria c = s.createCriteria(Product.class)
                        .add(Restrictions.eq("type", type))
                        .add(Restrictions.eq("productname", name));
                if (!c.list().isEmpty()) {
                    resp.getWriter().write("product already in the list...");
                } else {
                    if (imgCreated) {
                        Product item = new Product();
                        item.setProductname(name);
                        item.setType(type);
                        item.setStatus("available");
                        System.out.println("right path : " + "img\\itemImages\\" + imgeType);
                        item.setImg("img\\itemImages\\" + imgeType);
                        s.save(item);
                        s.beginTransaction().commit();
                        System.out.println("************* Item successfully saved ***************");
                        resp.getWriter().write("Product saved!");
                    }

                }

            }

        } catch (FileUploadException ex) {
            Logger.getLogger(saveProduct.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(saveProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
