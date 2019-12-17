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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import pojos.User;
import pojos.Usertype;

/**
 *
 * @author nipun
 */
@WebServlet(name = "userRegister", urlPatterns = {"/userRegister"})
public class userRegister extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("in servlet");
       User u = (User) req.getSession().getAttribute("user");
        if ((u == null) || u.getUsertype().getIdusertype() == 1) {
            Session s = NewHibernateUtil.getSessionFactory().openSession();
            Transaction t = s.beginTransaction();

            String uname = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String usertype = req.getParameter("usertype");

            Pattern pattern = Pattern.compile("^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$");

            try {
                if (!pattern.matcher(email).matches()) { // if false the email is valid
                    resp.getWriter().write("please enter a valid email address.");
                } else if (!uname.replace(" ", "").chars().allMatch(Character::isLetter)) {
                    resp.getWriter().write("please input a valid name");
                } else {

                    Criteria c = s.createCriteria(User.class);

                    c.add(Restrictions.eq("email", email));

                    if (uname.equals("")) {
                        // uname is null
                        resp.getWriter().write("username cannot be blanked!");
                    } else if (email.equals("")) {
                        // email is blanked
                        resp.getWriter().write("email cannot be blanked!");
                    } else if (password.equals("")) {
                        resp.getWriter().write("password cannot be blanked!");
                    } else if (password.length() < 8) {
                        resp.getWriter().write("password  must be at least 9 characters!");
                    } else {
                        // good to go

                        if (c.list().isEmpty()) {
                            // username valids

                            try {
                                String hash_password = DatatypeConverter.printHexBinary(MessageDigest.getInstance("MD5")
                                        .digest(password.getBytes("UTF-8"))).toLowerCase();

                                System.out.println("password : " + hash_password);

                                User user = new User();
                                user.setName(uname);
                                user.setEmail(email);
                                user.setPassword(hash_password);
                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
                                Date date = new Date();
                                Date today = dateFormat.parse(dateFormat.format(date));
                                Usertype type = (Usertype) s.load(Usertype.class, Integer.parseInt(usertype));
                                user.setUsertype(type);
                                user.setDate(today);
                                user.setStatus(true);
                                user.setOoStatus("offline");

                                System.out.println("done!");

                                s.save(user);
                                t.commit();
                                s.flush();
                                System.out.println("user saved!");
                                resp.getWriter().write("user_saved");

                                Criteria c1 = s.createCriteria(User.class);
                                c1.add(Restrictions.eq("email", email));
                                c1.add(Restrictions.eq("password", hash_password));

                                User sessionUser = (User) c1.uniqueResult();

                                if (sessionUser.getUsertype().getIdusertype() != 4) {
                                    
                                    System.out.println("redirecting to login");

                                    servlet.Logger.doLog(uname, "this user registered using the email " + email);
                                }else{
                                    sessionUser.setOoStatus("offline");
                                    s.beginTransaction().commit();
                                    s.flush();
                                }
                                
                                s.close();  

                            } catch (NoSuchAlgorithmException | ParseException ex) {
                                Logger.getLogger(userRegister.class.getName()).log(Level.SEVERE, null, ex);
                            }

                        } else {
                            // username or email already has been taken
                            resp.getWriter().write("this email already exists.");
                        }

                    }
                }
            } catch (NumberFormatException e) {
                resp.getWriter().write("oops... something went wrong. try again later.");
            }

        } else {
            resp.getWriter().write("logout first");
        }
    }

}
