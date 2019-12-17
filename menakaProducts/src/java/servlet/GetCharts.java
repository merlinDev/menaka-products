/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.json.simple.JSONArray;
import pojos.Invoice;

/**
 * @author nipun
 */
@WebServlet(name = "GetCharts", urlPatterns = {"/GetCharts"})
public class GetCharts extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Session s = NewHibernateUtil.getSessionFactory().openSession();
        String type = req.getParameter("type");
        
        if (type.equals("invoices")) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());

            int thisYear = cal.get(Calendar.YEAR);
            int thisMonth = cal.get(Calendar.MONTH) + 1;

            if (thisMonth == 13) {
                thisMonth = 1;
            }

            JSONArray array = new JSONArray();

            for (int i = 1; i < 13; i++) {  // 12 months
                thisMonth = i;

                String month = thisMonth + "";

                if (month.length() == 1) {
                    month = "0" + month;
                }

                String date = thisYear + "-" + month;
                System.out.println("date ::: " + date);

                List<Invoice> list = s.createCriteria(Invoice.class)
                        .add(Restrictions.eq("status", "closed"))
                        .add(Restrictions.sqlRestriction("date LIKE '" + date + "%'"))
                        .list();
                
                array.add(list.size());

                System.out.println("date " + date + ", invoices : " + list.size());
            }

            System.out.println(array.toJSONString());
            resp.getWriter().write(array.toJSONString());
        }

    }
}
