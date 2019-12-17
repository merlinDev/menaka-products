<%-- 
    Document   : zipcodes
    Created on : Jun 25, 2018, 6:26:15 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="pojos.Deliverydata"%>
<%@page import="pojos.Zip"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
        <title>zip codes</title>

        <style>
            body{
                background-color: black;
                padding: 30px;
            }
            .addnew *{
                width: 200px;
                padding: 3px 10px;
                margin-bottom: 10px;
            }
            .charge-change *{
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>

        <div style="background-color: white; padding: 10px;" class="container">
            <div class="row">
                <div class="col-md-6">
                    <br>
                    <div class="zipcodes">

                        <table id="zip-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>zipcode</th>
                                    <th>charge (rs.)</th>
                                    <th>user count in area</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    Session s = NewHibernateUtil.getSessionFactory().openSession();
                                    List<Zip> ziplist = s.createCriteria(Zip.class).list();

                                    for (Zip zip : ziplist) {

                                %>
                                <tr>
                                    <td><%=zip.getIdzip()%></td>
                                    <td><%=zip.getZipcode()%></td>
                                    <td><%=zip.getCharge()%></td>
                                    <td><%=zip.getLocations().size()%></td>
                                </tr>
                                <%

                                    }
                                %>
                            </tbody>
                        </table>

                    </div>
                </div>

                <div class="col-md-3">
                    <br>
                    <div class="addnew">
                        <input id="zipcode" placeholder="zip code"><br>
                        <input id="charge" placeholder="charge (rs.)"><br>
                        <button onclick="savezip();" class="btn btn-sm btn-primary"> add zip code </button>
                    </div>
                    <br>
                    <br>
                    <div class="charge-change">


                        <%
                            Deliverydata data = (Deliverydata) s.createCriteria(Deliverydata.class).uniqueResult();
                        %>


                        <h5 style="font-weight: bold;"> delivery charge </h5>
                        <input type="radio" name="chargeType" id="via-zip"> via zip code <small> (default) </small>
                        <br>
                        <input type="radio" name="chargeType" id="via-coordinte"> via location coordinates

                        <div style="margin-top: 30px;">
                            <h6 style="font-weight: bold;"> change delivery range, </h6>
                            <input id="km-range" type="range" value="<%=data.getMinKm()%>" min="5" max="100" step="5" onchange="changeKm();"><br>
                            <small> accept deliveries under : </small><label id="km"> <%=data.getMinKm()%> </label><small>km.</small><br>
                            <small> charge per km : Rs. </small><input value="<%=data.getChargePerKm()%>" style="width: 50px;height: 25px;" id="km-charge">
                        </div>
                        <button onclick="changeDeliveryData();" style="width: 200px;" class="btn btn-sm btn-primary"> save </button>
                    </div>
                </div>
            </div>
        </div>


        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
        <script src="../style/js/bootstrap.min.js"></script>

        <script>
                            $(document).ready(function () {
                                $('#zip-table').DataTable();
                            });

                            function savezip() {

                                var zipcode = document.getElementById("zipcode").value;
                                var charge = document.getElementById("charge").value;

                                var request = new XMLHttpRequest();

                                request.onreadystatechange = function () {
                                    if (request.readyState === 4 && request.status === 200) {
                                        alert(request.responseText);
                                        window.location = 'zipcodes.jsp';
                                    }
                                };
                                request.open("GET", "../SaveZip?zipcode=" + zipcode + "&charge=" + charge, true);
                                request.send();
                            }

                            function changeKm() {
                                var range = document.getElementById("km-range");
                                document.getElementById("km").innerHTML = range.value;
                            }


                            function changeDeliveryData() {
                                var via = "zip";
                                var range = document.getElementById("km-range").value;
                                var charge = document.getElementById("km-charge").value;

                                if (document.getElementById("via-coordinte").checked) {
                                    via = "km";
                                }

                                var request = new XMLHttpRequest();

                                request.onreadystatechange = function () {
                                    if (request.readyState === 4 && request.status === 200) {
                                        alert(request.responseText);
                                        window.location = 'zipcodes.jsp';
                                    }
                                };
                                request.open("POST", "../SaveZip?zipcode", true);
                                request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                request.send("via=" + via + "&range=" + range + "&charge=" + charge);
                            }


        </script>
    </body>
</html>
