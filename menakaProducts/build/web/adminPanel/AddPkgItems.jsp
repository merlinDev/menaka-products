<%-- 
    Document   : AddPkgItems
    Created on : Jun 23, 2018, 7:04:57 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="pojos.PackagesHasProduct"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page import="pojos.Product"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Packages"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>

<%
    String pkg = request.getParameter("pkg-id");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../style/css/bootstrap.min.css">
        <title>add package items</title>

        <style>
            .item-add{
                margin: 20px;
                padding: 30px;
                border: solid 1px rgba(0,0,0,0.3);
                text-align: center;
            }
            .item-add input, select{
                width: 150px;
                margin: 20px;
            }
            ul li{
                margin: 10px;
            }
            ul small{
                float: right;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="row" style="margin-top: 200px">
                <div class="col-md-3"></div>
                <div class="col-md-4">
                    <div class="item-add" id="item-add">
                        <h5> add products to package </h5>
                        <form action="../savePackage" method="GET">

                            <input value="<%=pkg%>" name="pkg-id" style="display: none;">
                            <%

                                Session s = NewHibernateUtil.getSessionFactory().openSession();
                                List<Product> pr_list = s.createCriteria(Product.class)
                                        .add(Restrictions.eq("status", "available")).list();
                            %><select name="pkg-product"><%
                                for (Product elem : pr_list) {
                            %><option><%=elem.getIdproduct()%>.<%=elem.getProductname()%> (<%=elem.getType()%>)</option><%
                                    }
                                    %>
                            </select>
                            <br>
                            <input type="number" placeholder="quantitiy" name="pkg-qty">
                            <br>
                            <button type="submit" class="btn btn-outline-primary">add product to package</button>
                        </form>
                    </div>
                </div>

                <div class="col-md-4">

                    <ul>

                        <%
                            try {
                                Packages pkgitem = (Packages) s.load(Packages.class, Integer.parseInt(pkg));

                                List<PackagesHasProduct> list = s.createCriteria(PackagesHasProduct.class)
                                        .add(Restrictions.eq("packages", pkgitem)).list();
                                for (PackagesHasProduct elem : list) {
                        %>
                        <li> <%=elem.getProduct().getProductname()%> (<%=elem.getProduct().getType()%>) <small> <%=elem.getQty()%> kg. <button onclick="removeItem(<%=elem.getId()%>);" class="btn btn-sm btn-danger">remove</button></small> </li>
                            <%
                                    }
                                } catch (NumberFormatException e) {
                                    response.sendRedirect("../index.jsp");
                                }

                            %> 

                    </ul>

                </div>
            </div>
        </div>



        <script>
            function removeItem(id) {

                var con = confirm("are you sure ?");

                if (con) {
                    var request = new XMLHttpRequest();

                    request.onreadystatechange = function () {
                        if (request.readyState === 4 && request.status === 200) {
                            if (request.responseText === "item removed") {
                                alert(request.responseText);
                                window.location = "AddPkgItems.jsp?pkg-id=<%=pkg%>";
                            } else {
                                alert(request.responseText);
                            }
                        }
                    };
                    request.open("GET", "../RemovePkgItem?id=" + id, false);
                    request.send();
                }



            }
        </script>
    </body>
</html>
