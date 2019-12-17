<%-- 
    Document   : userGuide
    Created on : May 24, 2018, 11:58:59 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>user restriction</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="style/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

        <% User user = (User) request.getSession().getAttribute("user"); %>

        <section>
            <center>
                <div style="margin-top: 250px;margin:">
                    <h3> great..! your account created. </h3>
                    <%
                        if (user.getUsertype().getIdusertype() == 2) { // local
                    %><h5>we noticed you created  a local user account. that means you can now order those sweet package boxes. yay..!</h5><%
                            } else {
                            %><h5>we noticed you created  a shop user account. every product you order, we sell it to you on stock price. </h5><%
                            }
                    %>
                    <button style="margin-top: 20px;padding: 5px 20px;" class="btn btn-sm btn-primary" onclick="window.location = 'locations.jsp';"> set locations </button>
                    <button style="margin-top: 20px;padding: 5px 20px;" class="btn btn-sm btn-primary" onclick="window.location = 'index.jsp';"> go to home </button>
                </div>
            </center>
        </section>
    </body>
</html>
