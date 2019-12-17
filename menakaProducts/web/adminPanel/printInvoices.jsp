<%-- 
    Document   : printInvoices
    Created on : Jun 24, 2018, 11:07:53 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Invoice"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <title>invoices</title>
    </head>
    <body onload="printInvoice();">

        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <br>
                    <br>
                    <center>
                        <div class="table table-responsive">
                            <table style="width: 700px;">

                                <thead class="thead-dark">
                                    <tr>
                                        <th> # </th>
                                        <th> user </th>
                                        <th> date </th>
                                        <th> total </th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <%
                                        Session s = NewHibernateUtil.getSessionFactory().openSession();

                                        List<Invoice> invoice_list = s.createCriteria(Invoice.class)
                                                .add(Restrictions.eq("status", "closed")).list();

                                        for (Invoice invoice : invoice_list) {
                                    %><tr>
                                        <td><%=invoice.getIdinvoice()%></td>
                                        <td><%=invoice.getUser().getName()%></td>
                                        <td><%=invoice.getDate()%></td>
                                        <td>Rs. <%=invoice.getNetTotal()%></td>
                                    </tr><%
                                        }
                                    %>

                                </tbody>

                            </table>
                        </div>
                    </center>

                </div>
            </div>
        </div>


        <script>
            function printInvoice() {
                window.print();
            }
        </script>
    </body>
</html>
