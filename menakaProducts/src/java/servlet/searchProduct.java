///*
// * To change this license header, choose License Headers in Project Properties.
// * To change this template file, choose Tools | Templates
// * and open the template in the editor.
// */
//package servlet;
//
//import java.io.IOException;
//import java.util.List;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import org.hibernate.Criteria;
//import org.hibernate.classic.Session;
//import org.hibernate.criterion.MatchMode;
//import org.hibernate.criterion.Restrictions;
//import org.json.simple.JSONArray;
//import org.json.simple.JSONObject;
//import pojos.Product;
//
///**
// *
// * @author nipun
// */
//@WebServlet(name = "searchProduct", urlPatterns = {"/searchProduct"})
//public class searchProduct extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        
//        String keyword = req.getParameter("key");
//        System.out.println(keyword+"********************");
//        Session s = connection.NewHibernateUtil.getSessionFactory().openSession();
//
//        Criteria c = s.createCriteria(Product.class);
//        //c.add(Restrictions.like("itemName", keyword, MatchMode.ANYWHERE));
//        c.add(Restrictions.sqlRestriction("iditem LIKE '%"+keyword+"%' or itemName LIKE '%"+keyword+"%' or category_idcategory LIKE '%"+keyword+"'"));
//        //c.add(Restrictions.sqlRestriction("category_idcategory LIKE '%"+keyword+"'"));
//        
//        List<Product> list = c.list();
//        JSONArray array = new JSONArray();
//
//        for (Product item : list) {
//            JSONObject jo = new JSONObject();
//            jo.put("id", item.getIdproduct());
//            jo.put("name", item.getProductname());
//            jo.put("uPrice", item.getUprice());
//            jo.put("status", item.getStatus());
//            array.add(jo);
//        }
//        resp.getWriter().write(array.toJSONString());
//        System.out.println("#############" + array.toJSONString() + "#############");
//    }
//
//}
