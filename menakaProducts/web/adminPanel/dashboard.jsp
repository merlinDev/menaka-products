<%-- 
    Document   : dashboard
    Created on : May 17, 2018, 7:30:44 PM
    Author     : nipun
--%>

<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Invoice"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page import="pojos.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <title>admin panel</title>

        <style>

            .menu ul{
                margin: 0;
                padding: 0;
                overflow: hidden;
                list-style-type: none;

            }
            .menu ul li{
                float: left;
                padding: 10px;
                background-color: #1d2124;
                color: white;
            }
            .menu ul li a{
                display: block;
                text-decoration: none;
                color: white;
            }
            .menu ul li:hover{
                background: gray;
            }
            .data *{
                margin: 10px 0;
            }
            .data input{
                width: 270px;
                padding: 5px 10px;
                border: solid 1px rgba(0,0,0,0.3);
            }
            .data{
                margin: 50px;
            }
            h6{
                font-weight: 300 !important;
            }
            .admin-items{
                text-align: right;

            }
        </style>
    </head>
    <body>
        <div class="row" style="margin: 30px;background-color: black;">

            <div class="col-md-4">
                <h4 style="font-weight: 300;color: white;margin-top: 20px;">ADMINISTRATOR PANEL</h4>
            </div>
            <div class="col-md-8">
                <div class="menu">
                    <ul> 
                        <li><a target="_blank" href="users.jsp">users</a></li> 
                        <li><a target="_blank" href="stock.jsp">stocks</a></li>
                        <li><a target="_blank" href="addProduct.jsp">add products</a></li>             
                        <li><a target="_blank" href="../empPanel/deliveries.jsp">deliveries and invoices</a></li>             
                        <li><a target="_blank" href="zipcodes.jsp">locations</a></li>             
                        <li><a target="_blank" href="deliverymen.jsp">delivery men</a></li>             
                    </ul>
                </div>
            </div>

            <div class="col-md-12" style="color: white;">
                <div class="row">
                    <div class="col-md-4">
                        <div class="data">
                            <h1>WELCOME</h1>
                            <h3><%=u.getName()%></h3>

                            <h4> Email : <%=u.getEmail()%></h4>
                            <br>
                            <form action="../ChangeAdminDetails" method="POST">
                                <input name="old" type="password" placeholder="current password"><br>
                                <input name="new" type="password" placeholder="new password"><br>
                                <input name="con" type="password" placeholder="confirm"><br>
                                <input class="btn btn-sm btn-primary" style="border-radius: 0;" type="submit" value="change password">
                            </form>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <div class="admin-items">
                            <%
                                Session s = NewHibernateUtil.getSessionFactory().openSession();
                                List<Invoice> list = s.createCriteria(Invoice.class).add(Restrictions.eq("status", "closed")).list();
                                List<Invoice> listPend = s.createCriteria(Invoice.class).add(Restrictions.eq("status", "paid")).list();
                                double income = 0;
                                for (Invoice elem : list) {
                                    income += elem.getNetTotal();
                                }

                            %>
                            <div>
                                <p> closed invoices : <%=list.size()%></p>
                                <p> pending invoices : <%=listPend.size()%></p>
                                <h5 style="font-weight: bold"> invoices income : Rs. <%=income%></h5>
                            </div>
                            <a href="../index.jsp" style="margin-top: 50px;border-radius: 0" class=" btn btn-sm btn-outline-light"> Menaka Products </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
