/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package listeners;

import connection.NewHibernateUtil;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import org.hibernate.Session;
import pojos.User;

/**
 *
 * @author nipun
 */
public class SessionListener implements HttpSessionListener{

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        System.out.println("session ::::"+se.getSession()+ " created");
        
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        System.out.println("session ::::"+se.getSession()+ " destroyered");
        
        if (se.getSession().getAttribute("user") != null) {
            
            User user = (User) se.getSession().getAttribute("user");
            Session s = NewHibernateUtil.getSessionFactory().openSession();
            
            // setting user offline
            user.setOoStatus("offline");
            s.update(user);
            s.beginTransaction().commit();
            s.flush();
            s.close();
            System.out.println("user set to offline");
            se.getSession().invalidate();
            
            servlet.Logger.doLog(user.getEmail(), "logged out due to session timeout");
            
        }
    }
}

