<%-- 
    Document   : products
    Created on : May 2, 2018, 9:27:15 PM
    Author     : nipun
--%>

<%@page import="org.json.simple.JSONArray"%>
<%@page import="pojos.Product"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.LooseStock"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" rel="stylesheet" href="style/css/bootstrap.min.css">
        <link type="text/css" rel="stylesheet" href="style/search.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/simple-line-icons/2.4.1/css/simple-line-icons.css">
        <link href="https://fonts.googleapis.com/css?family=Anton" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="SnackBar/snackbar.min.css"> 
        <link rel="stylesheet" href="modal/remodal.css">
        <link rel="stylesheet" href="modal/remodal-default-theme.css">
        <link rel="stylesheet" href="style/product.css">
        <link rel="stylesheet" href="assets/css/autocomplete.css">

        <title>spices</title>

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
    <body onload="loadProducts(1);">
        <% request.getSession().setAttribute("page", "products.jsp");%>
        <%@include file="nav.jsp" %>
        <br>
        <%if (request.getSession().getAttribute("user") != null) {
                User user = (User) request.getSession().getAttribute("user");
                if (user.getUsertype().getIdusertype() == 4) {
                    response.sendRedirect("userRestriction.html");
                }
        %><div class="message">

        </div><%
            }
        %>


        <div class="container">



            <div class="row no-gutters">
                <div class="col">
                    <center>
                        <div class="search">
                            <input type="text" id="search" placeholder="i'm looking for..." autocomplete="off">
                            <button class="btn btn-sm btn-dark" onclick="loadProducts(1);">search</button>
                        </div>
                        <a href="#advanceSearch"> advance search </a>
                    </center>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <div class="main" id="products"> 

                    </div>
                </div>
            </div>
        </div>



        <nav>
            <ul class="pagination pagination-sm justify-content-center">
                <li class="page-item"><a class="page-link" href="javascript:loadProducts(1);">1</a></li>

                <%
                    Session s = NewHibernateUtil.getSessionFactory().openSession();
                    int pageno = 2;
                    int paging = 1;
                    List<Product> product_List = s.createCriteria(Product.class).add(Restrictions.eq("status", "available")).list();
                    // getting looseStock on only available products
                    for (Product product : product_List) {
                        List<LooseStock> stock_list = s.createCriteria(LooseStock.class)
                                .add(Restrictions.eq("status", "available"))
                                .add(Restrictions.eq("product", product))
                                .add(Restrictions.ge("qty", 0.0)).list();
                        for (LooseStock stock : stock_list) {
                            paging++;
                            if (paging == 13) {
                %><li class="page-item"><a class="page-link" href="javascript:loadProducts(<%=pageno%>);"><%=pageno%></a></li><%
                        paging = 1;
                        pageno++;
                    }
                    %>


                <div id="product-<%=stock.getIditem()%>">

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
                            </div>
                            <br>
                            <div id="type" style="display: inline">
                                <span> status : </span>
                                <select id="status">
                                    <option>available</option>
                                    <option>not available</option>
                                    <option selected>all</option>
                                </select>
                            </div><br>
                            <button data-remodal-action="confirm" class="btn btn-sm btn-primary" onclick="loadProducts(1);">search</button>
                        </div>
                    </div>

                    <!-- modal box -->
                    <div class="remodal" style="max-width: 530px; border-radius: 3px;" data-remodal-id="buy-<%=stock.getIditem()%>">
                        <button data-remodal-action="close" class="remodal-close" aria-label="Close"></button>
                        <div>
                            <img src="<%=stock.getProduct().getImg()%>" style="width: 170px;">
                            <h2><%=stock.getProduct().getProductname()%></h2><br>
                            <h5>Rs. <%=stock.getUprice()%></h5><br>
                            <p>please select the quantity you'd like to buy</p>
                            <div class="qty-cat">
                                <input type="radio" id="gram1" name="gram" onclick="changeQty(this.value, 'qty_<%=stock.getIditem()%>');" value="0.25"> <label> 250g </label>
                                <input type="radio" id="gram2" name="gram" onclick="changeQty(this.value, 'qty_<%=stock.getIditem()%>');"  value="0.5"> <label> 500g </label>
                                <input type="radio" id="gram3" name="gram" onclick="changeQty(this.value, 'qty_<%=stock.getIditem()%>');"  value="1"> <label> 1kg </label>
                                <input type="radio" id="gram4" name="gram" onclick="changeQty(this.value, 'qty_<%=stock.getIditem()%>');"  value="5"> <label> 5kg </label>
                                <br>
                                <small>or</small><br>
                                <input onkeyup="clear();" id="qty_<%=stock.getIditem()%>" class="qty-input" type="text" placeholder="custom quantity">
                                <label>kg</label>
                            </div>
                        </div>
                        <br>
                        <button data-remodal-action="cancel" class="remodal-cancel">Cancel</button>
                        <button data-remodal-action="confirm" class="remodal-confirm" onclick="checkItem(<%=stock.getIditem()%>);">add to cart</button>
                    </div>
                </div>


                <%
                        }

                    }

                %>



            </ul>
        </nav>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="modal/remodal.js"></script>
        <script type="text/javascript">
                            function loadProducts(page) {
                                document.getElementById("products").innerHTML = null;
                                var search = document.getElementById("search").value;
                                var request = new XMLHttpRequest();
                                request.onreadystatechange = function () {
                                    if (request.readyState === 4) {
                                        var div = document.getElementById("products");

                                        if (request.status === 200) {
                                            var item_object_array = JSON.parse(request.responseText);

                                            for (var i = 0; i < item_object_array.length; i++) {
                                                var item_object = item_object_array[i];

                                                var pageno = item_object.page;

                                                if (pageno == page) {

                                                    var infoMessage = document.createElement("label");
                                                    infoMessage.id = "error_" + item_object.id;

                                                    var buttonDiv = document.createElement("a");
                                                    buttonDiv.setAttribute("href", "#buy-" + item_object.id);
                                                    buttonDiv.className = "link";

                                                    var product = document.createElement("div");
                                                    product.className = "product";

                                                    var img = item_object.image;

                                                    var image = document.createElement("div");
                                                    image.className = "image";
                                                    image.style.backgroundImage = "url('" + img + "')";

                                                    var name = document.createElement("div");
                                                    name.className = "name";
                                                    name.innerHTML = item_object.name;

                                                    var qty = document.createElement("label");
                                                    qty.className = "qty";
                                                    qty.innerHTML = "available " + item_object.qty + " kg.";

                                                    var price = document.createElement("label");
                                                    price.className = "price";
                                                    price.innerHTML = "Rs. " + item_object.price;

                                                    if (item_object.status === "na" || item_object.status === "delete") {
                                                        qty.className = "not-available";
                                                        qty.innerHTML = "stock not available";
                                                    }

                                                    product.appendChild(image);
                                                    product.appendChild(name);
                                                    product.appendChild(qty);
                                                    product.appendChild(price);

                                                    buttonDiv.appendChild(product);
                                                    if (item_object.status !== "delete") {
                                                        div.appendChild(buttonDiv);
                                                    }

                                                }

                                            }

                                        } else {
                                            var div = document.getElementById("products");
                                            div.className = null;
                                            div.className = "load";
                                        }
                                    }


                                };

                                var priceto = document.getElementById('price-to').value;
                                var pricefrom = document.getElementById('price-from').value;
                                var status = document.getElementById('status').value;
                                var type = document.getElementById('spice-type').value;

                                request.open("GET", "loadItems?search=" + search + "&priceFrom=" + pricefrom + "&priceTo=" + priceto + "&type=" + type + "&status=" + status, true);
                                request.send();
                                document.getElementById('products').scrollIntoView({block: 'start', behavior: 'smooth'});
                            }

                            function checkItem(id) {

                                var gram = document.getElementsByName("gram1");
                                if (gram.checked) {
                                    alert(gram.value);
                                }

                                var qtyInput = document.getElementById("qty_" + id);

                                var request = new XMLHttpRequest();
                                request.onreadystatechange = function () {
                                    if (request.readyState === 4 && request.status === 200) {

                                        showAlert(request.responseText);
                                        qtyInput.value = null;
                                    }
                                };

                                request.open("GET", "CheckLooseInput?qtyInput=" + qtyInput.value + "&id=" + id, true);
                                request.send();
                            }

                            function changeQty(val, id) {
                                document.getElementById(id).value = val;
                            }

                            function clear() {
                                for (var i = 1; i < 5; i++) {
                                    document.getElementById("gram" + i).checked = false;
                                }
                            }


                            function toggleSearch() {
                                var advance = document.getElementById("advance-search");

                                if (advance.style.display === 'block') {
                                    advance.style.display = 'none';

                                    document.getElementById('price-to').value = null;
                                    document.getElementById('price-from').value = null;
                                    document.getElementById('status').value = 'all';
                                    document.getElementById('spice-type').value = 'all';
                                } else {
                                    advance.style.display = 'block';
                                }
                            }

        </script>
        <script>

            <%                JSONArray array = new JSONArray();
                for (Product elem : product_List) {
                    array.add(elem.getProductname());
                }
            %>

            var all = <%=array%>;
            var items = ["<%=array.get(0)%>", "<%=array.get(1)%>", "<%=array.get(2)%>", "<%=array.get(3)%>", "<%=array.get(4)%>"];

        </script>
        <script src="SnackBar/snackbar.min.js"></script>
        <script src="assets/js/search.js"></script>
        <script src="assets/js/show-alert.js"></script>

    </body>
</html>
