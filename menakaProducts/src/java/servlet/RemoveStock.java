/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.LooseStock;
import pojos.Packages;
import pojos.PacketStock;

/**
 *
 * @author nipun
 */
@WebServlet(name = "RemoveStock", urlPatterns = {"/RemoveStock"})
public class RemoveStock extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String type = req.getParameter("type");

        Session s = NewHibernateUtil.getSessionFactory().openSession();

        if (type.equals("loose")) {
            LooseStock stock = (LooseStock) s.createCriteria(LooseStock.class)
                    .add(Restrictions.eq("iditem", id)).uniqueResult();
            
            stock.setStatus("delete");
            s.update(stock);
            s.beginTransaction().commit();
            System.out.println("stock removed");
            resp.getWriter().write("remove@1");
            
        }else if (type.equals("pkt")) {
            PacketStock stock = (PacketStock) s.createCriteria(PacketStock.class)
                    .add(Restrictions.eq("id", id)).uniqueResult();
            
            stock.setStatus("delete");
            s.update(stock);
            s.beginTransaction().commit();
            System.out.println("stock removed");
            resp.getWriter().write("remove@1");
            
        }else if (type.equals("pkg")) {
            Packages pkg = (Packages) s.createCriteria(Packages.class)
                    .add(Restrictions.eq("idpackages", id)).uniqueResult();
            
            pkg.setStatus("delete");
            s.update(pkg);
            s.beginTransaction().commit();
            System.out.println("stock removed");
            resp.getWriter().write("remove@1");
            
        }
        s.flush();
        s.close();
        
    }
}
