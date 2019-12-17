/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.Category;
import pojos.Packages;
import pojos.PackagesHasProduct;
import pojos.Product;

/**
 *
 * @author nipun
 */
@WebServlet(name = "savePackage", urlPatterns = {"/savePackage"})
public class savePackage extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {

            Session s = NewHibernateUtil.getSessionFactory().openSession();

            DiskFileItemFactory dfi = new DiskFileItemFactory();
            ServletFileUpload sfu = new ServletFileUpload(dfi);

            List<FileItem> list = sfu.parseRequest(req);

            String name = null;
            String desc = null;
            String cat = null;
            String price = null;

            String imgeType = null;
            String imgePath = null;

            boolean imgCreated = false;
            Category category = null;
            for (FileItem i : list) {

                if (i.isFormField()) {

                    // is text
                    if (i.getFieldName().equals("pkgName")) {
                        name = i.getString();
                        System.out.println(name + "name-----------");
                    } else if (i.getFieldName().equals("pkgDesc")) {
                        desc = i.getString();
                    } else if (i.getFieldName().equals("imgType")) {
                        imgeType = i.getString();
                    } else if (i.getFieldName().equals("pkgPrice")) {
                        price = i.getString();
                    } else if (i.getFieldName().equals("pkgCat")) {
                        cat = i.getString();
                        System.out.println(cat + "category------------");
                        Criteria c = s.createCriteria(Category.class);
                        c.add(Restrictions.eq("type", cat));
                        category = (Category) c.uniqueResult();

                    }

                } else {
                    // is file
                    String mainPath = req.getServletContext().getRealPath("/").replace("build\\", "");
                    imgePath = mainPath + "img/itemImages/" + imgeType;
                    System.out.println("main path " + mainPath);
                    File file = new File(imgePath);
                    i.write(file);
                    imgCreated = true;
                }

            }

            if (name == null || desc == null || price == null || cat == null) {
                resp.getWriter().write("fields are empty..");
            } else {

                if (imgCreated) {
                    Packages packages = new Packages();
                    packages.setPackageName(name);
                    packages.setDescription(desc);
                    packages.setCategory(category);
                    packages.setStatus("available");
                    packages.setPrice(Double.parseDouble(price));
                    System.out.println("right path : " + "itemImages\\" + imgeType);
                    packages.setPackageImage("img\\itemImages\\" + imgeType);
                    s.save(packages);
                    s.beginTransaction().commit();
                    System.out.println("************* package successfully saved ***************");
                    resp.getWriter().write("package saved!");
                }

            }

        } catch (FileUploadException ex) {
            Logger.getLogger(saveProduct.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(saveProduct.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            String pkgid = req.getParameter("pkg-id");
            String productId = req.getParameter("pkg-product").split("\\.")[0];
            String qty = req.getParameter("pkg-qty");

            Session s = NewHibernateUtil.getSessionFactory().openSession();
            Packages pkg = (Packages) s.createCriteria(Packages.class)
                    .add(Restrictions.eq("idpackages", Integer.parseInt(pkgid))).uniqueResult();
            Product product = (Product) s.createCriteria(Product.class)
                    .add(Restrictions.eq("idproduct", Integer.parseInt(productId))).uniqueResult();

            List<PackagesHasProduct> list = s.createCriteria(PackagesHasProduct.class)
                    .add(Restrictions.eq("packages", pkg))
                    .add(Restrictions.eq("product", product)).list();

            if (list.isEmpty()) {
                PackagesHasProduct item = new PackagesHasProduct();
                item.setPackages(pkg);
                item.setProduct(product);
                item.setQty(Double.parseDouble(qty));

                s.save(item);
                s.beginTransaction().commit();
                
                s.flush();
                s.close();
                resp.getWriter().write("package item added");
            }else{
                PackagesHasProduct item = list.get(0);
                item.setQty(Double.parseDouble(qty) + item.getQty());
                s.update(item);
                s.beginTransaction().commit();
                s.flush();
                s.close();
                
                resp.getWriter().write("package item qty updated");
            }
            
            resp.sendRedirect("adminPanel/AddPkgItems.jsp?pkg-id="+pkgid);
        }catch(NumberFormatException e){
            resp.getWriter().write("inmputs are wrong");
        }catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("something went wrong");
        }
    }

}
