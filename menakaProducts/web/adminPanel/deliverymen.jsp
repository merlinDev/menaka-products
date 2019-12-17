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
                background-color: black;
                padding: 30px;
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

            .emp-reg input{
                width: 270px;
                padding: 5px 10px;
                margin: 10px;
                border: solid 1px rgba(0,0,0,0.2);
            }
            .emp-reg{
                margin-top: 90px;
            }.emp-reg h6{
                margin: 10px;
                font-weight: bold;
            }
        </style>
        <title>delivery men</title>
    </head>
    <body onload="load();">

        <div style="background-color: white; padding: 10px;" class="container-fluid">

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

                        <div class="table-responsive" style="margin-top: 20px;">
                            <table id="tab" class="table table-sm table-hover">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>user</th>
                                        <th>registered date</th>
                                        <th>email</th>
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
                    <form class="emp-reg" action="../userRegister" method="POST">
                        <h6>REGISTER NEW DELIVERYMAN</h6>
                        <input name="name" placeholder="name">
                        <input name="email" placeholder="email">
                        <input name="usertype" value="4" type="hidden">
                        <input type="password" name="password" placeholder="password"><br>
                        <input class="btn btn-sm btn-dark" type="submit" value="REGISTER">
                    </form>
                </div>
            </div>
            <br>
            <br>

        </div>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
        <script src="../style/js/bootstrap.min.js"></script>
        <script type="text/javascript">


                            var loadUsers;

                            function load() {
                                var search = document.getElementById("search").value;
                                var online = document.getElementById("online").value;
                                var status = document.getElementById("status").value;
                                var user = "employees";
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
                                            td1.innerHTML = "#" + user.id + " " + user.name;
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
                                            var info = document.createElement("button");
                                            info.className = "btn btn-sm btn-dark";
                                            info.innerHTML = "show deliveries";
                                            info.setAttribute("onclick", "window.open('deliveryData.jsp?user=" + user.id + "','_blank');");

                                            td7.appendChild(info);

                                            tr.appendChild(td1);
                                            tr.appendChild(td2);
                                            tr.appendChild(td3);
                                            tr.appendChild(td4);
                                            tr.appendChild(td5);
                                            tr.appendChild(td6);
                                            tr.appendChild(td7);

                                            table.appendChild(tr);

                                        }
                                    }
                                };
                                request.open("GET", "../Users?search=" + search + "&online=" + online + "&status=" + status + "&usertype=" + user + "&invoices=" + "&type=search", true);
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


        </script>

    </body>
</html>
