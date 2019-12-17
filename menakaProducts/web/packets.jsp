<%-- 
    Document   : packets
    Created on : May 2, 2018, 9:25:59 PM
    Author     : nipun
--%>

<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.PacketStock"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" rel="stylesheet" href="style/viewProduct.css">
        <link type="text/css" rel="stylesheet" href="style/css/bootstrap.min.css">
        <link type="text/css" rel="stylesheet" href="SnackBar/snackbar.min.css">
        <link rel="stylesheet" href="assets/css/autocomplete.css">
        <link rel="stylesheet" href="style/search.css">
        <link rel="stylesheet" href="modal/remodal.css">
        <link rel="stylesheet" href="modal/remodal-default-theme.css">
        <title>JSP Page</title>

        <style>
            .advance input[type="number"]{
                border-radius: 0;
                margin-bottom: 20px;
                height: 30px;
            }
            .advance *{
                margin: 5px;
            }
            .advance input, select{
                width: 110px;
                border: solid 1px rgba(0,0,0,0.3);
            }
            .advance button{
                width: 100px;
            }
        </style>

    </head>
    <body onload="loadPackets(1);">
        <% request.getSession().setAttribute("page", "packets.jsp");%>
        <%@include file="nav.jsp" %>

        <br>
        <br>
        <div class="row no-gutters">
            <div class="col">
                <center>
                    <div class="search">
                        <input type="text" id="search" placeholder="i'm looking for..." autocomplete="off">
                        <button class="btn btn-sm btn-dark" onclick="loadPackets(1);">search</button>
                    </div>
                    <a href="#advanceSearch"> advance search </a>
                </center>
            </div>
        </div>


        <div class="remodal" style="max-width: 530px; border-radius: 3px;" data-remodal-id="advanceSearch">

            <h5>search by,</h5>
            <br>
            <div class="advance">
                <div>
                    <span>price range :</span> 
                    <input type="number" id="price-from" placeholder="Rs."> to
                    <input type="number" id="price-to" placeholder="Rs.">
                </div>

                <div id="type" style="display: inline">
                    <span> spice type : </span>
                    <select id="spice-type">
                        <option>powder</option>
                        <option>pieces</option>
                        <option selected>all</option>
                    </select>
                </div><br>

                <div>
                    expire date : <input type="date" id="exp"><br>
                    weight (g) : <input type="number" id="gram">
                </div>
                <button data-remodal-action="confirm" class="btn btn-sm btn-primary" onclick="loadPackets(1);">search</button>
            </div>
        </div>


        <div class="products" id="packets"> 

        </div>

        <nav>
            <ul class="pagination pagination-sm justify-content-center">
                <li class="page-item"><a class="page-link" href="javascript:loadPackets(1);">1</a></li>
                    <%
                        Session s = NewHibernateUtil.getSessionFactory().openSession();
                        List<PacketStock> list = s.createCriteria(PacketStock.class).add(Restrictions.eq("status", "available")).list();
                        int pageno = 2;
                        int paging = 1;
                        for (PacketStock stock : list) {
                            paging++;
                            if (paging == 13) {
                    %><li class="page-item"><a class="page-link" href="javascript:loadPackets(<%=pageno%>);"><%=pageno%></a></li><%
                                paging = 1;
                                pageno++;
                            }
                        }
                    %>
            </ul>
        </nav>

        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="modal/remodal.js"></script>    
        <script type="text/javascript">
                    function loadPackets() {
                        document.getElementById("packets").innerHTML = null;
                        var request = new XMLHttpRequest();
                        request.onreadystatechange = function () {
                            if (request.readyState === 4) {

                                if (request.status === 200) {
                                    var item_object_array = JSON.parse(request.responseText);

                                    for (var i = 0; i < item_object_array.length; i++) {

                                        var item_object = item_object_array[i];

                                        var pr_item = document.createElement("div");
                                        pr_item.className = "products__item";

                                        var article = document.createElement("article");
                                        article.className = "product";

                                        var img = document.createElement("img");
                                        img.className = "image";
                                        img.src = item_object.image;

                                        var pr_price = document.createElement("label");
                                        pr_price.className = "product_price";
                                        pr_price.innerHTML = "Rs. " + item_object.price;

                                        var prName = document.createElement("h1");
                                        prName.className = "product__title";
                                        prName.innerHTML = item_object.name;

                                        var p = document.createElement("p");
                                        p.className = "product__text";

                                        var qty = document.createElement("input");
                                        qty.id = "qty_" + item_object.id;
                                        qty.type = "number";
                                        qty.max = "500";
                                        qty.placeholder = "quantity";

                                        var availableQty = document.createElement("label");
                                        availableQty.innerHTML = "AVL Qty : " + item_object.qty;
                                        availableQty.className = "availableQty";

                                        var infoMessage = document.createElement("label");
                                        infoMessage.id = "error_" + item_object.id;

                                        var exp = document.createElement("label");
                                        exp.innerHTML = "<small>EXP :" + item_object.exp + "</small>";

                                        var man = document.createElement("label");
                                        man.innerHTML = "<small>MAN :" + item_object.man + "</small>";


                                        var button = document.createElement("button");
                                        button.setAttribute("onclick", "checkItem('" + item_object.id + "')");
                                        button.className = "button btn btn-sm btn-primary";
                                        button.innerHTML = "add to cart";

                                        p.appendChild(button);
                                        article.appendChild(img);
                                        article.appendChild(document.createElement("br"));
                                        article.appendChild(prName);
                                        article.appendChild(man);
                                        article.appendChild(document.createElement("br"));
                                        article.appendChild(exp);
                                        article.appendChild(document.createElement("br"));
                                        article.appendChild(pr_price);
                                        article.appendChild(document.createElement("br"));
                                        article.appendChild(availableQty);
                                        article.appendChild(document.createElement("br"));
                                        article.appendChild(qty);
                                        article.appendChild(infoMessage);
                                        article.appendChild(p);
                                        pr_item.appendChild(article);
                                        document.getElementById("packets").appendChild(pr_item);
                                    }

                                }

                            } else {

                            }
                        };

                        var priceto = document.getElementById('price-to').value;
                        var pricefrom = document.getElementById('price-from').value;
                        var type = document.getElementById('spice-type').value;
                        var exp = document.getElementById('exp').value;
                        var name = document.getElementById('search').value;
                        var gram = document.getElementById('gram').value;

                        request.open("GET", "loadPackets?name=" + name + "&priceto=" + priceto + "&pricefrom=" + pricefrom + "&status=" + "&type=" + type + "&exp=" + exp + "&gram=" + gram, true);
                        request.send();
                    }

                    function checkItem(id) {
                        var qtyInput = document.getElementById("qty_" + id);
                        var request = new XMLHttpRequest();
                        request.onreadystatechange = function () {
                            if (request.readyState === 4 && request.status === 200) {
                                qtyInput.value = null;
                                showAlert(request.responseText);

                            }
                        };

                        request.open("GET", "CheckPacketInput?qtyInput=" + qtyInput.value + "&id=" + id, true);
                        request.send();
                    }


        </script>
        <script src="SnackBar/snackbar.min.js"></script>
        <script src="assets/js/show-alert.js"></script>
    </body>
</html>
