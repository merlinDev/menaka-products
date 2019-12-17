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
import pojos.Packet;
import pojos.Product;

/**
 *
 * @author nipun
 */
@WebServlet(name = "savePacket", urlPatterns = {"/savePacket"})
public class savePacket extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {

            Session s = NewHibernateUtil.getSessionFactory().openSession();

            DiskFileItemFactory dfi = new DiskFileItemFactory();
            ServletFileUpload sfu = new ServletFileUpload(dfi);

            List<FileItem> list = sfu.parseRequest(req);

            String name = null;
            String gram = null;
            String imgeType = null;
            String imgePath = null;
            String type = null;

            boolean imgCreated = false;
            Product pr = null;
            for (FileItem i : list) {

                if (i.isFormField()) {

                    // is text
                    if (i.getFieldName().equals("pktName")) {
                        name = i.getString();
                        System.out.println(name + "name-----------");
                    } else if (i.getFieldName().equals("imgType")) {
                        imgeType = i.getString();
                    } else if (i.getFieldName().equals("type")) {
                        type = i.getString();
                    } else if (i.getFieldName().equals("gram")) {
                        gram = i.getString();
                        System.out.println(gram);
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

            if (name == null || gram == null) {
                resp.getWriter().write("fields are empty..");
            } else {

                Criteria c = s.createCriteria(Packet.class)
                        .add(Restrictions.eq("type", type))
                        .add(Restrictions.eq("name", name));

                if (c.list().isEmpty()) {
                    if (imgCreated) {
                        Packet pkt = new Packet();
                        pkt.setName(name);
                        pkt.setStatus("available");
                        pkt.setType(type);
                        pkt.setWeight(Double.parseDouble(gram));
                        System.out.println("right path : " + "itemImages\\" + imgeType);
                        pkt.setImg("img/itemImages/" + imgeType);
                        s.save(pkt);
                        s.beginTransaction().commit();
                        System.out.println("************* packet successfully saved ***************");
                        resp.getWriter().write("packet saved!");
                    }
                }else{
                    resp.getWriter().write("packet already in the list...");
                }

            }

        } catch (NumberFormatException e) {
            resp.getWriter().write("wrong input(s)");
        } catch (FileUploadException ex) {
            Logger.getLogger(saveProduct.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(saveProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
