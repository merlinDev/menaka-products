<%-- 
    Document   : InvoiceDetails
    Created on : Jun 23, 2018, 8:30:49 AM
    Author     : nipun
--%>

<%@page import="org.hibernate.Criteria"%>
<%@page import="pojos.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.Format"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Invicephoto"%>
<%@page import="pojos.InvoiceHasCartHasPackets"%>
<%@page import="pojos.InvoiceHasCartPackages"%>
<%@page import="pojos.InvoiceHasCartItem"%>
<%@page import="pojos.Invoice"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="style/invoice.css">
        <title>invoice details</title>

        <style>

        </style>

    </head>
    <body>
        <%

            String id = request.getParameter("id");
            request.getSession().setAttribute("page", "InvoiceDetails.jsp?id=" + id);
            Invoice invoice = null;

            Session s = NewHibernateUtil.getSessionFactory().openSession();
            invoice = (Invoice) s.load(Invoice.class, Integer.parseInt(id));

            if (request.getSession().getAttribute("user") != null) {
                User user = (User) request.getSession().getAttribute("user");

                Criteria c = s.createCriteria(Invoice.class)
                        .add(Restrictions.eq("user", user))
                        .add(Restrictions.eq("idinvoice", Integer.parseInt(id)));

                if (!c.list().isEmpty()) {
                    System.out.println("invoice found");
                    invoice = (Invoice) c.uniqueResult();
                } else {
                    System.out.println("invoice not found");
                    if (user.getUsertype().getIdusertype() == 4 || user.getUsertype().getIdusertype() == 1) {
                        System.out.println("showing as high level user");
                        invoice = (Invoice) s.load(Invoice.class, Integer.parseInt(id));
                    } else {
                        System.out.println("this user can't view this invoice");
                        response.sendError(response.SC_FORBIDDEN);
                        return;
                    }
                }
            } else {
                System.out.println("login first");
                response.sendRedirect("login.jsp");
            }

            Format format = new SimpleDateFormat("yyyy-MM-dd");
            String date = format.format(invoice.getDate());

            // pre invoices
            List<InvoiceHasCartItem> itemSet = s.createCriteria(InvoiceHasCartItem.class).add(Restrictions.eq("invoice", invoice)).list();
            List<InvoiceHasCartHasPackets> pktSet = s.createCriteria(InvoiceHasCartHasPackets.class).add(Restrictions.eq("invoice", invoice)).list();
            List<InvoiceHasCartPackages> pkgSet = s.createCriteria(InvoiceHasCartPackages.class).add(Restrictions.eq("invoice", invoice)).list();

            //invoices photos
            Invicephoto invPhoto = (Invicephoto) s.createCriteria(Invicephoto.class)
                    .add(Restrictions.eq("invoice", invoice)).uniqueResult();
        %>

        <br>
        <div class="container">
            <div class="row">

                <div class="col-md-12">
                    <center>
                        <div class="invoice" id="invoice">

                            <div style="width: 100%; background-color: #7f8c8d; color: white;padding: 10px;"> 
                                <img src="img/menaka-logo.png" class="logo"> <label> menaka products </label>
                            </div>
                            <br>
                            <center> <h4 class="name">invoice #<%=id%></h4> </center>

                            <div style="float: right;text-align: right;">
                                <label>issued for : <%=invoice.getUser().getName()%></label><br>
                                <label>date : <%=date%></label>
                            </div>
                            <br>
                            <br>
                            <br>

                            <%
                                if (!itemSet.isEmpty()) {
                            %><label class="name">spices</label><%
                            %><ul>
                                <%                                for (InvoiceHasCartItem elem : itemSet) {
                                %><li><%=elem.getCartHasItem().getLooseStock().getProduct().getProductname()%> - <%=elem.getQty()%> <small>kg.</small> <small class="price">Rs. <%=elem.getPrice()%></small></li><%
                                    }

                                    %>
                            </ul>
                            <%                                }
                            %>

                            <%
                                if (!pktSet.isEmpty()) {
                            %><label class="name">spicy packets</label><%
                            %><ul>
                                <%                                for (InvoiceHasCartHasPackets elem : pktSet) {
                                %><li><%=elem.getCartHasPackets().getPacketStock().getPacket().getName()%> - <%=elem.getQty()%> <small>packets.</small>  <small class="price">Rs. <%=elem.getPrice()%></small> </li><%
                                    }

                                    %>
                            </ul>
                            <%                                }
                            %>

                            <%
                                if (!pkgSet.isEmpty()) {
                            %><label class="name">packages</label><%
                            %><ul>
                                <%                                for (InvoiceHasCartPackages elem : pkgSet) {
                                %><li><%=elem.getCartHasPackages().getPackages().getPackageName()%> - <%=elem.getQty()%> <small>packages.</small> <small class="price">Rs. <%=elem.getPrice()%></small> </li><%
                                    }

                                    %>
                            </ul>


                            <%                                }
                            %>

                            <br>
                            <div style="text-align: right">
                                <label>sub total : Rs. <%=invoice.getSubTotal()%></label><br>
                                <small>voucher : Rs. <%=invoice.getDiscount()%></small>
                            </div>
                            <label style="float: right;" class="name tot">total : Rs. <%=invoice.getNetTotal()%></label>
                            <br><br><br><br>
                            <center>
                                <div class="action">
                                    <button onclick="printInvoice();" id="inv-print" class="btn btn-sm btn-outline-primary">print</button>
                                </div>
                            </center>

                        </div>

                        <%

                            if (invPhoto != null) {
                        %>

                        <div id="signed" class="photo">
                            <h4>Signed invoice</h4>
                            <img src="<%=invPhoto.getImageUrl()%>">
                            <br>
                            <button id="hide-btn1" class="btn btn-sm btn-dark" onclick="printPhoto();"> print </button>
                        </div>

                        <%
                            }

                        %>
                    </center>
                </div>
            </div>
        </div>


        <script>

            function printInvoice() {
                document.getElementById('signed').style.display = "none";
                document.getElementById('inv-print').style.display = "none";
                window.print();
                document.getElementById('signed').style.display = "block";
                document.getElementById('inv-print').style.display = "block";
            }

            function printPhoto() {
                document.getElementById('invoice').style.display = "none";
                document.getElementById('hide-btn1').style.display = "none";
                document.getElementById('hide-btn2').style.display = "none";
                window.print();
                document.getElementById('invoice').style.display = "block";
                document.getElementById('hide-btn1').style.display = "inline";
                document.getElementById('hide-btn2').style.display = "inline";
            }
        </script>
    </body>
</html>
