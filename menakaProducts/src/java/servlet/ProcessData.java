/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.json.simple.JSONObject;
import pojos.Deliverydata;
import pojos.Location;
import pojos.User;
import pojos.Zip;

/**
 *
 * @author nipun
 */
@WebServlet(name = "ProcessData", urlPatterns = {"/ProcessData"})
public class ProcessData extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String address = req.getParameter("address");

            Session s = NewHibernateUtil.getSessionFactory().openSession();

            System.out.println(address);
            User user = (User) req.getSession().getAttribute("user");

            Criteria c = s.createCriteria(Location.class).add(Restrictions.eq("idlocation", Integer.parseInt(address)));

            List<Location> list = c.list();
            if (list.isEmpty()) {
                resp.getWriter().write("something wrong with the address");
            } else {

                // good to go
                Location location = (Location) c.uniqueResult();

                double total = new GetDBTotal().getTotal(user);
                double voucher = 0;

                if (req.getSession().getAttribute("voucher") != null) {
                    voucher = (double) req.getSession().getAttribute("voucher");
                    req.getSession().setAttribute("voucher", null);
                }

                Deliverydata data = (Deliverydata) s.createCriteria(Deliverydata.class).uniqueResult();
                String delType = data.getDeliveryType();

                double charge = 0;
                Zip zipcode = (Zip) s.load(Zip.class, location.getZip().getIdzip());
                if (delType.equals("km")) {
                    if (location.getLat() == 0 || location.getLang() == 0) { // can'nt find distance
                        charge = zipcode.getCharge();
                    } else {
                        try {
                            String origin = data.getDeliveryPoint();
                            String destination = location.getLat() + "," + location.getLang();
                            
                            double distance = new Distance().GetDistance(origin, destination);
                            charge = distance * data.getChargePerKm();

                        } catch (org.json.simple.parser.ParseException ex) {
                            Logger.getLogger(ProcessData.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }

                if (delType.equals("zip")) {
                    charge = zipcode.getCharge();
                }

                charge = Double.parseDouble(new DecimalFormat("#.##").format(charge));

                JSONObject paymentData = new JSONObject();
                paymentData.put("user", user);
                paymentData.put("location", location);
                paymentData.put("total", total);
                paymentData.put("voucher", voucher);
                paymentData.put("deliverycharge", charge);

                HttpSession paysession = req.getSession();

                // payment invalidates after 10 mins
                paysession.setMaxInactiveInterval(600);
                paysession.setAttribute("paymentData", paymentData);

                System.out.println("paymentData session created");

                User sessionUser = (User) paymentData.get("user");
                Location sessionLocation = (Location) paymentData.get("location");
                double sessiontotal = (double) paymentData.get("total");
                double sessionvoucher = (double) paymentData.get("voucher");

                System.out.println("testing session");
                System.out.println("---------------------------");
                System.out.println("user :" + sessionUser.getName());
                System.out.println("address :" + sessionLocation.getAddress());
                System.out.println("total :" + sessiontotal);
                System.out.println("voucher :" + sessionvoucher);
                System.out.println("---------------------------");

                resp.getWriter().write("feild@1");
            }

        }catch(NumberFormatException e){
            resp.getWriter().write("location@0");
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

}
