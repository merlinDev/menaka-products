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
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.Location;
import pojos.User;
import pojos.Zip;

/**
 *
 * @author nipun
 */
@WebServlet(name = "SaveUserDetails", urlPatterns = {"/SaveUserDetails"})
public class SaveUserDetails extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        System.out.println(type);
        int id = Integer.parseInt(req.getParameter("id"));

        Session s = NewHibernateUtil.getSessionFactory().openSession();
        User user = (User) s.createCriteria(User.class).add(Restrictions.eq("iduser", id)).uniqueResult();

        if (type.equals("info")) {  // basic info change
            String name = req.getParameter("name");
            if (!name.replace(" ", "").chars().allMatch(Character::isLetter)) {
                resp.getWriter().write("name@0");
            } else {
                user.setName(req.getParameter("name"));
                s.update(user);
                s.beginTransaction().commit();

                req.getSession().setAttribute("user", user);
                resp.getWriter().write("name@1");
            }

        } else if (type.equals("location")) { // address change
            Location location = (Location) s.createCriteria(Location.class)
                    .add(Restrictions.eq("idlocation", id)).uniqueResult();

            try {
                String address = req.getParameter("address");
                String street = req.getParameter("street");
                String zip = req.getParameter("zip");

                location.setAddress(address);
                location.setStreet(street);

                Zip zipcode = (Zip) s.createCriteria(Zip.class).add(Restrictions.eq("zipcode", zip)).uniqueResult();

                if (zipcode != null) {
                    location.setZip(zipcode);
                    s.update(location);
                    s.beginTransaction().commit();
                    resp.getWriter().write("location@1");
                } else {
                    resp.getWriter().write("zip@0");
                }

            } catch (NumberFormatException e) {
                resp.getWriter().write("zip@0");
            }

        } else if (type.equals("password")) { // password change
            String oldPass = req.getParameter("old");
            String newPass = req.getParameter("newPass");
            String confirm = req.getParameter("confirm");

            if (newPass.equals("")) {
                resp.getWriter().write("password cannot be blanked!");
            } else if (newPass.length() < 8) {
                resp.getWriter().write("password  must be at least 9 characters!");
            } else {

                try {
                    String old_hash = DatatypeConverter.printHexBinary(MessageDigest.getInstance("MD5")
                            .digest(oldPass.getBytes("UTF-8"))).toLowerCase();

                    System.out.println("pass :" + user.getPassword());
                    System.out.println(old_hash);

                    if (user.getPassword().equals(old_hash)) { // password matches
                        if (newPass.equals(confirm)) {

                            String newPass_hash = DatatypeConverter.printHexBinary(MessageDigest.getInstance("MD5")
                                    .digest(newPass.getBytes("UTF-8"))).toLowerCase();

                            user.setPassword(newPass_hash);
                            s.update(user);
                            s.beginTransaction().commit();
                            resp.getWriter().write("password@1");

                        } else {
                            resp.getWriter().write("password confirmation is wrong");
                        }
                    } else {
                        resp.getWriter().write("old password not correct");
                    }

                } catch (NoSuchAlgorithmException ex) {
                    Logger.getLogger(SaveUserDetails.class.getName()).log(Level.SEVERE, null, ex);
                }

            }

        }

        s.flush();
        s.close();
    }
}
