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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.CartHasItem;
import pojos.InvoiceHasCartPackages;
import pojos.Packages;
import pojos.PackagesHasProduct;
import pojos.Product;

/**
 *
 * @author nipun
 */
@WebServlet(name = "RemovePkgItem", urlPatterns = {"/RemovePkgItem"})
public class RemovePkgItem extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        
        
        Session s = NewHibernateUtil.getSessionFactory().openSession();
        
        PackagesHasProduct item = (PackagesHasProduct) s.load(PackagesHasProduct.class, Integer.parseInt(id));
        
        Packages pkg = item.getPackages();
        
        List<InvoiceHasCartPackages> list = s.createCriteria(InvoiceHasCartPackages.class).list();
        
        boolean inUse = false;
        
        for (InvoiceHasCartPackages invItems : list) {
            if (invItems.getInvoice().getStatus().equals("paid")) {  
                if (invItems.getCartHasPackages().getPackages().getIdpackages().equals(pkg.getIdpackages())) { // package in use
                    resp.getWriter().write("found pending dilveries on this package. this package can't be edit.");
                    System.out.println("in use");
                    inUse = true;
                    break;
                }else{
                    System.out.println("not in use");
                    inUse = false;
                }
            }else{
                System.out.println("no paid invoices");
                inUse = false;
                break;
            }
        }
        
        if (!inUse) { // pkg can be edited
                   
            
            s.delete(item);
            s.beginTransaction().commit();
            s.flush();
            s.close();
            
            resp.getWriter().write("item removed");           
        }
        
    }
}
