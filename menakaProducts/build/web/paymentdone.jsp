<%-- 
    Document   : paymentdone
    Created on : Jun 24, 2018, 6:56:04 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="style/css/bootstrap.min.css" rel="stylesheet">  
        <title>payment complete!</title>

        <style>
            .message{
                background-color: #1179f4;
                color: white;
                padding: 40px;
            }
            .actions button{
                margin: 3px;
            }
        </style>
    </head>
    <body>

        <%
            String id = request.getParameter("inv-id");
        %>

        <div class="container">

            <div class="row">
                <div class="col">

                    <div class="message">
                        <h4> great! we received your payment. </h4>
                        <h5> your order's on your way. </h5><br>
                        <button class="btn btn-sm btn-outline-light" onclick="window.location = 'InvoiceDetails.jsp?id=<%=id%>'"> view the bill </button>
                        <br>
                        <br>
                        <br>
                        <p> make sure to checkout our other products. </p>
                        <div class="actions">
                            <button class="btn btn-sm btn-outline-light" onclick="window.location = 'index.jsp';"> go back to home </button>
                            <button class="btn btn-sm btn-outline-light" onclick="window.location = 'products.jsp';"> browse spices </button>
                            <button class="btn btn-sm btn-outline-light" onclick="window.location = 'packets.jsp';"> browse spicy packets </button>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
