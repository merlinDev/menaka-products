<%-- 
    Document   : addStock
    Created on : May 5, 2018, 1:26:08 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="pojos.InvoiceHasCartPackages"%>
<%@page import="pojos.InvoiceHasCartHasPackets"%>
<%@page import="java.util.Set"%>
<%@page import="pojos.Invoice"%>
<%@page import="pojos.InvoiceHasCartItem"%>
<%@page import="pojos.Packet"%>
<%@page import="pojos.Product"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Category"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>stock</title>

        <style>

            body{
                padding: 30px;
                background-color: black;
            }

            input[type="date"]{
                border: none;
            }
            tbody{
                font-size: 14px;
            }
            .edit{
                max-width: 55px;
                min-width: 55px;
            }
            .pkg-img:hover{
                cursor: pointer;
            }
            .add-stock{
                font-size: 14px;
                text-align: center
            }
            .add-stock *{
                padding: 2px 3px;
                width: 200px;
                margin-top: 10px;
            }
            .add-stock input[type="date"]{
                border-style: solid;
                border-width: 1px;
                border-color: rgba(1,1,1,0.1);
            }
            .pkg-items{
                text-align: left;
                width: 350px;
                padding: 20px;
                border: solid 1px rgba(0,0,0,0.1);
                display: none;
            }
            .pkg-items ul{
                padding: 20px;
            }

            .isolate{
                background-color: #23272b;
                color: white;
                padding: 10px;
                margin: 5px 0;
                border-radius: 3px;
            }
            .isolate input{
                margin: 5px;
            }
        </style>
    </head>
    <body onload="loadStock('loose');newStock('loose'); looseChart();pkgChart();pktChart();">

        <%
           
            Session s = NewHibernateUtil.getSessionFactory().openSession();
            List<Product> pr_list = s.createCriteria(Product.class).add(Restrictions.eq("status", "available")).list();
            List<Packet> pkt_list = s.createCriteria(Packet.class).add(Restrictions.eq("status", "available")).list();
            List<Category> cat_list = s.createCriteria(Category.class).add(Restrictions.eq("status", "available")).list();

        %>

        <div style="background-color: white; padding: 10px;" class="container-fluid">
            <div class="row">
                <div class="col-md-9">
                    <section>
                        <div>
                            <button class="btn btn-sm btn-dark" id="loose" onclick="chageDiv(1);
                                    loadStock('loose');
                                    newStock('loose');">loose item stock</button>
                            <button class="btn btn-sm btn-dark" id="packet" onclick="chageDiv(2);
                                    loadStock('pkt');
                                    newStock('pkt');">packet stock</button>
                            <button class="btn btn-sm btn-dark" id="package" onclick="chageDiv(3);
                                    loadStock('pkg');
                                    newStock('pkg');">packages</button>
                        </div>
                        <br>
                        <!-- loose items -->
                        <div class="table-responsive" id="loose-div">
                            <div class="isolate">
                                <input type="text" placeholder="search" id="loose-search" onkeyup="loadStock('loose');">
                            </div>
                            <div style="display: inline;padding: 10px;">
                                <div class="isolate">
                                    status : <select id="loose-status" onchange="loadStock('loose');">
                                        <option>all</option>
                                        <option>available</option>
                                        <option>n/a</option>
                                    </select>

                                </div>
                                <div class="isolate">
                                    price range : <input type="number" id="loose-price-from" onkeyup="loadStock('loose')"> to
                                    <input type="number" id="loose-price-to" onkeyup="loadStock('loose')">
                                </div>

                            </div>
                            <table class="table">

                                <thead class="thead-dark">
                                    <tr>
                                        <th>product</th>
                                        <th>qty (kg.)</th>
                                        <th>unit price (rs)</th>
                                        <th>status</th>
                                    </tr>
                                </thead>

                                <tbody id="loose-table-body">

                                </tbody>

                            </table>
                        </div>

                        <!-- packet items -->
                        <div class="table-responsive" id="pkt-div" style="display: none">
                            <div class="isolate">
                                <input type="text" placeholder="search" id="pkt-search" onkeyup="loadStock('pkt');">
                            </div>
                            <div style="display: inline">
                                <div class="isolate">
                                    status : <select id="pkt-status" onchange="loadStock('pkt');">
                                        <option>all</option>
                                        <option>available</option>
                                        <option>n/a</option>
                                    </select>
                                </div>
                                <div style="margin-left: 30px; display: inline; padding: 10px;">
                                    <div class="isolate">
                                        grind date : <input onchange="loadStock('pkt')" id="exp" type="date"> 
                                        expire date : <input id="man" type="date">
                                        <input type="text" placeholder="weight" id="gram" onkeyup="loadStock('pkt')"> grams.
                                    </div>

                                    <div class="isolate">
                                        price range : <input type="number" id="pkt-price-from" onkeyup="loadStock('pkt')"> to
                                        <input type="number" id="pkt-price-to" onkeyup="loadStock('pkt')">
                                    </div>

                                </div>
                            </div>
                            <table class="table">

                                <thead class="thead-dark">
                                    <tr>
                                        <th>packet</th>
                                        <th>qty</th>
                                        <th>unit price (rs)</th>
                                        <th>weight</th>
                                        <th>expire date</th>
                                        <th>grind date</th>
                                        <th>status</th>
                                    </tr>
                                </thead>

                                <tbody id="pkt-table-body">

                                </tbody>

                            </table>
                        </div>

                        <!-- package items -->

                        <div class="table-responsive" id="pkg-div" style="display: none; padding: 10px;">
                            <div class="isolate">
                                <input type="text" placeholder="search" id="pkg-search" onkeyup="loadStock('pkg');">
                            </div>
                            <div style="display: inline">
                                <div class="isolate">
                                    status : <select id="pkg-status" onchange="loadStock('pkg');">
                                        <option>all</option>
                                        <option>available</option>
                                        <option>n/a</option>
                                    </select>
                                </div>
                                <div class="isolate">
                                    category : <select id="cat" onchange="loadStock('pkg');">
                                        <option>all</option>
                                        <%                                        List<Category> list = s.createCriteria(Category.class)
                                                    .add(Restrictions.eq("status", "available")).list();

                                            for (Category cat : list) {
                                        %><option><%=cat.getType()%></option><%
                                            }
                                        %>
                                    </select>
                                </div>

                                <div class="isolate">
                                    price range : <input type="number" id="pkg-price-from" onkeyup="loadStock('pkg')"> to
                                    <input type="number" id="pkg-price-to" onkeyup="loadStock('pkg')">
                                </div>
                            </div>

                            <table class="table table-hover">

                                <thead class="thead-dark">
                                    <tr>
                                        <th></th>
                                        <th>package</th>
                                        <th>price (rs)</th>
                                        <th>category</th>
                                        <th>description</th>
                                        <th>status</th>
                                    </tr>
                                </thead>

                                <tbody id="pkg-table-body">

                                </tbody>
                            </table>
                        </div>
                    </section>
                </div>

                <!-- new stock -->               
                <div class="col-md-3">
                    <div class="add-stock">
                        <div id="add-loose-stock" style="display: none">
                            <label>product : </label><br>
                            <select id="product">
                                <%
                                    for (Product pr : pr_list) {
                                %><option><%=pr.getIdproduct()%>.<%=pr.getProductname()%> (<%=pr.getType()%>)</option><%
                                    }
                                %>
                            </select><br>
                            <input id="loose-price" type="text" placeholder="unit price"><br>
                            <input id="loose-qty" type="text" placeholder="quantitiy"><br>
                            <button class="btn btn-sm btn-primary" onclick="addStock('loose');">add stock</button>
                        </div>

                        <div id="add-pkt-stock" style="display: none">
                            <label>packet : </label><br>
                            <select id="packet-select">
                                <%
                                    for (Packet pkt : pkt_list) {
                                %><option><%=pkt.getIdpacket()%>.<%=pkt.getName()%>(<%=pkt.getType()%>)</option><%
                                    }
                                %>
                            </select><br>
                            <input id="pkt-price" type="text" placeholder="unit price"><br>
                            <input id="pkt-qty" type="text" placeholder="quantitiy"><br>
                            expire date : <input type="date" id="exp-date"><br>
                            grind date : <input type="date" id="man-date"><br>
                            <button class="btn btn-sm btn-primary" onclick="addStock('pkt');">add stock</button>
                        </div>

                        <div class="pkg-items" id="pkg-items">
                            <ul id="pkg-items-list">

                            </ul>
                            <br>
                        </div>
                    </div>
                    <br>

                    <!-- charts-->

                    <%
                        double looseShopQty = 0;
                        double looseLocalQty = 0;

                        int pktShopQty = 0;
                        int pktLocalQty = 0;

                        int pkgQty = 0;

                        List<Invoice> inv_list = s.createCriteria(Invoice.class)
                                .add(Restrictions.eq("status", "closed")).list();

                        System.out.println("llllllllll   " + inv_list.size());

                        for (Invoice elem : inv_list) {
                            Set<InvoiceHasCartItem> item_set = elem.getInvoiceHasCartItems();
                            Set<InvoiceHasCartHasPackets> pkt_set = elem.getInvoiceHasCartHasPacketses();
                            Set<InvoiceHasCartPackages> pkg_set = elem.getInvoiceHasCartPackageses();

                            if (!item_set.isEmpty()) {
                                for (InvoiceHasCartItem item : item_set) {
                                    if (item.getInvoice().getUser().getUsertype().getIdusertype() == 2) {
                                        looseLocalQty += item.getQty();
                                    } else if (item.getInvoice().getUser().getUsertype().getIdusertype() == 3) {
                                        looseShopQty += item.getQty();
                                    }
                                }
                            }

                            if (!pkt_set.isEmpty()) {
                                for (InvoiceHasCartHasPackets item : pkt_set) {
                                    if (item.getInvoice().getUser().getUsertype().getIdusertype() == 2) {
                                        pktLocalQty += item.getQty();
                                    } else if (item.getInvoice().getUser().getUsertype().getIdusertype() == 3) {
                                        pktShopQty += item.getQty();
                                    }
                                }
                            }

                            if (!pkg_set.isEmpty()) {
                                for (InvoiceHasCartPackages item : pkg_set) {
                                    pkgQty += item.getQty();
                                }
                            }
                        }


                    %>



                    <div>
                        <canvas id="looseChart"></canvas>
                        <label> local user's purchased :  <%=looseLocalQty%> <small>kg.</small></label><br>
                        <label> shop user's purchased :  <%=looseShopQty%> <small>kg.</small></label>
                    </div>
                    <br>
                    <div>
                        <canvas id="pktChart"></canvas>
                        <label> local user's purchased : <%=pktLocalQty%> <small> packets </small></label><br>
                        <label> shop user's purchased :  <%=pktShopQty%> <small> packets </small></label>
                    </div>
                    <br>
                    <div>
                        <canvas id="pkgChart"></canvas>
                        <label> local user's purchased : <%=pkgQty%> <small> packages </small> </label>
                    </div>
                    <br>
                </div>
            </div>
        </div>
        <input type="file" id="img-update" style="display: none">

        <script type="text/javascript">

            var loose = document.getElementById("loose-div");
            var pkt = document.getElementById("pkt-div");
            var pkg = document.getElementById("pkg-div");
            var items = document.getElementById("pkg-items");

            function chageDiv(div) {
                if (div === 1) {
                    pkt.style.cssText = "display:none";
                    pkg.style.cssText = "display:none";
                    items.style.cssText = "display:none";
                    loose.style.cssText = "display:block";
                } else if (div === 2) {
                    loose.style.cssText = "display:none";
                    pkg.style.cssText = "display:none";
                    items.style.cssText = "display:none";
                    pkt.style.cssText = "display:block";
                } else if (div === 3) {
                    loose.style.cssText = "display:none";
                    pkt.style.cssText = "display:none";
                    items.style.cssText = "display:none";
                    pkg.style.cssText = "display:block";
                }
            }


            function loadStock(type) {
                var search;
                var status;
                var cat = document.getElementById("cat").value;
                var exp;
                var man;
                var gram;
                var priceFrom;
                var priceTo;

                if (type === 'loose') {
                    search = document.getElementById("loose-search").value;
                    status = document.getElementById("loose-status").value;
                    priceFrom = document.getElementById("loose-price-from").value;
                    priceTo = document.getElementById("loose-price-to").value;
                } else if (type === 'pkt') {
                    priceFrom = document.getElementById("pkt-price-from").value;
                    priceTo = document.getElementById("pkt-price-to").value;
                    exp = document.getElementById("exp").value;
                    man = document.getElementById("man").value;
                    gram = document.getElementById("gram").value;

                    search = document.getElementById("pkt-search").value;
                    status = document.getElementById("pkt-status").value;

                } else if (type === 'pkg') {
                    priceFrom = document.getElementById("pkg-price-from").value;
                    priceTo = document.getElementById("pkg-price-to").value;

                    search = document.getElementById("pkg-search").value;
                    status = document.getElementById("pkg-status").value;
                }

                document.getElementById("loose-table-body").innerHTML = null;
                document.getElementById("pkt-table-body").innerHTML = null;
                document.getElementById("pkg-table-body").innerHTML = null;
                var request = new XMLHttpRequest();
                request.onreadystatechange = function () {
                    if (request.readyState === 4) {
                        if (request.status === 200) {
                            var stock_array = JSON.parse(request.responseText);
                            for (var i = 0; i < stock_array.length; i++) {
                                var stock = stock_array[i];
                                var tr = document.createElement("tr");

                                if (type === "loose") {
                                    // loose
                                    console.log("loose");
                                    var td1 = document.createElement("td");
                                    td1.innerHTML = stock.name + "("+stock.typ+")";
                                    td1.id = "name_" + stock.id;
                                    var td2 = document.createElement("td");
                                    td2.innerHTML = stock.qty;
                                    td2.id = "qty_" + stock.id;
                                    var td3 = document.createElement("td");
                                    td3.innerHTML = stock.price;
                                    td3.id = "price_" + stock.id;
                                    var td4 = document.createElement("td");
                                    td4.innerHTML = stock.status;
                                    td4.id = "status_" + stock.id;

                                    var td5 = document.createElement("td");
                                    var td6 = document.createElement("td");
                                    var btn = document.createElement("btn");

                                    btn.className = "btn btn-sm btn-warning";
                                    btn.innerHTML = "edit";
                                    btn.id = "edit_" + stock.id;
                                    btn.setAttribute("onclick", "edit('" + stock.id + "','loose');");

                                    var btn1 = document.createElement("btn");
                                    btn1.id = "save_" + stock.id;
                                    btn1.className = "btn btn-sm btn-primary";
                                    btn1.innerHTML = "save update";
                                    btn1.style.cssText = "margin-left:10px;display:none;";
                                    btn1.setAttribute("onclick", "saveUpdate('" + stock.id + "','loose')");

                                    var btn2 = document.createElement("btn");
                                    btn2.id = "delete_" + stock.id;
                                    btn2.className = "btn btn-sm btn-danger";
                                    btn2.innerHTML = "remove stock";
                                    btn2.style.cssText = "margin-left: 10px;";
                                    btn2.setAttribute("onclick", "removeStock('" + stock.id + "','loose');");

                                    td5.appendChild(btn);
                                    td5.appendChild(btn1);
                                    td6.appendChild(btn2);

                                    tr.appendChild(td1);
                                    tr.appendChild(td2);
                                    tr.appendChild(td3);
                                    tr.appendChild(td4);
                                    tr.appendChild(td5);
                                    tr.appendChild(td6);


                                    document.getElementById("loose-table-body").appendChild(tr);
                                } else if (type === "pkt") {
                                    // packet
                                    console.log("pkt");
                                    var td1 = document.createElement("td");
                                    td1.innerHTML = stock.name;
                                    td1.id = "name_" + stock.id;
                                    var td2 = document.createElement("td");
                                    td2.innerHTML = stock.qty;
                                    td2.id = "qty_" + stock.id;
                                    var td3 = document.createElement("td");
                                    td3.innerHTML = stock.price;
                                    td3.id = "price_" + stock.id;
                                    var td4 = document.createElement("td");
                                    td4.innerHTML = stock.gram;
                                    td4.id = "gram_" + stock.id;
                                    var td5 = document.createElement("td");
                                    td5.innerHTML = stock.exp;
                                    td5.id = "exp_" + stock.id;
                                    var td6 = document.createElement("td");
                                    td6.innerHTML = stock.man;
                                    td6.id = "man_" + stock.id;
                                    var td7 = document.createElement("td");
                                    td7.innerHTML = stock.status;
                                    td7.id = "status_" + stock.id;

                                    var td8 = document.createElement("td");
                                    var btn = document.createElement("btn");

                                    btn.className = "btn btn-sm btn-warning";
                                    btn.id = "edit_" + stock.id;
                                    btn.innerHTML = "edit";
                                    btn.setAttribute("onclick", "edit('" + stock.id + "','pkt');");

                                    var btn1 = document.createElement("btn");
                                    btn1.id = "save_" + stock.id;
                                    btn1.className = "btn btn-sm btn-primary";
                                    btn1.innerHTML = "save update";
                                    btn1.style.cssText = "margin-left:10px;display:none";
                                    btn1.setAttribute("onclick", "saveUpdate('" + stock.id + "','pkt')");

                                    var btn2 = document.createElement("btn");
                                    btn2.id = "delete_" + stock.id;
                                    btn2.className = "btn btn-sm btn-danger";
                                    btn2.innerHTML = "remove stock";
                                    btn2.style.cssText = "margin-left: 10px;";
                                    btn2.setAttribute("onclick", "removeStock('" + stock.id + "','pkt');");

                                    td8.appendChild(btn);
                                    td8.appendChild(btn1);
                                    td8.appendChild(btn2);


                                    tr.appendChild(td1);
                                    tr.appendChild(td2);
                                    tr.appendChild(td3);
                                    tr.appendChild(td4);
                                    tr.appendChild(td5);
                                    tr.appendChild(td6);
                                    tr.appendChild(td7);
                                    tr.appendChild(td8);

                                    document.getElementById("pkt-table-body").appendChild(tr);
                                } else if (type === "pkg") {
                                    // package
                                    console.log("pkg");

                                    var td1 = document.createElement("td");
                                    td1.innerHTML = stock.name;
                                    td1.id = "name_" + stock.id;

                                    var td2 = document.createElement("td");
                                    td2.innerHTML = stock.price;
                                    td2.id = "price_" + stock.id;
                                    var td3 = document.createElement("td");
                                    td3.innerHTML = stock.cat;
                                    td3.id = "cat_" + stock.id;
                                    var td4 = document.createElement("td");
                                    td4.innerHTML = stock.status;
                                    td4.id = "status_" + stock.id;

                                    var td5 = document.createElement("td");
                                    var btn = document.createElement("btn");

                                    btn.className = "btn btn-sm btn-warning";
                                    btn.innerHTML = "edit";
                                    btn.id = "edit_" + stock.id;
                                    btn.setAttribute("onclick", "edit('" + stock.id + "','pkg');");

                                    var btn1 = document.createElement("btn");
                                    btn1.id = "save_" + stock.id;
                                    btn1.className = "btn btn-sm btn-primary";
                                    btn1.innerHTML = "save";
                                    btn1.style.cssText = "margin-left:10px;display:none;max-width:100px;";
                                    btn1.setAttribute("onclick", "saveUpdate('" + stock.id + "','pkg')");

                                    var btn2 = document.createElement("btn");
                                    btn2.id = "delete_" + stock.id;
                                    btn2.className = "btn btn-sm btn-danger";
                                    btn2.innerHTML = "remove";
                                    btn2.style.cssText = "margin-left: 10px;";
                                    btn2.setAttribute("onclick", "removeStock('" + stock.id + "','pkg');");

                                    var btn3 = document.createElement("button");
                                    btn3.id = "add-package-item_" + stock.id;
                                    btn3.className = "btn btn-sm btn-primary";
                                    btn3.innerHTML = "add items";
                                    btn3.style.cssText = "margin-left: 10px;";

                                    btn3.setAttribute("onclick", "getpkgItems('" + stock.id + "');");

                                    td5.appendChild(btn);
                                    td5.appendChild(btn1);
                                    td5.appendChild(btn2);
                                    td5.appendChild(btn3);

                                    var td0 = document.createElement("td");
                                    var img = document.createElement("img");
                                    img.style.cssText = "width:50px;height:50px;";
                                    img.src = stock.img;


                                    var lbl = document.createElement("label");
                                    lbl.id = "img_" + stock.id;
                                    lbl.appendChild(img);
                                    td0.appendChild(lbl);

                                    var tdDesc = document.createElement("td");

                                    var desc = document.createElement("textArea");
                                    desc.style.cssText = "min-height: 50px;width:250px;";
                                    desc.innerHTML = stock.desc;
                                    desc.id = "desc_" + stock.id;
                                    desc.setAttribute("readonly", "");
                                    tdDesc.appendChild(desc);

                                    tr.appendChild(td0);
                                    tr.appendChild(td1);
                                    tr.appendChild(td2);
                                    tr.appendChild(td3);
                                    tr.appendChild(tdDesc);
                                    tr.appendChild(td4);
                                    tr.appendChild(td5);

                                    document.getElementById("pkg-table-body").appendChild(tr);
                                }

                            }

                        }
                    }
                };

                request.open("GET", "../Stock?type=" + type + "&search=" + search +
                        "&status=" + status + "&cat=" + cat + "&exp=" + exp + "&man=" + man +
                        "&gram=" + gram + "&pFrom=" + priceFrom + "&pTo=" + priceTo, true);
                request.send();
            }

            function edit(id, type) {

                var btn = document.getElementById("edit_" + id);
                btn.style.cssText = "display:none";

                var btnSave = document.getElementById("save_" + id);
                btnSave.style.cssText = "display:block";

                if (type === "loose") {
                    // edit loose item

                    var name = document.getElementById("name_" + id);
                    name.innerHTML = null;
                    name.className = "edit";
                    var select = document.createElement("select");
                    select.id = "product-change";
            <%                for (Product pr : pr_list) {
            %>

                    var option = document.createElement("option");
                    option.innerHTML = '<%=pr.getIdproduct()%>.<%=pr.getProductname() + "("+pr.getType()+")"%>';
                    select.appendChild(option);

            <%
                }
            %>

                    name.appendChild(select);

                    var qty = document.createElement("input");
                    qty.className = "edit";
                    var qty_edit = document.getElementById("qty_" + id);
                    qty.value = qty_edit.innerHTML;
                    qty_edit.innerHTML = null;
                    qty.id = "update-qty-" + id;
                    qty_edit.appendChild(qty);

                    var price = document.createElement("input");
                    price.className = "edit";
                    var price_edit = document.getElementById("price_" + id);
                    price.value = price_edit.innerHTML;
                    price_edit.innerHTML = null;
                    price.id = "update-price-" + id;
                    price_edit.appendChild(price);

                    var status = document.createElement("select");
                    status.id = "update-stauts-" + id;
                    var available = document.createElement("option");
                    available.innerHTML = "available";
                    var na = document.createElement("option");
                    na.innerHTML = "n/a";

                    status.appendChild(available);
                    status.appendChild(na);

                    var status_edit = document.getElementById("status_" + id);
                    status_edit.innerHTML = null;
                    status_edit.appendChild(status);


                } else if (type === "pkt") {
                    // edit pkt item

                    var name = document.getElementById("name_" + id);
                    name.innerHTML = null;
                    name.className = "edit";
                    var select = document.createElement("select");
                    select.id = "pkt-change";

            <%
                for (Packet pkt : pkt_list) {
            %>

                    var option = document.createElement("option");
                    option.innerHTML = '<%=pkt.getIdpacket()%>.<%=pkt.getName() + "("+pkt.getType()+")"%>';
                    select.appendChild(option);

            <%
                }
            %>
                    name.appendChild(select);

                    var qty = document.createElement("input");
                    qty.className = "edit";
                    qty.id = "qty-update-" + id;
                    var qty_edit = document.getElementById("qty_" + id);
                    qty.value = qty_edit.innerHTML;
                    qty_edit.innerHTML = null;
                    qty_edit.appendChild(qty);

                    var price = document.createElement("input");
                    price.className = "edit";
                    price.id = "price-update-" + id;
                    var price_edit = document.getElementById("price_" + id);
                    price.value = price_edit.innerHTML;
                    price_edit.innerHTML = null;
                    price_edit.appendChild(price);

                    var exp = document.createElement("input");
                    exp.id = "exp-update-" + id;
                    exp.type = "date";
                    var exp_edit = document.getElementById("exp_" + id);
                    exp.value = exp_edit.innerHTML;
                    exp_edit.innerHTML = null;
                    exp_edit.appendChild(exp);

                    var man = document.createElement("input");
                    man.id = "man-update-" + id;
                    man.type = "date";
                    var man_edit = document.getElementById("man_" + id);
                    man.value = man_edit.innerHTML;
                    man_edit.innerHTML = null;
                    man_edit.appendChild(man);

                    var status = document.createElement("select");
                    status.id = "status-update-" + id;

                    var avl = document.createElement("option");
                    avl.innerHTML = "available";

                    var na = document.createElement("option");
                    na.innerHTML = "n/a";

                    status.appendChild(avl);
                    status.appendChild(na);

                    var status_edit = document.getElementById("status_" + id);
                    status_edit.innerHTML = null;
                    status_edit.appendChild(status);





                } else if (type === "pkg") {
                    // edit pkg item


                    var name = document.createElement("input");
                    var name_edit = document.getElementById("name_" + id);
                    name.value = name_edit.innerHTML;
                    name_edit.innerHTML = null;
                    name.id = "update-name-" + id;
                    name_edit.appendChild(name);


                    var img = document.getElementById("img_" + id);
                    img.setAttribute("for", "img-update");
                    img.className = "pkg-img";


                    var cat = document.getElementById("cat_" + id);
                    cat.innerHTML = null;
                    cat.className = "edit";
                    var select = document.createElement("select");
                    select.id = "cat-change";
            <%                for (Category c : cat_list) {
            %>

                    var option = document.createElement("option");
                    option.innerHTML = '<%=c.getType()%>';
                    select.appendChild(option);

            <%
                }
            %>

                    cat.appendChild(select);

                    var price = document.createElement("input");
                    price.className = "edit";
                    var price_edit = document.getElementById("price_" + id);
                    price.value = price_edit.innerHTML;
                    price_edit.innerHTML = null;
                    price.id = "update-price-" + id;
                    price_edit.appendChild(price);

                    var desc = document.getElementById("desc_" + id);
                    desc.removeAttribute("readonly");


                    var status = document.createElement("select");
                    status.id = "update-status-" + id;
                    var available = document.createElement("option");
                    available.innerHTML = "available";
                    var na = document.createElement("option");
                    na.innerHTML = "n/a";

                    status.appendChild(available);
                    status.appendChild(na);

                    var status_edit = document.getElementById("status_" + id);
                    status_edit.innerHTML = null;
                    status_edit.appendChild(status);


                }
            }

            function getpkgItems(id) {
                var requset = new XMLHttpRequest();

                requset.onreadystatechange = function () {
                    if (requset.readyState === 4 && requset.status === 200) {
                        var arr = JSON.parse(requset.responseText);
                        var elem = document.getElementById("pkg-items-list");
                        var items = document.getElementById("pkg-items");
                        items.style.cssText = "display:block";
                        elem.innerHTML = null;
                        for (var i = 0; i < arr.length; i++) {
                            var item = arr[i];
                            elem.innerHTML += "<li> " + item.name + " <small>" + item.qty + " kg. </small> </li>";
                        }

                        var btn = document.createElement("button");
                        btn.name = "pkg-id";
                        btn.value = id;
                        btn.innerHTML = 'edit';
                        btn.className = "btn btn-sm btn-secondery";

                        var form = document.createElement("form");
                        form.action = "AddPkgItems.jsp";
                        form.method = "GET";

                        form.appendChild(btn);
                        elem.appendChild(form);
                    }
                }
                ;

                requset.open("GET", "../GetPkgItems?id=" + id, false);
                requset.send();
            }

            function saveUpdate(id, type) {
                var edit = document.getElementById("edit_" + id);
                var save = document.getElementById("save_" + id);

                edit.style.cssText = "display:block";
                save.style.cssText = "display:none";

                // saves updates

                var requset = new XMLHttpRequest();

                if (type === 'loose') {

                    var product = document.getElementById("product-change").value;
                    var qty = document.getElementById("update-qty-" + id).value;
                    var price = document.getElementById("update-price-" + id).value;
                    var status = document.getElementById("update-stauts-" + id).value;

                    requset.onreadystatechange = function () {
                        if (requset.readyState === 4) {
                            if (requset.status === 200) {
                                loadStock(type);
                                alert(requset.responseText);
                            }
                        }
                    };
                    requset.open("GET", "../UpdateStock?id=" + id + "&type=" + type + "&name=" + product +
                            "&qty=" + qty + "&price=" + price + "&status=" + status, true);
                    requset.send();
                } else if (type === 'pkt') {

                    var name = document.getElementById("pkt-change").value;
                    var qty = document.getElementById("qty-update-" + id).value;
                    var price = document.getElementById("price-update-" + id).value;
                    var exp = document.getElementById("exp-update-" + id).value;
                    var man = document.getElementById("man-update-" + id).value;
                    var status = document.getElementById("status-update-" + id).value;

                    requset.onreadystatechange = function () {
                        if (requset.readyState === 4) {
                            if (requset.status === 200) {
                                loadStock(type);
                                alert(requset.responseText);
                            }
                        }
                    };
                    requset.open("GET", "../UpdateStock?id=" + id + "&type=" + type + "&name=" + name + "&qty=" + qty +
                            "&price=" + price + "&status=" + status + "&exp=" + exp + "&man=" + man, true);
                    requset.send();

                } else if (type === 'pkg') {

                    var img = document.getElementById("img-update").files;
                    var fileType;
                    if (img[0] != undefined) {
                        fileType = img[0].name;
                    }

                    var name = document.getElementById("update-name-" + id).value;
                    var price = document.getElementById("update-price-" + id).value;
                    var status = document.getElementById("update-status-" + id).value;
                    var desc = document.getElementById("desc_" + id).value;
                    var cat = document.getElementById("cat-change").value;

                    var form = new FormData();
                    form.append("id", id);
                    form.append("name", name);
                    form.append("price", price);
                    form.append("status", status);
                    form.append("desc", desc);
                    form.append("cat", cat);
                    form.append("imgType", fileType);

                    if (img[0] != undefined) {
                        fileType = img[0].name;
                    }

                    requset.onreadystatechange = function () {
                        if (requset.readyState === 4) {
                            if (requset.status === 200) {
                                loadStock(type);
                                alert(requset.responseText);
                            }
                        }
                    };
                    requset.open("POST", "../UpdateStock", true);
                    requset.send(form);

                }

            }

            function removeStock(id, type) {
                var request = new XMLHttpRequest();

                var con = confirm("are you sure?");

                if (con) {
                    request.onreadystatechange = function () {
                        if (request.readyState === 4 && request.status === 200) {
                            if (request.responseText === "remove@1") {
                                alert("done");
                                loadStock(type);
                            }
                        }
                    };
                    request.open("GET", "../RemoveStock?id=" + id + "&type=" + type);
                    request.send();
                }
            }

            function  newStock(type) {
                var loose = document.getElementById("add-loose-stock");
                var pkt = document.getElementById("add-pkt-stock");
                if (type === 'loose') {
                    loose.style.cssText = "display : block";
                    pkt.style.cssText = "display : none";
                } else if (type === 'pkt') {
                    loose.style.cssText = "display : none";
                    pkt.style.cssText = "display : block";
                } else if (type === 'pkg') {
                    loose.style.cssText = "display : none";
                    pkt.style.cssText = "display : none";
                }
            }

            function addStock(type) {

                var request = new XMLHttpRequest();
                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        alert(request.responseText);
                        loadStock(type);
                    }
                };
                if (type === 'loose') {
                    var product = document.getElementById("product").value;
                    var price = document.getElementById("loose-price").value;
                    var qty = document.getElementById("loose-qty").value;

                    request.open("GET", "../AddStock?type=loose&product=" + product + "&loose-price=" + price + "&loose-qty=" + qty, true);
                } else if (type === 'pkt') {
                    var pkt = document.getElementById("packet-select").value;
                    var price = document.getElementById("pkt-price").value;
                    var qty = document.getElementById("pkt-qty").value;
                    var exp = document.getElementById("exp-date").value;
                    var man = document.getElementById("man-date").value;

                    request.open("GET", "../AddStock?type=pkt&packet=" + pkt + "&pkt-price=" + price + "&pkt-qty=" + qty + "&exp-date=" + exp + "&man-date=" + man, true);
                }
                request.send();
            }
        </script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>


        <!-- charts -->
        <script>

            function looseChart() {
                var ctxD = document.getElementById("looseChart").getContext('2d');
                var myLineChart = new Chart(ctxD, {
                    type: 'doughnut',
                    data: {
                        labels: ["localUser", "shopUser"],
                        datasets: [
                            {
                                data: [<%=looseLocalQty%>, <%=looseShopQty%>],
                                backgroundColor: ["#F7464A", "#46BFBD"],
                                hoverBackgroundColor: ["#FF5A5E", "#5AD3D1"]
                            }
                        ]
                    },
                    options: {
                        responsive: true
                    }
                });
            }

            function pktChart() {
                var ctxD = document.getElementById("pktChart").getContext('2d');
                var myLineChart = new Chart(ctxD, {
                    type: 'doughnut',
                    data: {
                        labels: ["localUser", "shopUser"],
                        datasets: [
                            {
                                data: [<%=pktLocalQty%>, <%=pktShopQty%>],
                                backgroundColor: ["#F7464A", "#46BFBD"],
                                hoverBackgroundColor: ["#FF5A5E", "#5AD3D1"]
                            }
                        ]
                    },
                    options: {
                        responsive: true
                    }
                });
            }

            function pkgChart() {
                var ctxD = document.getElementById("pkgChart").getContext('2d');
                var myLineChart = new Chart(ctxD, {
                    type: 'doughnut',
                    data: {
                        labels: ["localUser"],
                        datasets: [
                            {
                                data: [<%=pkgQty%>],
                                backgroundColor: ["#F7464A"],
                                hoverBackgroundColor: ["#FF5A5E"]
                            }
                        ]
                    },
                    options: {
                        responsive: true
                    }
                });
            }
        </script>

    </body>
</html>


<!-- 

*** advanced search ***

loose item,
    name
    most sold
    status

packet item,
    name
    exp
    man
    weight
    status
    most sold
    price range

package item,
    name
    status
    most sold
    category
    price range
    

-->