/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import pojos.DiscountCodes;
import pojos.User;

/**
 *
 * @author nipun
 */
@WebServlet(name = "SetDiscount", urlPatterns = {"/SetDiscount"})
public class SetDiscount extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String users = req.getParameter("users");
        String message = req.getParameter("message");
        String value = req.getParameter("value");
        String date = req.getParameter("exp");
        System.out.println("users :" + users);

        Session s = NewHibernateUtil.getSessionFactory().openSession();

        try {
            JSONObject parse = (JSONObject) new JSONParser().parse(users);
            ArrayList userarray = (ArrayList) parse.get("id");

            for (int i = 0; i < userarray.size(); i++) {

                String uu = UUID.randomUUID().toString();
                String discountCode = DatatypeConverter.printHexBinary(MessageDigest.getInstance("MD5")
                        .digest(uu.getBytes("UTF-8"))).toLowerCase();

                Date exp = new SimpleDateFormat("yyyy-MM-dd").parse(date);

                if (exp.compareTo(new Date()) == -1) {
                    throw new Exception();
                }

                int userId = Integer.parseInt(userarray.get(i).toString());
                User user = (User) s.load(User.class, userId);

                if (user.getUsertype().getIdusertype() == 4) {
                    resp.getWriter().write("can't set discounts for this account type");
                } else {
                    List<DiscountCodes> list = s.createCriteria(DiscountCodes.class)
                            .add(Restrictions.eq("user", user))
                            .add(Restrictions.eq("status", "available")).list();

                    if (list.isEmpty()) {
                        DiscountCodes discount = new DiscountCodes();
                        discount.setCode(discountCode);
                        discount.setMessage(message);
                        discount.setExpDate(exp);
                        discount.setValue(Double.parseDouble(value));
                        discount.setUser(user);
                        discount.setStatus("available");

                        s.save(discount);
                    } else {
                        for (DiscountCodes discount : list) {
                            discount.setCode(discountCode);
                            discount.setMessage(message);
                            discount.setExpDate(exp);
                            discount.setValue(Double.parseDouble(value));
                            discount.setUser(user);
                            discount.setStatus("available");
                            
                            s.update(discount);
                        }
                    }
                }

            }
            s.beginTransaction().commit();
            s.flush();
            s.close();

            System.out.println("discouts assigned");
            resp.getWriter().write("done");

        } catch (ParseException | NoSuchAlgorithmException ex) {
            Logger.getLogger(SetDiscount.class.getName()).log(Level.SEVERE, null, ex);
        } catch (java.text.ParseException ex) {
            resp.getWriter().write("please input a correct date");
        } catch (NumberFormatException e) {
            resp.getWriter().write("please input a correct value");
        } catch (Exception ex) {
            resp.getWriter().write("expire date cannot be past");
        }

    }
}
