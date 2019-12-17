<%-- 
    Document   : users
    Created on : May 17, 2018, 8:05:01 PM
    Author     : nipun
--%>

<%@page import="pojos.DiscountCodes"%>
<%@page import="pojos.Usertype"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Limit"%>
<%@page import="java.util.List"%>
<%@page import="pojos.User"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/simple-line-icons/2.4.1/css/simple-line-icons.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
        <style>

            body{
                padding: 30px;
                background-color: black;
            }

            .info{
                padding: 20px;
                background-color: #2d3436;
                color: white;
                margin-top: 20px;
                border-radius: 3px;
            }
            .tr:hover{
                cursor: pointer;
            }
            .same{
                width: 70px;
            }
            .limit{
                margin-top: 30px;
                padding: 20px;
                color: white;
                width: 320px;
                background-color: #2d3436;
                border-radius: 3px;
            }
            .limit input{
                margin-top: 10px;
                padding: 3px 10px;
            }
            .change{
                margin-left: 10px;
            }
            .change:hover{
                cursor: pointer;
            }
        </style>
        <title>users</title>
    </head>
    <body onload="load();">

        <div style="background-color: white;" class="container-fluid">

            <div class="row">

                <div class="col-md-9">
                    <div style="margin-top: 30px;">
                        <input onkeyup="load();" type="text" id="search" placeholder="search" style="margin-right: 30px">
                        online/offline : <select style="margin-right: 30px" id="online" onchange="load();">
                            <option>all</option>
                            <option>online</option>
                            <option>offline</option>
                        </select>

                        status : <select id="status" onchange="load();">
                            <option>all</option>
                            <option>blocked</option>
                            <option>active</option>
                        </select>
                        <br>
                        <br>
                        user type : <select id="user-type" onchange="load();">
                            <option> all </option>
                            <option> local users </option>
                            <option> shop users </option>
                            <option> employees </option>
                        </select>

                        invoices more than : <input type="number" id="invoices" onkeyup="load();" onchange="load();">

                        <div class="table-responsive" style="margin-top: 20px;">
                            <table id="tab" class="table table-sm table-hover">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>user</th>
                                        <th>registered date</th>
                                        <th>email</th>
                                        <th>invoices</th>
                                        <th>status</th>

                                    </tr>
                                </thead>

                                <tbody id="table">

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div id="info">

                    </div>
                </div>

            </div>
            <br>
            <br>
            <div class="row">
                <div class="col-md-8">
                    <div style="margin: 10px;border: solid 1px rgba(0,0,0,0.3); padding: 10px;">
                        <h5> vouchers </h5>
                        <br>
                        <table id="voucher-table">

                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>code</th>
                                    <th>user</th>
                                    <th>expire date</th>
                                    <th>status</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%                                    Session s = NewHibernateUtil.getSessionFactory().openSession();
                                    List<DiscountCodes> list = s.createCriteria(DiscountCodes.class).list();

                                    for (DiscountCodes elem : list) {
                                %>
                                <tr>
                                    <td><%=elem.getId()%></td>    
                                    <td><%=elem.getCode()%></td>    
                                    <td><%=elem.getUser().getEmail()%></td>    
                                    <td><%=elem.getExpDate()%></td>    
                                    <td><%=elem.getStatus()%></td>    
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>

                        </table>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="row">
                        <div class="col">
                            <div style="text-align: center;margin-top: 20px;">
                                <h5>set voucher</h5>
                                <textarea id="message" style="max-width: 200px;min-width: 200px;"></textarea><br>
                                <input id="value" style="width: 200px;margin-top: 10px" placeholder="value"> <br><br>
                                <small style="color: rgba(0,0,0,0.6);">expire date</small> <br>
                                <input style="width: 200px;margin-top: 10px" type="date" id="date-discount"><br><br>
                                <button style="width: 200px;" onclick="genarateDiscount();" class="btn btn-sm btn-warning">send voucher</button>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="limit">

                                <%
                                    Usertype local = (Usertype) s.load(Usertype.class, 2);
                                    Usertype shop = (Usertype) s.load(Usertype.class, 3);

                                    double shopTotal = 0;
                                    double shopQty = 0;
                                    double localTotal = 0;
                                    double localQty = 0;

                                    Limit shopLimit = (Limit) s.createCriteria(Limit.class).add(Restrictions.eq("usertype", shop)).uniqueResult();
                                    Limit localLimit = (Limit) s.createCriteria(Limit.class).add(Restrictions.eq("usertype", local)).uniqueResult();

                                    if (shopLimit != null) {
                                        shopTotal = shopLimit.getTotalPrice();
                                        shopQty = shopLimit.getTotalQty();
                                    }
                                    if (localLimit != null) {
                                        localTotal = localLimit.getTotalPrice();
                                        localQty = localLimit.getTotalQty();
                                    }

                                %>

                                <small> shop user quantity limit : </small> <small id="shop-qty"><%=shopQty%></small> <small><small>kg.</small></small> <small>(over)</small> <small><i id="shop-edit" onclick="changelimit('shop-qty');" class="icon-pencil change"></i></small><br>
                                <small> shop user price limit : <small>Rs.</small> </small> <small id="shop-price"><%=shopTotal%></small> <small>(over)</small> <small><i id="shop-price-edit" onclick="changelimit('shop-price');" class="icon-pencil change"></i></small><br>
                                <br><br>
                                <small> local user price limit : <small>Rs.</small> </small> <small id="local-price"><%=localTotal%></small> <small>(over)</small> <small><i id="local-price-edit" onclick="changelimit('local-price');" class="icon-pencil change"></i></small><br>
                                <small> local user quantity limit : </small> <small id="local-qty"><%=localQty%></small> <small><small>kg.</small></small> <small>(bellow)</small> <small><i id="local-qty-edit" onclick="changelimit('local-qty');" class="icon-pencil change"></i></small><br>
                            </div>
                        </div>
                    </div>
                    <br>
                </div>
            </div>

        </div>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
        <script src="../style/js/bootstrap.min.js"></script>
        <script type="text/javascript">

                                    $(document).ready(function () {
                                        $('#voucher-table').DataTable();
                                    });

                                    var loadUsers;

                                    function load() {
                                        var search = document.getElementById("search").value;
                                        var online = document.getElementById("online").value;
                                        var status = document.getElementById("status").value;
                                        var invoices = document.getElementById("invoices").value;
                                        var user = document.getElementById("user-type").value;
                                        var table = document.getElementById("table");
                                        table.innerHTML = null;
                                        var request = new XMLHttpRequest();
                                        request.onreadystatechange = function () {
                                            if (request.readyState === 4 && request.status === 200) {

                                                var user_array = JSON.parse(request.responseText);
                                                loadUsers = user_array;
                                                for (var i = 0; i < user_array.length; i++) {
                                                    var user = user_array[i];

                                                    var tr = document.createElement("tr");
                                                    tr.id = "user-" + user.id;
                                                    tr.className = "tr";
                                                    if (user.status !== 'blocked') {
                                                        tr.setAttribute("onclick", "showinfo('" + user.id + "');");
                                                    }
                                                    var td1 = document.createElement("td");
                                                    td1.innerHTML = user.name;
                                                    var td2 = document.createElement("td");
                                                    td2.innerHTML = user.date;
                                                    var td3 = document.createElement("td");
                                                    td3.innerHTML = user.email;
                                                    var td4 = document.createElement("td");
                                                    td4.innerHTML = user.status;
                                                    var td5 = document.createElement("td");
                                                    if (user.oo === "online") {
                                                        td5.style.cssText = "color: green;";
                                                    } else {
                                                        td5.style.cssText = "color: blue;";
                                                    }
                                                    td5.innerHTML = "<small>" + user.oo + "</small>";

                                                    var td6 = document.createElement("td");
                                                    var block = document.createElement("button");
                                                    var doStatus;
                                                    if (user.status === 'blocked') {
                                                        doStatus = 1;
                                                        block.className = "btn btn-sm btn-danger same";
                                                        block.innerHTML = "unblock";
                                                    } else {
                                                        doStatus = 0;
                                                        block.innerHTML = "block";
                                                        block.className = "btn btn-sm btn-warning same";
                                                    }
                                                    block.setAttribute("onclick", "statusChange('" + user.id + "','" + doStatus + "')");

                                                    td6.appendChild(block);


                                                    var td7 = document.createElement("td");
                                                    td7.innerHTML = user.invoices;
                                                    tr.appendChild(td1);
                                                    tr.appendChild(td2);
                                                    tr.appendChild(td3);
                                                    tr.appendChild(td7);
                                                    tr.appendChild(td4);
                                                    tr.appendChild(td5);
                                                    tr.appendChild(td6);

                                                    table.appendChild(tr);

                                                }
                                            }
                                        };
                                        request.open("GET", "../Users?search=" + search + "&online=" + online + "&status=" + status + "&usertype=" + user + "&invoices=" + invoices + "&type=search", true);
                                        request.send();
                                    }

                                    function statusChange(id, status) {
                                        var request = new XMLHttpRequest();
                                        request.onreadystatechange = function () {
                                            if (request.readyState === 4 && request.status === 200) {
                                                alert(request.responseText);
                                                load();
                                                document.getElementById("info").innerHTML = null;
                                            }
                                        };
                                        request.open("GET", "../Users?id=" + id + "&status=" + status + "&type=status", true);
                                        request.send();
                                    }

                                    function showinfo(id) {
                                        var request = new XMLHttpRequest();
                                        request.onreadystatechange = function () {
                                            if (request.readyState === 4 && request.status === 200) {
                                                var main = document.getElementById("info");
                                                main.innerHTML = null;
                                                var location_object = JSON.parse(request.responseText);
                                                for (var i = 0; i < location_object.length; i++) {
                                                    var location = location_object[i];

                                                    var address = document.createElement("label");
                                                    address.innerHTML = "address : " + location.address;
                                                    var street = document.createElement("label");
                                                    street.innerHTML = "street : " + location.street;
                                                    var zip = document.createElement("label");
                                                    zip.innerHTML = "zip : " + location.zip;
                                                    var tel = document.createElement("label");
                                                    tel.innerHTML = "contact : " + location.tel;

                                                    var nav = document.createElement("button");
                                                    nav.className = "btn btn-sm btn-primary";
                                                    nav.innerHTML = "start navigation";
                                                    nav.style.cssText = "float:right";
                                                    nav.target = "_blank";
                                                    var lat = location.lat;
                                                    var long = location.long;

                                                    nav.setAttribute("onclick", "navigate('" + lat + "','" + long + "');");


                                                    var info = document.createElement("div");
                                                    info.className = "info";

                                                    info.appendChild(address);
                                                    info.appendChild(document.createElement("br"));
                                                    info.appendChild(street);
                                                    info.appendChild(document.createElement("br"));
                                                    info.appendChild(zip);
                                                    info.appendChild(document.createElement("br"));
                                                    info.appendChild(tel);
                                                    info.appendChild(document.createElement("br"));
                                                    info.appendChild(nav);
                                                    info.appendChild(document.createElement("br"));

                                                    main.appendChild(info);
                                                }
                                            }
                                        };
                                        request.open("GET", "../Users?id=" + id + "&type=location", true);
                                        request.send();
                                    }

                                    function navigate(lat, long) {
                                        if (lat !== 'null' && long !== 'null') {
                                            window.open("https://www.google.com/maps/search/?api=1&query=" + lat + "," + long + "", "_blank");
                                        } else {
                                            alert('location currupted');
                                        }

                                    }

                                    function changelimit(change) {
                                        var input;
                                        var text = document.createElement("input");

                                        var edit;
                                        if (change === "shop-qty") {
                                            input = document.getElementById("shop-qty");
                                            input.innerHTML = null;
                                            input.appendChild(text);


                                            edit = document.getElementById("shop-edit");
                                            edit.className = "icon-check";
                                            edit.removeAttribute("onclick");
                                            text.id = "value-shop-qty";
                                            edit.setAttribute("onclick", "doLimits('shop-user-qty')");

                                        } else if (change === "local-qty") {
                                            input = document.getElementById("local-qty");
                                            input.innerHTML = null;
                                            input.appendChild(text);


                                            edit = document.getElementById("local-qty-edit");
                                            edit.className = "icon-check";
                                            edit.removeAttribute("onclick");
                                            text.id = "value-local-qty";
                                            edit.setAttribute("onclick", "doLimits('local-user-qty')");

                                        } else if (change === "local-price") {
                                            input = document.getElementById("local-price");
                                            input.innerHTML = null;
                                            input.appendChild(text);


                                            edit = document.getElementById("local-price-edit");
                                            edit.className = "icon-check";
                                            edit.removeAttribute("onclick");
                                            text.id = "value-local-price";
                                            edit.setAttribute("onclick", "doLimits('local-user-price')");

                                        } else if (change === "shop-price") {
                                            input = document.getElementById("shop-price");
                                            input.innerHTML = null;
                                            input.appendChild(text);


                                            edit = document.getElementById("shop-price-edit");
                                            edit.className = "icon-check";
                                            edit.removeAttribute("onclick");
                                            text.id = "value-shop-price";
                                            edit.setAttribute("onclick", "doLimits('shop-user-price')");
                                        }
                                    }

                                    function doLimits(limitype) {

                                        var value;
                                        if (limitype === 'shop-user-qty') {
                                            value = document.getElementById("value-shop-qty").value;
                                        } else if (limitype === 'local-user-qty') {
                                            value = document.getElementById("value-local-qty").value;
                                        } else if (limitype === 'local-user-price') {
                                            value = document.getElementById("value-local-price").value;
                                        } else if (limitype === 'shop-user-price') {
                                            value = document.getElementById("value-shop-price").value;
                                        }


                                        var request = new XMLHttpRequest();
                                        request.onreadystatechange = function () {
                                            if (request.readyState === 4 && request.status === 200) {
                                                alert(request.responseText);

                                                window.location = "users.jsp";
                                            }
                                        };
                                        request.open("GET", "../Users?value=" + value + "&type=limit" + "&limitype=" + limitype, true);
                                        request.send();
                                    }

                                    function genarateDiscount() {
                                        var message = document.getElementById("message").value;
                                        var exp = document.getElementById("date-discount").value;
                                        var value = document.getElementById("value").value;

                                        if (loadUsers.length !== 0) {
                                            var ids = [];
                                            for (var i = 0; i < loadUsers.length; i++) {
                                                ids.push(loadUsers[i].id);
                                            }
                                            var user = {"id": ids};
                                            var users = JSON.stringify(user);

                                            var request = new XMLHttpRequest();
                                            request.onreadystatechange = function () {
                                                if (request.readyState === 4 && request.status === 200) {
                                                    alert(request.responseText);
                                                }
                                            };
                                            request.open("GET", "../SetDiscount?users=" + users + "&message=" + message + "&exp=" + exp + "&value=" + value, true);
                                            request.send();
                                        }
                                    }
        </script>

    </body>
</html>
