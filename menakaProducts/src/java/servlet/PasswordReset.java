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
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import pojos.Resetcode;
import pojos.User;

/**
 *
 * @author nipun
 */
@WebServlet(name = "PasswordReset", urlPatterns = {"/PasswordReset"})
public class PasswordReset extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String from = "menakaspiceproducts@gmail.com";
        String password = "4fourarms";
        String to = req.getParameter("email");

        org.hibernate.Session s = NewHibernateUtil.getSessionFactory().openSession();
        Criteria c = s.createCriteria(User.class).add(Restrictions.eq("email", to));
        if (!c.list().isEmpty()) {
            User user = (User) c.uniqueResult();
            Properties properties = new Properties();
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.host", "smtp.gmail.com");
            properties.put("mail.smtp.port", "587");

            Session session = Session.getInstance(properties,
                    new javax.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(from, password);
                        }
                    });

            try {
                MimeMessage msg = new MimeMessage(session);
                msg.setFrom(new InternetAddress(from));
                msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

                msg.setSubject("password reset on your menaka products account.");
                String userName = user.getName();

                String uu = UUID.randomUUID().toString();
                String resetCode = DatatypeConverter.printHexBinary(MessageDigest.getInstance("MD5")
                        .digest(uu.getBytes("UTF-8"))).toLowerCase();

                System.out.println("uu code: " + uu);
                System.out.println("reset code: " + resetCode);

                String text = userName + ", please paste this code on the password resetting page.<br><br>"
                        + "<h3>" + resetCode + "</h3><br><br>"
                        + "<small>(please note this code only valid for 5 minutes.)</small>";

                msg.setContent(text, "text/html");
                Transport.send(msg);

                Resetcode reset = new Resetcode();
                reset.setUser(user);
                reset.setCode(resetCode);
                s.save(reset);
                s.beginTransaction().commit();

                System.out.println("message sent!");
                resp.getWriter().write("send@1");

            } catch (AddressException ex) {
                Logger.getLogger(PasswordReset.class.getName()).log(Level.SEVERE, null, ex);
            } catch (MessagingException | NoSuchAlgorithmException ex) {
                Logger.getLogger(PasswordReset.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            resp.getWriter().write("sorry, this account is not valid");
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        
        org.hibernate.Session s = NewHibernateUtil.getSessionFactory().openSession();
        if (type.equals("verify")) {
            String code = req.getParameter("code");
            List<Resetcode> list = s.createCriteria(Resetcode.class).add(Restrictions.eq("code", code)).list();

            if (!list.isEmpty() && list.size() == 1) {
                resp.getWriter().write("verified@1");
            } else {
                resp.getWriter().write("verified@0");
            }

        } else if (type.equals("reset")) {
            String password = req.getParameter("password");
            String confirm = req.getParameter("confirm");
            String code = req.getParameter("code");
            System.out.println(code);
            if (password.equals(confirm)) {
                try {
                    String passwordHash = DatatypeConverter.printHexBinary(MessageDigest.getInstance("MD5")
                            .digest(password.getBytes("UTF-8"))).toLowerCase();
                    System.out.println(passwordHash);
                    Resetcode r = (Resetcode) s.createCriteria(Resetcode.class)
                            .add(Restrictions.eq("code", code)).uniqueResult();

                    User user = r.getUser();

                    user.setPassword(passwordHash);
                    s.update(user);
                    s.delete(r);
                    
                    s.beginTransaction().commit();
                    resp.getWriter().write("reset@1");

                } catch (NoSuchAlgorithmException ex) {
                    Logger.getLogger(PasswordReset.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else {
                resp.getWriter().write("passwords not matched");
            }
        }
    }

}
