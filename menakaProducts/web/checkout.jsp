<%-- 
    Document   : checkout
    Created on : May 28, 2018, 8:25:27 PM
    Author     : nipun
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="pojos.Zip"%>
<%@page import="servlet.Distance"%>
<%@page import="pojos.Deliverydata"%>
<%@page import="java.util.Date"%>
<%@page import="pojos.DiscountCodes"%>
<%@page import="pojos.Invoice"%>
<%@page import="servlet.GetDBTotal"%>
<%@page import="pojos.Limit"%>
<%@page import="java.util.Set"%>
<%@page import="pojos.Location"%>
<%@page import="pojos.Cart"%>
<%@page import="pojos.CartHasPackages"%>
<%@page import="pojos.CartHasPackets"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.CartHasItem"%>
<%@page import="pojos.User"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:100,400">
        <link rel="stylesheet" type="text/css" href="../SnackBar/snackbar.min.css">
        <script> history.forward();</script>
        <title>checkout</title>

        <style>

            .loose td, .pkt td, .pkg td{
                padding:10px 30px;
            }
            .loose, .pkt, .pkg{

                margin: 0 auto;
                margin-top: 20px;                
                padding: 20px;

                background-color: white;

            }
            #address, #date{
                margin-top: 50px;
                margin-left: 20px;
                border: none;
                padding: 5px;
                border-radius: 5px;

            }
            #location{
                text-align: right;
                margin-top: 30px;
                display: none;
                background-color: white;
            }
            .displayLocation{
                display: block;
            }
            .displayLocation span{
                margin: 10px;
            }
            #date{
                width: 150px;
            }
            #items{
                margin-top: 20px;
                border-style: solid; 
                border-width: 1px;
                border-color: rgba(0,0,0,0.2);
                text-align: center;
                border-radius: 3px;
                padding: 30px;
            }
            #total{
                margin: 20px 0;
                width: 270px;
            }
            h6{
                padding: 10px 5px;
                background-color: black;
                color: white !important;
                font-weight: bold !important;
                letter-spacing: 3px;
            }
            .locations{
                list-style-type: none;
            }
            .locations li{
                background-color: white;
                padding: 10px 20px;
                border-bottom: solid 1px rgba(0,0,0,0.1);
            }
            .locations li:hover{
                cursor: pointer;
                background-color: gray;
                color: white;
            }
            .locations li:active{
                background-color: gray;
            }
            .total{
                text-align: right;
            }
            .bold{
                font-weight: bold;
            }
            .net{
                border-top: solid 1px rgba(0,0,0,0.3);
                border-bottom: double 3px rgba(0,0,0,0.3);
                font-size: 18px;
                font-weight: bold;
                margin-top: 30px;

            }
        </style>
    </head>
    <body>
        <%@include file="nav.jsp" %>
        <%
            
            System.out.println("in checkout.jsp");
            
            User user = (User) request.getSession().getAttribute("user");
            Session s = NewHibernateUtil.getSessionFactory().openSession();

            Limit limit = (Limit) s.createCriteria(Limit.class)
                    .add(Restrictions.eq("usertype", user.getUsertype())).uniqueResult();

            String voucher = request.getParameter("voucher");
            DiscountCodes code = null;
            
            if (!voucher.equals("")) {
                System.out.println("voucher code input found");
                List<DiscountCodes> codeList = s.createCriteria(DiscountCodes.class)
                        .add(Restrictions.eq("status", "available"))
                        .add(Restrictions.eq("code", voucher))
                        .add(Restrictions.eq("user", user)).list();

                if (!codeList.isEmpty()) {
                    System.out.println("voucher code detected for this checkout");
                    
                    code = codeList.get(0);
                    if (code.getExpDate().compareTo(new Date()) == 1) {
                        request.getSession().setAttribute("voucher", code.getValue());
                    } else {
                        System.out.println("the voucher code expired");
                        request.getSession().setAttribute("limitNote", "the voucher code expired");
                        request.getSession().setAttribute("voucher", null);
                        response.sendRedirect("viewCart.jsp");
                        return;
                    }
                } else {
                    request.getSession().setAttribute("limitNote", "the voucher code is not valid");
                    request.getSession().setAttribute("voucher", null);
                    response.sendRedirect("viewCart.jsp");
                    return;
                }

            }

            List<Invoice> list_invoice = s.createCriteria(Invoice.class)
                    .add(Restrictions.eq("user", user))
                    .add(Restrictions.eq("status", "paid")).list();

            if (list_invoice.size() > 3) {
                request.getSession().setAttribute("limitNote", "sorry, you have to wait till your pending deliveries closed before new orders");
                response.sendRedirect("viewCart.jsp");
                return;
            }

            if (limit.getTotalPrice() > new GetDBTotal().getTotal(user)) {

                System.out.println("total :::: : " + new GetDBTotal().getTotal(user));
                request.getSession().setAttribute("limitNote", "sorry, you must buy at least Rs." + limit.getTotalPrice() + " of items before proceed to checkout.");
                response.sendRedirect("viewCart.jsp");
                return;
            }

            if (user == null || request.getSession().getAttribute("total") == null) {
                response.sendRedirect("viewCart.jsp");
                return;
            }

            List<Location> list = s.createCriteria(Location.class).add(Restrictions.eq("user", user)).list();
            if (list.isEmpty()) {
                response.sendRedirect("locations.jsp");
                return;
            }

            Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();

            List<CartHasItem> listItem = s.createCriteria(CartHasItem.class)
                    .add(Restrictions.eq("cart", cart))
                    .add(Restrictions.eq("status", "pending")).list();

            List<CartHasPackets> listPacket = s.createCriteria(CartHasPackets.class)
                    .add(Restrictions.eq("cart", cart))
                    .add(Restrictions.eq("status", "pending")).list();

            List<CartHasPackages> listPackage = s.createCriteria(CartHasPackages.class)
                    .add(Restrictions.eq("cart", cart))
                    .add(Restrictions.eq("status", "pending")).list();

            if ((listItem.size() + listPacket.size() + listPackage.size()) == 0) {  // cart is empty
                response.sendRedirect("viewCart.jsp");
                return;
            }
        %>


        <div class="container">
            <div class="row">
                <div class="col-md-6">

                    <section id="items">

                        <h4>purchase summary</h4>

                        <!-- loose items -->
                        <%if (!listItem.isEmpty()) {
                        %>
                        <div class="loose">
                            <h6> loose items</h6>
                            <div class="table-responsive">
                                <table>
                                    <tbody>
                                        <% for (CartHasItem ci : listItem) {

                                        %><tr>
                                            <td><%=ci.getLooseStock().getProduct().getProductname()%></td>
                                            <td><%=ci.getQty()%> <small> kg. </small></td>
                                            <td><small>Rs.</small><%=ci.getQty() * ci.getLooseStock().getUprice()%></td>
                                        <tr>
                                            <%
                                                }
                                            %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <%
                            }
                        %>

                        <!-- packets -->
                        <% if (!listPacket.isEmpty()) {
                        %>
                        <div class="pkt">
                            <h6> packet items</h6>
                            <div class="table-responsive">
                                <table>
                                    <tbody>
                                        <% for (CartHasPackets cp : listPacket) {

                                        %><tr>
                                            <td><%=cp.getPacketStock().getPacket().getName()%></td>
                                            <td><%=cp.getQty()%> <small>packet(s)</small></td>
                                            <td><small>Rs.</small><%=cp.getQty() * cp.getPacketStock().getPrice()%></td>
                                        <tr>
                                            <%
                                                }
                                            %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <%
                            }
                        %>

                        <!-- packages -->
                        <% if (listPackage != null) {
                                if (!listPackage.isEmpty()) {
                        %>
                        <div class="pkg">
                            <h6> packet items</h6>
                            <div class="table-responsive">
                                <table>
                                    <tbody>
                                        <% for (CartHasPackages cp : listPackage) {

                                        %><tr>
                                            <td><%=cp.getPackages().getPackageName()%></td>
                                            <td><%=cp.getQty()%><small>package(s)</small></td>
                                            <td><small>Rs.</small><%=cp.getQty() * cp.getPackages().getPrice()%></td>
                                        <tr>
                                            <%
                                                }
                                            %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>                        
                    </section>
                </div>

                <div class="col-md-6">
                    <% List<Location> locationList = s.createCriteria(Location.class).add(Restrictions.eq("user", user)).list(); %>

                    <%

                        Deliverydata data = (Deliverydata) s.createCriteria(Deliverydata.class).uniqueResult();
                        String delType = data.getDeliveryType();


                    %>

                    <small>delivery address</small>

                    <ul class="locations" id="address">
                        <%                            for (Location elem : locationList) {

                                double charge = 0;
                                Zip zipcode = (Zip) s.load(Zip.class, elem.getZip().getIdzip());
                                if (delType.equals("km")) {
                                    if (elem.getLat() == 0 || elem.getLang() == 0) { // can'nt find distance
                                        System.out.println("location :" + elem.getAddress() + "has no location details");
                                        charge = zipcode.getCharge();
                                    } else {
                                        String origin = data.getDeliveryPoint();
                                        String destination = elem.getLat() + "," + elem.getLang();

                                        double distance = new Distance().GetDistance(origin, destination);
                                        charge = distance * data.getChargePerKm();

                                        System.out.println("charge on location :" + elem.getAddress() + " : Rs. " + charge + "(km)");
                                    }
                                }

                                if (delType.equals("zip")) {
                                    charge = zipcode.getCharge();
                                    System.out.println("charge on location :" + elem.getAddress() + " : Rs. " + charge + "(ZIP)");
                                }

                                charge = Double.parseDouble(new DecimalFormat("#.##").format(charge));

                        %>
                        <li onclick="address = '<%=elem.getIdlocation()%>';getDistance(<%=elem.getLat()%>,<%=elem.getLang()%>, '<%=elem.getAddress()%>', '<%=elem.getStreet()%>', '<%=elem.getZip().getZipcode()%>'); setCharge(<%=charge%>);"><%=elem.getAddress()%></li>
                            <%
                                }
                            %>
                    </ul>

                    <div id="location"></div><br>
                    <div class="total">
                        <%
                            if (request.getSession().getAttribute("voucher") != null) {
                        %>
                        <span> <span class="bold">Sub total</span> : Rs <%=new GetDBTotal().getTotal(user)%> </span><br>
                        <span> <span class="bold">Voucher value</span> : Rs. <%=code.getValue()%> </span><br>
                        <span class="net"> <span class="bold">Net Total</span> : Rs. <%=new GetDBTotal().getTotal(user) - code.getValue()%> </span>
                        <small id="plus-charge"></small>
                        <%
                        } else {
                        %><span class="net"> <span class="bold">Net Total</span> : Rs <%=new GetDBTotal().getTotal(user)%></span>
                        <small id="plus-charge"></small>
                        <%
                            }
                        %>
                    </div>
                    <div style="text-align: right;">
                        <button class="btn btn-warning" id="total" onclick="processData();">pay</button>
                    </div>
                </div>
            </div>
        </div>


        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="../SnackBar/snackbar.min.js"></script>
        <script src="assets/js/show-alert.js"></script>
        <script type="text/javascript">


                            function getDistance(lat, long, address, st, zip) {

                                var disdue = document.getElementById("dis-due");
                                if (disdue !== null) {
                                    disdue.innerHTML = null;
                                }
                                var add = document.createElement("span");
                                add.innerHTML = "address : " + address;

                                var street = document.createElement("span");
                                street.innerHTML = "street : " + st;

                                var z = document.createElement("span");
                                z.innerHTML = "zipcode : " + zip;

                                var div = document.getElementById("location");
                                div.innerHTML = null;
                                div.style.display = "block";
                                div.appendChild(add);
                                div.appendChild(document.createElement("br"));
                                div.appendChild(street);
                                div.appendChild(document.createElement("br"));
                                div.appendChild(z);
                                div.appendChild(document.createElement("br"));
                                div.appendChild(document.createElement("br"));




                                var origin = {lat: 6.896926, lng: 79.860329}; // delivery point location
                                var destination = {lat: lat, lng: long}; // client's location
                                //var destination = 'Dematagoda, Colombo, Sri Lanka'; // client's location

                                var service = new google.maps.DistanceMatrixService;
                                service.getDistanceMatrix({
                                    origins: [origin],
                                    destinations: [destination],
                                    travelMode: 'DRIVING',
                                    unitSystem: google.maps.UnitSystem.METRIC,
                                    avoidHighways: false,
                                    avoidTolls: false
                                }, function (response, status) {
                                    if (status !== 'OK') {
                                        alert('Error was: ' + status);
                                    } else {

                                        var results = response.rows[0].elements;

                                        var distance = results[0].distance.text; // gives the distance
                                        var duration = results[0].duration.text; // gives the duration


                                        console.log(duration);
                                        console.log(distance);

                                        var dis = document.createElement("span");
                                        dis.innerHTML = "distance ≈ " + distance;

                                        var due = document.createElement("span");
                                        due.innerHTML = "delivery duration ≈ " + duration;

                                        var small = document.createElement("small");
                                        small.innerHTML = "according to the location you gave us,";
                                        small.style.color = "gray";

                                        var mapData = document.createElement("div");
                                        mapData.id = "dis-due";
                                        mapData.appendChild(small);
                                        mapData.appendChild(document.createElement("br"));
                                        mapData.appendChild(dis);
                                        mapData.appendChild(document.createElement("br"));
                                        mapData.appendChild(due);

                                        div.appendChild(mapData);
                                    }
                                });

                            }

                            var address;
                            function processData() {

                                var choosenAddress = address;

                                var request = new XMLHttpRequest();
                                request.onreadystatechange = function () {
                                    if (request.readyState === 4 && request.status === 200) {
                                        if (request.responseText === 'feild@1') {
                                            window.location = "pay.jsp";
                                        } else {
                                            showAlert(request.responseText);
                                        }
                                    }
                                };
                                request.open("GET", "ProcessData?address=" + choosenAddress, true);
                                request.send();

                            }

                            function setCharge(rs) {
                                document.getElementById('plus-charge').innerHTML = "<br>+ Rs." + rs + " (delivery charge)";
                            }

        </script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBKtUU1e7zFyZ50uurIPPun4lBiW51A_KY&libraries=places"
        async defer></script>
    </body>
</html>
