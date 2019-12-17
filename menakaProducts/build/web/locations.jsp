<%-- 
    Document   : locations
    Created on : Apr 9, 2018, 7:59:01 PM
    Author     : nipun
--%>

<%@page import="pojos.Deliverydata"%>
<%@page import="java.util.List"%>
<%@page import="pojos.Zip"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="style/bootstrap.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Lobster" rel="stylesheet">
        <link rel="stylesheet" href="SnackBar/snackbar.min.css">
        <title>JSP Page</title>

        <style>
            body{
                font-weight: 300;
                font-family: 'Lobster';
            }

            .controls {
                padding-left: 10px; 
                padding-right: 10px;
                margin-top: 20px;
                width: 300px;
                border: solid 1px rgba(0,0,0,0.2);
                box-sizing: border-box;
                -moz-box-sizing: border-box;
                height: 37px;
                outline: none;

            }
            .head{
                margin-bottom: -30px;
                background-color: #3498db;
                border-radius: 10px 10px 0 0;
                margin-top: 30px;
                box-sizing: border-box;
                -moz-box-sizing: border-box;
                height: 80px;
                width: 300px;
                outline: none;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
            }
            .head label{
                color: white;
                margin-top: 15px;
            }
            #description {
                font-family: Roboto;
                font-size: 15px;
                font-weight: 300;
            }

            #infowindow-content .title {
                font-weight: bold;
            }

            #infowindow-content {
                display: none;
            }

            #map #infowindow-content {
                display: inline;
            }

            .pac-card {
                margin: 10px 10px 0 0;
                border-radius: 2px 0 0 2px;
                box-sizing: border-box;
                -moz-box-sizing: border-box;
                outline: none;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
                background-color: #fff;
                font-family: Roboto;
            }

            #pac-container {
                padding-bottom: 12px;
                margin-right: 12px;
            }

            .pac-controls {
                display: inline-block;
                padding: 5px 11px;
            }

            .pac-controls label {
                font-family: Roboto;
                font-size: 13px;
                font-weight: 300;
            }

            #pac-input {
                background-color: #fff;
                font-family: Roboto;
                font-size: 15px;
                font-weight: 300;
                margin-left: 12px;
                padding: 0 11px 0 13px;
                text-overflow: ellipsis;
                width: 400px;
            }

            #pac-input:focus {
                border-color: #4d90fe;
            }

            #title {
                color: #fff;
                background-color: #4d90fe;
                font-size: 25px;
                font-weight: 500;
                padding: 6px 12px;
            }
            #target {
                width: 345px;
            }
            .note{
                background: var(--blue);
                color: white;
                padding: 30px;
                height: 100%;
            }
            .note h4{
                font-weight: bold;
            }
        </style>
    </head>
    <body onload="userAgent();">
        <%@include file="nav.jsp"%>
        <% request.getSession().setAttribute("page", "locations.jsp");%>

        <!-- <a target="_blank" href="https://www.google.com/maps/search/?api=1&query=latitude,longitude"> show path</a> -->
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-4" style="padding: 30px;">
                    <center>
                        <div>
                            <label>please fill in your location details</label><br>
                            <input id="address" class="controls" type="text" placeholder="address"><br>
                            <small style="color: gray;">( please enter your address as accurate as you can ). </small><br>
                            <select id="zip" class="controls">
                                <%
                                    Session s = NewHibernateUtil.getSessionFactory().openSession();
                                    List<Zip> ziplist = s.createCriteria(Zip.class).list();

                                    for (Zip zip : ziplist) {
                                %>
                                <option><%=zip.getZipcode()%></option>
                                <%
                                    }
                                %>
                            </select><br>
                            <input id="street" class="controls" type="text" placeholder="street"><br>
                            <input id="contact" class="controls" type="text" placeholder="contact number"><br>
                        </div>
                        <div id="loc">
                            <button style="width: 300px; margin: 30px 0; border-radius: 0;" class="btn btn-primary" onclick="saveLocation();"> save location </button><br>
                            <button style="width: 300px; border-radius: 0;" class="btn btn-sm btn-outline-dark" onclick="window.location = 'viewCart.jsp';"> go to cart </button><br>
                        </div>
                    </center>
                </div>

                <div class="col-md-4">
                    <center>
                        <div style="padding: 30px 0;text-align: left;" id="map-div">
                            <div>
                                <small>let us know the nearest point for you.</small><br>
                                <small style="color: gray">(optional but recommended)</small>
                            </div>
                            <input style="width: 250px; height: 35px;" id="pac-input" class="controls" type="text" placeholder="Search location">
                            <div id="map" style="height: 350px; width: 400px;"></div>
                        </div>
                        <div style="text-align: left;">
                            <button onclick="marked = false; showAlert('marker removed');" class="btn btn-sm btn-secondary" style="border-radius: 0;"> clear location </button>
                        </div>
                    </center>
                </div>

                <div class="col-md-4">

                    <div id="note" class="note">
                        <% Deliverydata data = (Deliverydata) s.createCriteria(Deliverydata.class).uniqueResult();%>
                        <h4> How we manage your delivery charges? </h4>
                        <p> by default we charge you on your delivery via your zip code.</p>

                        <h4> if you provided your location </h4>
                        <p>however <span style="font-weight: bold">sometimes</span>, if you provided us your location, we calculate
                            the average distance to your location and we charge delivery
                            via Rs/Km (rupees per kilo meeter). 
                        </p>
                        <small style="background-color: white;color: black;padding: 10px;border-radius: 3px;"> current delivery charge per km : Rs. <%=data.getChargePerKm()%> </small>
                        <br><br>
                        <small>(please note that these values may change recently)</small>
                    </div>

                </div>
            </div>
        </div>
        <script src="assets/js/location.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBKtUU1e7zFyZ50uurIPPun4lBiW51A_KY&libraries=places&callback=initMap&callback=initAutocomplete"
        async defer></script>
        
        <script src="viewCart/js/jquery.min.js"></script>
        <script src="SnackBar/snackbar.min.js"></script>
        <script src="assets/js/show-alert.js"></script>

    </body>
</html>
