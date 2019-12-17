<%-- 
    Document   : userAccount
    Created on : May 9, 2018, 5:29:11 PM
    Author     : nipun
--%>

<%@page import="pojos.Invicephoto"%>
<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="pojos.Location"%>
<%@page import="pojos.Cart"%>
<%@page import="pojos.User"%>
<%@page import="pojos.CartHasPackages"%>
<%@page import="pojos.CartHasPackets"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.CartHasItem"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="SnackBar/snackbar.min.css">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
        <title>my account</title>

        <style>
            #password-details input{
                border: solid 1px #bdc3c7;
                font-size: 16px;
                padding: 2px 5px;
                margin-top: 10px;
            }
            #password-details button{
                margin-top: 10px;

            }
            input{

            }
        </style>
    </head>
    <body>

        <%

            if (request.getSession().getAttribute("user") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

        %>

        <% request.getSession().setAttribute("page", "userAccount.jsp");%>
        <%@include file="nav.jsp" %>
        <% User user = (User) request.getSession().getAttribute("user");

            System.out.println("user name : " + user.getName());
            Session s = NewHibernateUtil.getSessionFactory().openSession();
        %>

        <div class="container"> 
            <div class="row no-gutters" style="margin-top: 30px;">
                <div class="col-md-3">
                    <div>

                        <div style="margin-bottom: 50px;" id="basic-details">
                            <label>name : </label> <label id="user-name"> <%=user.getName()%> </label> <button id="details-change" style="margin-left: 30px;" class="btn btn-sm btn-primary" onclick="changeDetails(<%=user.getIduser()%>, 'name');"> change</button><br> <br>
                            <label>email : </label> <label id="user-email"> <%=user.getEmail()%> </label><br>
                            <small><a href="javascript: changeDetails(<%=user.getIduser()%>,'password');"> change password </a></small>

                            <div id="password-details">

                            </div>
                        </div>

                        <%
                            if (user.getUsertype().getIdusertype() != 4) {
                        %>

                        <label> locations : </label><br>
                        <%
                            List<Location> locationList = s.createCriteria(Location.class).add(Restrictions.eq("user", user)).list();
                            if (!locationList.isEmpty()) {

                                for (Location location : locationList) {
                                    String address = location.getAddress();
                                    String street = location.getStreet();
                                    String zip = location.getZip().getZipcode();

                        %>


                        <a href="javascript: getLocation('<%=location.getIdlocation()%>','<%=address%>','<%=street%>','<%=zip%>');"><%=location.getAddress()%></a><br>

                        <%
                                }

                            } else if (locationList.size() >= 4) {

                            }
                            {
                        %><button class="btn btn-sm btn-secondary" onclick="window.location = 'locations.jsp';">add a location</button><br><%
                            }

                        %>

                        <div id="location-div" style="margin-top: 70px;">

                        </div>


                        <%                            }
                        %>
                    </div>

                </div>

                <div class="col-md-8">

                    <%                        if (user.getUsertype().getIdusertype() != 4) {
                    %>

                    <div class="table-responsive">
                        <table id="closed-table" class="table table-sm table-hover">
                            <thead class="thead-dark">

                                <tr>
                                    <th>item</th>
                                    <th>qty</th>
                                    <th>date</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();

                                    List<CartHasItem> itemList = s.createCriteria(CartHasItem.class)
                                            .add(Restrictions.eq("cart", cart))
                                            .add(Restrictions.eq("status", "closed")).list();

                                    List<CartHasPackets> packetList = s.createCriteria(CartHasPackets.class)
                                            .add(Restrictions.eq("cart", cart))
                                            .add(Restrictions.eq("status", "closed")).list();

                                    List<CartHasPackages> packageList = s.createCriteria(CartHasPackages.class)
                                            .add(Restrictions.eq("cart", cart))
                                            .add(Restrictions.eq("status", "closed")).list();

                                    for (CartHasItem chi : itemList) {

                                        Format format = new SimpleDateFormat("yyyy-MM-dd");
                                        String date = format.format(chi.getDate());
                                %><tr>
                                    <td><%=chi.getLooseStock().getProduct().getProductname()%> <small>(loose item)</small></td>
                                    <td><%=chi.getQty()%> <small> Kg. </small></td>
                                    <td><%=date%></td>
                                </tr><%
                                    }

                                    for (CartHasPackets chp : packetList) {
                                %><tr>
                                    <td><%=chp.getPacketStock().getPacket().getName()%> <small>(packet)</small></td>
                                    <td><%=chp.getQty()%></td>
                                    <td><%=chp.getDate()%></td>
                                </tr><%
                                    }

                                    for (CartHasPackages chp : packageList) {
                                %><tr>
                                    <td><%=chp.getPackages().getPackageName()%> <small>(package)</small></td>
                                    <td><%=chp.getQty()%></td>
                                    <td><%=chp.getDate()%></td>
                                </tr><%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div class="row no-gutters">
                        <div class="col">
                            <small style="float: left">purchase history</small>
                        </div>
                        <div class="col">
                            <small style="float: right">to view your pending items, please head for the <a target="_blank" href="viewCart.jsp">cart</a> page.</small>

                        </div>
                    </div>
                    <br><br>
                    <div class="table-responsive">
                        <table id="order-table" class="table table-sm table-hover">
                            <thead class="thead-dark">

                                <tr>
                                    <th>item</th>
                                    <th>qty</th>
                                    <th>date</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    itemList = s.createCriteria(CartHasItem.class)
                                            .add(Restrictions.eq("cart", cart))
                                            .add(Restrictions.eq("status", "paid")).list();

                                    packetList = s.createCriteria(CartHasPackets.class)
                                            .add(Restrictions.eq("cart", cart))
                                            .add(Restrictions.eq("status", "paid")).list();

                                    packageList = s.createCriteria(CartHasPackages.class)
                                            .add(Restrictions.eq("cart", cart))
                                            .add(Restrictions.eq("status", "paid")).list();

                                    for (CartHasItem chi : itemList) {

                                        Format format = new SimpleDateFormat("yyyy-MM-dd");
                                        String date = format.format(chi.getDate());
                                %><tr>
                                    <td><%=chi.getLooseStock().getProduct().getProductname()%> <small>(loose item)</small></td>
                                    <td><%=chi.getQty()%> <small> Kg. </small></td>
                                    <td><%=date%></td>
                                </tr><%
                                    }

                                    for (CartHasPackets chp : packetList) {
                                %><tr>
                                    <td><%=chp.getPacketStock().getPacket().getName()%> <small>(packet)</small></td>
                                    <td><%=chp.getQty()%></td>
                                    <td><%=chp.getDate()%></td>
                                </tr><%
                                    }

                                    for (CartHasPackages chp : packageList) {
                                %><tr>
                                    <td><%=chp.getPackages().getPackageName()%> <small>(package)</small></td>
                                    <td><%=chp.getQty()%></td>
                                    <td><%=chp.getDate()%></td>
                                </tr><%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div class="row no-gutters">
                        <div class="col">
                            <small style="float: left">on the way</small>
                        </div>
                    </div>
                    <br>
                    <br>
                    <br>
                    <%
                    } else { // emp area

                    %>



                    <div class="table">
                        <table id="emp-table">
                            <thead class="thead-dark">
                                <tr>
                                    <th>#</th>
                                    <th>date</th>
                                    <th>issued for</th>
                                    <th></th>
                                </tr>
                            </thead>

                            <tbody>

                                <%                                    List<Invicephoto> inv_list = s.createCriteria(Invicephoto.class)
                                            .add(Restrictions.eq("user", user)).list();

                                    for (Invicephoto elem : inv_list) {
                                %>
                                <tr>
                                    <td><%=elem.getInvoice().getIdinvoice()%></td>
                                    <td><%=elem.getInvoice().getDate()%></td>
                                    <td><%=elem.getInvoice().getUser().getEmail()%></td>
                                    <td><a target="_blank" class="btn btn-sm btn-dark" href="InvoiceDetails.jsp?id=<%=elem.getInvoice().getIdinvoice()%>"> show invoice </a></td>
                                </tr>
                                <%
                                    }

                                %>

                            </tbody>
                        </table>
                        <a style="margin: 20px 0;" href="empPanel/deliveries.jsp" class="btn btn-sm btn-primary"> pending deliveries </a>
                    </div>





                    <%                        }

                    %>



                </div>
            </div>
        </div>

        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
        <script src="../style/js/bootstrap.min.js"></script>
        <script type="text/javascript">


                            $(document).ready(function () {
                                $('#order-table').DataTable();
                                $('#closed-table').DataTable();
                                $('#emp-table').DataTable();
                            });


                            function getLocation(id, address, street, zip) {


                                var location = document.getElementById("location-div");
                                location.innerHTML = null;

                                var lbl1 = document.createElement("label");
                                lbl1.innerHTML = "address : ";
                                var adrs = document.createElement("label");
                                adrs.innerHTML = address;
                                adrs.id = "address";

                                var lbl2 = document.createElement("label");
                                lbl2.innerHTML = "street : ";
                                var st = document.createElement("label");
                                st.innerHTML = street;
                                st.id = "street";

                                var lbl3 = document.createElement("label");
                                lbl3.innerHTML = "zipcode : ";
                                var zipcode = document.createElement("label");
                                zipcode.innerHTML = zip;
                                zipcode.id = "zip";

                                var change = document.createElement("button");
                                change.id = "location-change-btn";
                                change.className = "btn btn-sm btn-warning";
                                change.innerHTML = "change address details";
                                change.setAttribute("onclick", "changeDetails('" + id + "','location')");

                                var cancel = document.createElement("button");
                                cancel.id = "location-change-btn";
                                cancel.className = "btn btn-sm btn-primary";
                                cancel.innerHTML = "cancel";
                                cancel.onclick = function () {
                                    alert();
                                };

                                location.appendChild(lbl1);
                                location.appendChild(adrs);
                                location.appendChild(document.createElement("br"));
                                location.appendChild(lbl2);
                                location.appendChild(st);
                                location.appendChild(document.createElement("br"));
                                location.appendChild(lbl3);
                                location.appendChild(zipcode);
                                location.appendChild(document.createElement("br"));
                                location.appendChild(change);
                            }

                            function changeDetails(id, type) {
                                if (type === 'name') {
                                    var name = document.getElementById("user-name");

                                    var nameinput = document.createElement("input");
                                    nameinput.id = "name-in";
                                    nameinput.value = name.innerHTML;

                                    name.innerHTML = null;
                                    name.appendChild(nameinput);

                                    var save = document.getElementById("details-change");
                                    save.id = "name-save-btn";
                                    save.className = "btn btn-sm btn-warning";
                                    save.innerHTML = "save";
                                    save.removeAttribute("onclick");
                                    save.setAttribute("onclick", "saveChange('" + id + "','info');");
                                } else if (type === 'password') {

                                    var div = document.createElement("div");
                                    div.id = "password-div";

                                    var old = document.createElement("input");
                                    old.placeholder = "your old password";
                                    old.type = 'password';
                                    old.id = "old";

                                    var newPass = document.createElement("input");
                                    newPass.placeholder = "new password";
                                    newPass.type = 'password';
                                    newPass.id = "newPass";

                                    var confirm = document.createElement("input");
                                    confirm.placeholder = "confirm";
                                    confirm.type = 'password';
                                    confirm.id = "confirm";

                                    var save = document.createElement("button");
                                    save.id = "password-save-btn";
                                    save.className = "btn btn-sm btn-warning";
                                    save.innerHTML = "save";
                                    save.setAttribute("onclick", "saveChange('" + id + "','password');");

                                    var cancel = document.createElement("button");
                                    cancel.style.cssText = "margin-left : 10px;";
                                    cancel.className = "btn btn-sm btn-success";
                                    cancel.innerHTML = "cancel";
                                    cancel.onclick = function () {
                                        div.innerHTML = null;
                                    };

                                    div.appendChild(old);
                                    div.appendChild(document.createElement("br"));
                                    div.appendChild(newPass);
                                    div.appendChild(document.createElement("br"));
                                    div.appendChild(confirm);
                                    div.appendChild(document.createElement("br"));
                                    div.appendChild(save);
                                    div.appendChild(cancel);
                                    div.appendChild(document.createElement("br"));

                                    var newdiv = document.getElementById("password-details");
                                    newdiv.innerHTML = null;
                                    newdiv.appendChild(div);
                                } else if (type === 'location') {

                                    var address = document.getElementById("address");
                                    var street = document.getElementById("street");
                                    var zip = document.getElementById("zip");

                                    var addressInput = document.createElement("input");
                                    addressInput.value = address.innerHTML;
                                    addressInput.id = "address-in";
                                    var streetInput = document.createElement("input");
                                    streetInput.value = street.innerHTML;
                                    streetInput.id = "street-in";
                                    var zipInput = document.createElement("input");
                                    zipInput.value = zip.innerHTML;
                                    zipInput.id = "zip-in";

                                    address.innerHTML = null;
                                    street.innerHTML = null;
                                    zip.innerHTML = null;

                                    address.appendChild(addressInput);
                                    street.appendChild(streetInput);
                                    zip.appendChild(zipInput);

                                    var cancel = document.createElement("button");
                                    cancel.id = "location-change-btn";
                                    cancel.className = "btn btn-sm btn-primary";
                                    cancel.style.cssText = "margin-left: 5px";
                                    cancel.innerHTML = "cancel";
                                    cancel.onclick = function () {
                                        window.location = "userAccount.jsp";
                                    };

                                    var location = document.getElementById("location-div");
                                    location.appendChild(cancel);

                                    var btn = document.getElementById("location-change-btn");
                                    btn.removeAttribute("onclick");
                                    btn.setAttribute("onclick", "saveChange('" + id + "','location')");
                                    btn.innerHTML = "save changes";

                                }

                            }

                            function saveChange(id, details) {
                                var request = new XMLHttpRequest();


                                request.onreadystatechange = function () {

                                    if (request.readyState === 4) {
                                        if (request.status === 200) {

                                            console.log(request.responseText);
                                            var response = request.responseText;

                                            if (response === 'password@1') {
                                                showAlert("password@1");
                                                document.getElementById("password-details").innerHTML = null;
                                            } else if (response === "location@1") {
                                                showAlert(response);
                                                setTimeout(function () {
                                                    window.location = "userAccount.jsp";
                                                }, 2000);

                                            } else if (response === 'name@1') {
                                                window.location = "userAccount.jsp";
                                            } else {
                                                showAlert(response);
                                            }
                                        }
                                    }

                                };

                                if (details === 'info') {
                                    var name = document.getElementById("name-in").value;
                                    request.open("GET", "SaveUserDetails?id=" + id + "&name=" + name + "&type=" + details, true);
                                } else if (details === 'location') {
                                    var address = document.getElementById("address-in").value;
                                    var street = document.getElementById("street-in").value;
                                    var zip = document.getElementById("zip-in").value;

                                    request.open("GET", "SaveUserDetails?id=" + id + "&address=" + address + "&street=" + street + "&zip=" + zip + "&type=" + details, true);
                                } else if (details === 'password') {
                                    var old = document.getElementById("old").value;
                                    var newPass = document.getElementById("newPass").value;
                                    var confirm = document.getElementById("confirm").value;

                                    request.open("GET", "SaveUserDetails?id=" + id + "&old=" + old + "&newPass=" + newPass + "&confirm=" + confirm + "&type=" + details, true);
                                }
                                request.send();
                            }

        </script>      
        <script src="SnackBar/snackbar.min.js"></script>
        <script src="assets/js/show-alert.js"></script>

    </body>
</html>
