<%-- 
    Document   : deliveries
    Created on : Jun 22, 2018, 5:53:42 PM
    Author     : nipun
--%>

<%@page import="org.hibernate.criterion.MatchMode"%>
<%@page import="org.hibernate.Criteria"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="pojos.InvoiceHasCartPackages"%>
<%@page import="pojos.InvoiceHasCartHasPackets"%>
<%@page import="pojos.Location"%>
<%@page import="pojos.Invoice"%>
<%@page import="pojos.InvoiceHasCartItem"%>
<%@page import="pojos.CartHasPackages"%>
<%@page import="pojos.CartHasPackets"%>
<%@page import="java.util.Set"%>
<%@page import="pojos.Cart"%>
<%@page import="pojos.CartHasItem"%>
<%@page import="java.util.List"%>
<%@page import="pojos.Usertype"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.User"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="EmpRestrictions.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
        <link rel="stylesheet" type="text/css" href="../SnackBar/snackbar.min.css">
        <title>deliveries</title>
    </head>

    <style>
        body{
            background-color: #f1f2f6;
        }
        .name{
            font-weight: bold;
        }
        .actions{
            float: right;
            margin: 20px 0;
            text-align: right;
        }
        .actions button{
            width: 120px;
        }
        .crd{
            border-radius: 0 !important;
            background-color: #34495e;
        }
        .crd button{
            color: white;
        }
        .crd button:hover{
            text-decoration: none;
        }
        .crd button:focus{
            outline: none;
        }
        .order{
            margin: 0 auto;
            width: 500px;
        }
        input{            
            padding: 3px 10px;
            border-radius: 3px;
            border: solid 1px rgba(0,0,0,0.3);
        }
        #accordion{
            height: auto;
        }
        .search-box input, .search-box button,.search-box a{
            width: 260px;
            margin-top: 10px;
        }
        .search-box{
            margin: 30px;
        }

        @media only screen and (max-width: 780px){
            .order{
                width: 280px;
            }

        }

        .sum{
            padding: 10px;
            background-color: #f1f2f6;
        }
        .action-div{
            border-radius: 3px;
            padding: 20px;
            background-color: white;
        }

    </style>
    <body onload="getCharts()">
        <div class="main">
            <div class="row">
                <div class="search-box">
                    <input type="text" id="search" placeholder="quick search..."><br>
                    <button class="btn btn-sm btn-dark" onclick="scrl();"> show closed invoices </button><br>
                    <a href="../index.jsp" class="btn btn-sm btn-primary"> go to home page </a>
                </div>
            </div>

            <div id="accordion">

                <%                    Session s = NewHibernateUtil.getSessionFactory().openSession();

                    List<Invoice> fullList = s.createCriteria(Invoice.class).add(Restrictions.eq("status", "closed")).list();
                    int fullInvoices = fullList.size();
                    int shopInvoices = 0;
                    int localInvoices = 0;
                    List<User> userLisr = s.createCriteria(User.class).list();

                    for (User user : userLisr) {

                        if (user.getUsertype().getIdusertype() == 2) {

                            System.out.println("shop usersssssssssss");

                            localInvoices += s.createCriteria(Invoice.class)
                                    .add(Restrictions.eq("user", user))
                                    .add(Restrictions.eq("status", "closed")).list().size();

                        }

                        if (user.getUsertype().getIdusertype() == 3) {
                            shopInvoices += s.createCriteria(Invoice.class)
                                    .add(Restrictions.eq("user", user))
                                    .add(Restrictions.eq("status", "closed")).list().size();

                        }

                        Criteria c = s.createCriteria(Invoice.class)
                                .add(Restrictions.eq("user", user))
                                .add(Restrictions.eq("status", "paid"));

                        List<Invoice> inv_list = c.list();

                        if (!inv_list.isEmpty()) {
                            for (Invoice invoice : inv_list) {

                                Location location = invoice.getLocation();

                %>

                <div id="orders" class="order">
                    <div class="card">
                        <div class="card-header crd" id="heading-<%=invoice.getIdinvoice()%>">
                            <h5 class="mb-0">
                                <button class="btn btn-link" data-toggle="collapse" data-target="#collapse-<%=invoice.getIdinvoice()%>" aria-expanded="true" aria-controls="collapse-<%=invoice.getIdinvoice()%>">

                                    <%
                                        String date = new SimpleDateFormat("yyyy-MM-dd").format(invoice.getDate());
                                    %>


                                    <%=invoice.getUser().getName()%> <small><%=date%></small>
                                </button>
                            </h5>

                            <small style="float: right;color: white;">invoice : <%=invoice.getIdinvoice()%></small>
                        </div>

                        <div id="collapse-<%=invoice.getIdinvoice()%>" class="collapse show" aria-labelledby="heading-<%=invoice.getIdinvoice()%>" data-parent="#accordion">
                            <div class="card-body">  

                                <%

                                    Set<InvoiceHasCartItem> invoiceItems = invoice.getInvoiceHasCartItems();

                                    if (!invoiceItems.isEmpty()) {
                                %>
                                <label class="name"> spices </label>
                                <ul>
                                    <%
                                        for (InvoiceHasCartItem elem : invoiceItems) {
                                    %><li><%=elem.getCartHasItem().getLooseStock().getProduct().getProductname()%> - <%=elem.getCartHasItem().getQty()%> <small>kg.</small></li><%
                                        }
                                        %>
                                </ul><%
                                    }

                                    Set<InvoiceHasCartHasPackets> invoicePkts = invoice.getInvoiceHasCartHasPacketses();
                                    if (!invoicePkts.isEmpty()) {
                                %>
                                <label class="name"> spicy packets </label>
                                <ul>
                                    <%
                                        for (InvoiceHasCartHasPackets elem : invoicePkts) {
                                    %><li><%=elem.getCartHasPackets().getPacketStock().getPacket().getName()%> - <%=elem.getCartHasPackets().getQty()%> <small>packets.</small></li><%
                                        }
                                        %>
                                </ul><%
                                    }

                                    Set<InvoiceHasCartPackages> invoicePkgs = invoice.getInvoiceHasCartPackageses();

                                    if (!invoicePkgs.isEmpty()) {
                                %>
                                <label class="name"> packages </label>
                                <ul>
                                    <%
                                        for (InvoiceHasCartPackages elem : invoicePkgs) {
                                    %><li><%=elem.getCartHasPackages().getPackages().getPackageName()%> - <%=elem.getCartHasPackages().getQty()%> <small>packages.</small></li><%
                                        }
                                        %>
                                </ul><br><br><%
                                    }


                                %><label>Total : Rs. <%=invoice.getNetTotal()%></label><%
                                %>

                                <div class="actions">
                                    <%
                                        if (location.getLang() + location.getLat() != 0) {
                                    %>
                                    <a class="btn btn-sm btn-primary" href="https://www.google.com/maps/search/?api=1&query=<%=location.getLat()%>,<%=location.getLang()%>"> get direction </a>

                                    <%
                                        }
                                    %>
                                    <button class="btn btn-sm btn-warning" onclick="window.location = '../InvoiceDetails.jsp?id=<%=invoice.getIdinvoice()%>'"> print </button><br><br>
                                    <input onchange="uploadInvoice(<%=invoice.getIdinvoice()%>);" type="file" id="img-<%=invoice.getIdinvoice()%>" style="display: none;">
                                    <label class="btn btn-sm btn-outline-primary" for="img-<%=invoice.getIdinvoice()%>"> upload signed invoice </label>
                                    <br>
                                    <button class="btn btn-sm btn-primary" onclick="updateLocation(<%=invoice.getLocation().getIdlocation()%>)"> update location </button><br><br>
                                    <button class="btn btn-sm btn-outline-dark" onclick="closeOrder(<%=invoice.getIdinvoice()%>);"> close order </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%                    }
                    }

                }


            %>
        </div>
        <br>
        <br>
        <div id="details" class="container charts">
            <center>
                <div class="row action-div">
                    <div class="col-md-5 sum">
                        <canvas id="myChart" width="400" height="400"></canvas><br>
                        <div class="sum">
                            <label> # of full invoices: <%=fullInvoices%> </label><br>
                            <label> # of shop users invoices: <%=shopInvoices%> </label><br>
                            <label> # of local users invoices: <%=localInvoices%> </label><br>
                        </div>
                        <br>
                        <button class="btn btn-sm btn-warning" onclick="window.location = '../adminPanel/printInvoiceChart.jsp'"> print chart </button>
                        <button class="btn btn-sm btn-dark" onclick="scrltop();"> show orders </button>
                    </div>

                    <div class="col-md-7">
                        <table id="inv-table">
                            <thead>
                                <tr>
                                    <th> # </th>
                                    <th> user </th>
                                    <th> date </th>
                                    <th>  </th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    for (Invoice elem : fullList) {
                                %><tr>
                                    <td><%=elem.getIdinvoice()%></td>
                                    <td><%=elem.getUser().getName()%></td>
                                    <td><%=elem.getDate()%></td>
                                    <td>
                                        <form action="../InvoiceDetails.jsp" method="GET" target="_blank">
                                            <button name="id" type="submit" value="<%=elem.getIdinvoice()%>" class="btn btn-sm btn-outline-secondary"> show details </button>
                                        </form>
                                    </td>
                                </tr><%
                                    }
                                %>
                            </tbody>
                        </table>
                        <button onclick="window.location = '../adminPanel/printInvoices.jsp';" class="btn btn-sm btn-warning" style="float: right;margin-top: 50px;">print invoice list</button>
                    </div>
                </div>
            </center>
        </div>


        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="../SnackBar/snackbar.min.js"></script>
        <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
        <script src="../style/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>
        <script src="../assets/js/show-alert.js"></script>

        <script>

                            $(document).ready(function () {
                                $('#inv-table').DataTable();
                            });


                            function getCharts() {

                                var request = new XMLHttpRequest();
                                request.onreadystatechange = function () {
                                    if (request.readyState === 4 && request.status === 200) {
                                        var values = JSON.parse(request.responseText);


                                        var ctx = document.getElementById("myChart").getContext('2d');
                                        var myChart = new Chart(ctx, {
                                            type: 'bar',
                                            data: {
                                                labels: ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"],
                                                datasets: [{
                                                        label: '# of invoices on this year',
                                                        data: values,
                                                        backgroundColor: [
                                                            'rgba(255, 99, 132, 1)',
                                                            'rgba(54, 162, 235, 1)',
                                                            'rgba(255, 206, 86, 1)',
                                                            'rgba(75, 192, 192, 1)',
                                                            'rgba(153, 102, 255, 1)',
                                                            'rgba(153, 102, 255, 1)',
                                                            'rgba(153, 102, 255, 1)',
                                                            'rgba(153, 102, 255, 1)',
                                                            'rgba(153, 102, 255, 1)',
                                                            'rgba(153, 102, 255, 1)',
                                                            'rgba(153, 102, 255, 1)',
                                                            'rgba(255, 159, 64, 1)'
                                                        ]

                                                    }]
                                            },
                                            options: {
                                                scales: {
                                                    yAxes: [{
                                                            ticks: {
                                                                beginAtZero: true
                                                            }
                                                        }]
                                                }
                                            }
                                        });

                                    }
                                };

                                request.open("GET", "../GetCharts?type=invoices", true);
                                request.send();
                            }


        </script>
        <script>

            $(document).ready(function () {
                $("#search").on("keyup", function () {
                    var value = $(this).val().toLowerCase();
                    $(".order > div").filter(function () {
                        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                    });
                });
            });


            function uploadInvoice(id) {
                var img = document.getElementById("img-" + id).files;
                var imgname = img[0].name;


                var form = new FormData();
                form.append("id", id);
                form.append("imgname", imgname);
                form.append("img", img[0]);

                var requset = new XMLHttpRequest();
                requset.onreadystatechange = function () {
                    if (requset.readyState === 4 && requset.status === 200) {
                        showAlert(requset.responseText);
                    }
                };

                requset.open("POST", "../SignedInvoice", true);
                requset.send(form);

            }

            function closeOrder(id) {

                var requset = new XMLHttpRequest();
                requset.onreadystatechange = function () {
                    if (requset.readyState === 4 && requset.status === 200) {
                        showAlert(requset.responseText);
                        setInterval(function () {
                            window.location = "deliveries.jsp";
                        }, 2500);
                    }
                };

                requset.open("GET", "../SignedInvoice?id=" + id, true);
                requset.send();

            }


            function updateLocation(id) {
                if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                    if (window.navigator.geolocation) {
                        window.navigator.geolocation.getCurrentPosition(showLocation, showError);
                    } else {
                        console.log('device doese not support geolocation');
                    }

                }

                function showLocation(location) {

                    var long = location.coords.longitude;
                    var lat = location.coords.latitude;

                    var request = new XMLHttpRequest();

                    request.onreadystatechange = function () {
                        if (request.readyState === 4 && request.status === 200) {
                            showAlert(request.responseText);
                        }
                    };

                    request.open("GET", "../ChangeLocation?id=" + id + "&lat=" + lat + "&long=" + long, false);
                    request.send();
                }

                function showError(error) {
                    var er;
                    switch (error.code) {
                        case error.PERMISSION_DENIED:
                            er = "permission for location service is not allowed. please allow it first.";
                            break;
                        case error.POSITION_UNAVAILABLE:
                            er = "we can't find your location at this moment.";
                            break;
                        case error.TIMEOUT:
                            er = "please try again later";
                            break;
                        case error.UNKNOWN_ERROR:
                            er = "An unknown error occurred.";
                            break;
                    }

                    alert(er);
                }
            }


            function scrl() {
                document.getElementById('details').scrollIntoView({block: 'start', behavior: 'smooth'});
            }

            function scrltop() {
                document.getElementById('orders').scrollIntoView({block: 'start', behavior: 'smooth'});
            }
        </script>
    </body>
</html>
