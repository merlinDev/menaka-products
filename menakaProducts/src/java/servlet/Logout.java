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
import pojos.User;

/**
 *
 * @author nipun
 */
@WebServlet(name = "Logout", urlPatterns = {"/Logout"})
public class Logout extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("logouting.....................");
        
        Session s = NewHibernateUtil.getSessionFactory().openSession();
        
        if (req.getSession().getAttribute("user") != null) {
            String page = (String) req.getSession().getAttribute("page");
            User user = (User) req.getSession().getAttribute("user");
            if (user.getUsertype().getIdusertype() == 3) { // shop user
                if (page.equals("packages.jsp")) {
                    page = "index.jsp";
                }
            }
            
            if (page.equals("userAccount.jsp")) {
                page = "index.jsp";
            }
            
            user.setOoStatus("offline");
            req.getSession().removeAttribute("user");
            s.update(user);
            s.beginTransaction().commit();
            s.flush();
            s.close();
            req.getSession().removeAttribute("user");
            resp.sendRedirect(page);
            System.out.println("log out");
            
            servlet.Logger.doLog(user.getEmail(), "logged out");
        }else{
            resp.sendRedirect("login.jsp");
        }
        
    }
}
