/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.EOFException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import pojos.Deliverydata;
import pojos.Zip;

/**
 *
 * @author nipun
 */
@WebServlet(name = "SaveZip", urlPatterns = {"/SaveZip"})
public class SaveZip extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            String zipcode = req.getParameter("zipcode");
            String charge = req.getParameter("charge");

            Session s = NewHibernateUtil.getSessionFactory().openSession();

            Zip zip = new Zip();
            zip.setZipcode(zipcode);
            zip.setCharge(Double.parseDouble(charge));

            s.save(zip);
            s.beginTransaction().commit();

            s.flush();
            s.close();

            resp.getWriter().write("zip@1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("error@1");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {

            String via = req.getParameter("via");
            String range = req.getParameter("range");
            String charge = req.getParameter("charge");
            
            System.out.println(via);
            System.out.println(range);
            System.out.println(charge);

            Session s = NewHibernateUtil.getSessionFactory().openSession();

            List<Deliverydata> list = s.createCriteria(Deliverydata.class).list();
            
            if (list.size() > 1) {
                throw new EOFException();
            }
            
            if (list.isEmpty()) {
                Deliverydata data = new Deliverydata();
                data.setDeliveryType(via);
                data.setMinKm(Double.parseDouble(range));
                data.setChargePerKm(Double.parseDouble(charge));

                s.save(data);

            } else {
                Deliverydata data = list.get(0);
                data.setDeliveryType(via);
                data.setMinKm(Double.parseDouble(range));
                data.setChargePerKm(Double.parseDouble(charge));

                s.update(data);
            }

            s.beginTransaction().commit();
            s.flush();
            s.close();
            
            resp.getWriter().write("change@1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("error@1");
        }

    }
}
