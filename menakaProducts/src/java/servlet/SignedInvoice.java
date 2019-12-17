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
import java.util.Set;
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
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.CartHasItem;
import pojos.CartHasPackages;
import pojos.CartHasPackets;
import pojos.Invicephoto;
import pojos.Invoice;
import pojos.InvoiceHasCartHasPackets;
import pojos.InvoiceHasCartItem;
import pojos.InvoiceHasCartPackages;
import pojos.User;

/**
 *
 * @author nipun
 */
@WebServlet(name = "SignedInvoice", urlPatterns = {"/SignedInvoice"})
public class SignedInvoice extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {

            DiskFileItemFactory dfi = new DiskFileItemFactory();
            ServletFileUpload sfu = new ServletFileUpload(dfi);

            List<FileItem> list = sfu.parseRequest(req);

            String invoiceDetails = null;
            Invoice invoice = null;

            boolean photoadded = false;

            Session s = NewHibernateUtil.getSessionFactory().openSession();

            for (FileItem file : list) {

                if (file.isFormField()) {
                    if (file.getFieldName().equals("id")) {
                        int invId = Integer.parseInt(file.getString());

                        invoice = (Invoice) s.load(Invoice.class, invId);
                    }

                } else {

                    String mainPath = req.getServletContext().getRealPath("/").replace("build\\", "");

                    invoiceDetails = "INV_" + invoice.getIdinvoice() + "_" + invoice.getDate();

                    String imgePath = mainPath + "img/invoices/" + invoiceDetails;
                    System.out.println("main path " + mainPath);
                    File imgfile = new File(imgePath);
                    file.write(imgfile);
                    photoadded = true;

                    System.out.println("invoice photo added........");
                }

            }

            if (photoadded) {

                List<Invicephoto> inv_list = s.createCriteria(Invicephoto.class).add(Restrictions.eq("invoice", invoice)).list();

                if (inv_list.isEmpty()) { // no photos foud 
                    Invicephoto inv = new Invicephoto();
                    inv.setInvoice(invoice);
                    inv.setImageUrl("img\\invoices\\" + invoiceDetails);

                    User deluser = (User) req.getSession().getAttribute("user");
                    inv.setUser(deluser);
                    
                    s.save(inv);
                    s.beginTransaction().commit();

                    System.out.println("img path saved........");
                } else {
                    
                    User user = (User) req.getSession().getAttribute("user");
                    
                    Invicephoto inv = inv_list.get(0);
                    inv.setImageUrl("img\\invoices\\" + invoiceDetails);
                    inv.setUser(user);
                    s.update(inv);
                    s.beginTransaction().commit();
                }

                s.flush();
                s.close();

                resp.getWriter().write("done");
            }

        } catch (FileUploadException ex) {
            Logger.getLogger(SignedInvoice.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(SignedInvoice.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        System.out.println("on close delivery");
        
        int id = Integer.parseInt(req.getParameter("id"));

        Session s = NewHibernateUtil.getSessionFactory().openSession();

        Invoice invoice = (Invoice) s.load(Invoice.class, id);

        List<Invicephoto> list = s.createCriteria(Invicephoto.class)
                .add(Restrictions.eq("invoice", invoice)).list();

        if (list.isEmpty()) { // no photo
            resp.getWriter().write("nophoto");
        } else {

            Set<InvoiceHasCartItem> itemlist = invoice.getInvoiceHasCartItems();
            for (InvoiceHasCartItem item : itemlist) {
                CartHasItem cartItem = item.getCartHasItem();
                cartItem.setStatus("closed");
            }

            Set<InvoiceHasCartHasPackets> pktlist = invoice.getInvoiceHasCartHasPacketses();
            for (InvoiceHasCartHasPackets item : pktlist) {
                CartHasPackets cartpkt = item.getCartHasPackets();
                cartpkt.setStatus("closed");
            }

            Set<InvoiceHasCartPackages> pkglist = invoice.getInvoiceHasCartPackageses();
            for (InvoiceHasCartPackages item : pkglist) {
                CartHasPackages cartPkg = item.getCartHasPackages();
                cartPkg.setStatus("closed");
            }

            invoice.setStatus("closed");
            s.update(invoice);
            s.beginTransaction().commit();
            System.out.println("invoice closed....");
            
            resp.getWriter().write("inv@close");

        }
    }
}
