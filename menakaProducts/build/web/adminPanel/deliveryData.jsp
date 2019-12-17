<%-- 
    Document   : deliveries
    Created on : Jul 2, 2018, 4:45:45 PM
    Author     : nipun
--%>

<%@page import="java.util.Set"%>
<%@page import="pojos.Invicephoto"%>
<%@page import="pojos.User"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <title>deliveries</title>

        <style>
            h4{
                width: 650px;
                font-weight: bold;
                text-align: left;
            }
            h6{
                padding: 5px;
                color: lightgrey;
                background-color: #212529;
                width: 650px;
                font-weight: bold;
                text-align: left;
            }
            h5{
                width: 650px;
                text-align: left;

            }
        </style>
    </head>
    <body>

        <%

            String id = request.getParameter("user");
            Session s = NewHibernateUtil.getSessionFactory().openSession();
            User user = (User) s.load(User.class, Integer.parseInt(id));

            Set<Invicephoto> set = user.getInvicephotos();
        %>

    <center>
        <div style="margin: 30px; border: solid 1px rgba(0,0,0,0.4);width: 700px;padding: 20px;">
            <div>
                <div style="text-align: right;width: 650px;">
                    <button id="pr" onclick="printData();" class="btn btn-sm btn-outline-dark" style="width: 90px; border-radius: 0"> print</button>
                </div>
                <h5>MENAKA PRODUCTS</h5>
                <h4> <%=user.getName()%>'s deliveries</h4>
            </div>
            <h6> count : <%=set.size()%> deliveries </h6>
            <div class="row">
                <div class="col">
                    <div class="table">
                        <table style="width: 650px;">
                            <thead class="thead-dark">
                                <tr>
                                    <th></th>
                                    <th>date</th>
                                    <th>issued for</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    for (Invicephoto elem : set) {
                                %><tr>
                                    <td>#<%=elem.getInvoice().getIdinvoice()%></td>
                                    <td><%=elem.getInvoice().getDate()%></td>
                                    <td><%=elem.getInvoice().getUser().getEmail()%></td>
                                </tr><%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </center>




    <script>
        function printData() {
            document.getElementById("pr").style.display = "none";
            window.print();
            document.getElementById("pr").style.display = "inline";
        }
    </script>
</body>
</html>
