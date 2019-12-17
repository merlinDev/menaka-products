<%-- 
    Document   : packages
    Created on : May 2, 2018, 9:23:05 PM
    Author     : nipun
--%>

<%@page import="pojos.Category"%>
<%@page import="pojos.PackagesHasProduct"%>
<%@page import="pojos.User"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.List"%>
<%@page import="pojos.Packages"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link type="text/css" rel="stylesheet" href="style/viewProduct.css">
        <link type="text/css" rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="modal/remodal.css">
        <link rel="stylesheet" href="modal/remodal-default-theme.css">
        <link rel="stylesheet" href="SnackBar/snackbar.min.css">
        <link rel="stylesheet" href="style/search.css">
        <title>packages</title>

        <style>
            body { 
                font-size: 14px;
                margin: 0;
                padding: 0;
            }

            .flex-container {
                width: 100vw;	
                justify-content: center;
                align-items: center;
                display: flex;
                flex-flow: row wrap;
                flex-direction: flex-start;
            }

            .product {
                padding: 10px 5px;
                position: relative;
                max-width: 260px;
                margin: 20px;
                border: 1px solid rgba(180,180,180,0.4);
                height: auto;
                background-color: #fff;
                text-align: center; 
            }

            .product:hover {
                box-shadow: 0px 15px 11px -10px rgba(0,0,0,0.2);
                transition: 0.1s;
            }

            .product-title {
                padding: 1em;
                margin: 0;
                font-size: 16px;
            }

            .product-text {
                padding: 0 1em;
            }

            .butt {
                position: relative;
                width: 80%;
                margin: 1em 20% 0 10%;
                padding: 12px 24px;
                background-color: rgba(0,0,0,0.85);
                color: rgb(255, 255, 255);
                border: none;
            }

            .butt:hover {
                background-color: #2980b9;
                top: -2px;
                box-shadow: 0px 15px 11px -10px rgba(0,0,0,0.2);
                cursor: pointer;
                transition: 0.2s;
            }
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
    <body onload="load(1);">
        <%
            request.getSession().setAttribute("page", "packages.jsp");
            if (request.getSession().getAttribute("user") == null) {
                response.sendRedirect("login.jsp");
                request.getSession().setAttribute("note", "you must login first before browsing packages.");
            } else {
                User user = (User) request.getSession().getAttribute("user");
                if (user.getUsertype().getIdusertype() == 3 || user.getUsertype().getIdusertype() == 4) {
                    response.sendRedirect("userRestriction.html");
                }
            }
        %>
        <%@include file="nav.jsp" %>

        <br>
        <br>
        <div class="row no-gutters">
            <div class="col">
                <center>
                    <div class="search">
                        <input type="text" id="search" placeholder="i'm looking for..." autocomplete="off">
                        <button class="btn btn-sm btn-dark" onclick="load(1);">search</button>
                    </div>
                    <a href="#advanceSearch"> advance search </a>
                </center>
            </div>
        </div>


        <div id="main" class="flex-container">

        </div>

        <nav>
            <ul class="pagination pagination-sm justify-content-center">
                <li class="page-item"><a class="page-link" href="javascript:load(1);">1</a></li>
                    <%
                        Session s = NewHibernateUtil.getSessionFactory().openSession();
                        List<Packages> list = s.createCriteria(Packages.class).add(Restrictions.eq("status", "available")).list();
                        int pageno = 2;
                        int paging = 1;
                        for (Packages stock : list) {
                            paging++;
                            if (paging == 13) {
                    %><li class="page-item"><a class="page-link" href="javascript:load(<%=pageno%>);"><%=pageno%></a></li><%
                                paging = 1;
                                pageno++;
                            }
                        }
                    %>
            </ul>
        </nav>




        <!-- modals -->

        <div class="remodal" style="max-width: 530px; border-radius: 3px;" data-remodal-id="advanceSearch">

            <h5>search by,</h5>
            <br>
            <div class="advance">
                <div>
                    <span>price range :</span> 
                    <input type="number" id="price-from" placeholder="Rs."> to
                    <input type="number" id="price-to" placeholder="Rs.">
                </div>

                <div style="display: inline">
                    <span> category : </span>
                    <select id="cat-type">
                        <%
                            List<Category> listCat = s.createCriteria(Category.class)
                                    .add(Restrictions.eq("status", "available")).list();

                            for (Category elem : listCat) {
                        %>
                        <option><%=elem.getType()%></option>
                        <%
                            }
                        %>
                        <option selected>all</option>
                    </select>
                </div><br>

                <button data-remodal-action="confirm" class="btn btn-sm btn-primary" onclick="load(1);">search</button>
            </div>
        </div>

        <%
            List<Packages> pkg_list = s.createCriteria(Packages.class).add(Restrictions.eq("status", "available")).list();

            for (Packages elem : pkg_list) {
        %>

        <div id="product-<%=elem.getIdpackages()%>">

            <!-- modal box -->
            <div class="remodal" style="max-width: 530px; border-radius: 3px;" data-remodal-id="buy-<%=elem.getIdpackages()%>">
                <button data-remodal-action="close" class="remodal-close" aria-label="Close"></button>
                <div>
                    <img src="<%=elem.getPackageImage()%>" style="width: 170px;">
                    <h2><%=elem.getPackageName()%></h2><br>
                    <h5>Rs. <%=elem.getPrice()%></h5><br>

                    <p><small><%=elem.getDescription()%></small></p>

                    <center>
                        <div style="width: 250px;">
                            <ul style="text-align: left;">
                                <%
                                    List<PackagesHasProduct> list_pr = s.createCriteria(PackagesHasProduct.class)
                                            .add(Restrictions.eq("packages", elem)).list();
                                    for (PackagesHasProduct pr : list_pr) {
                                %><li> <small><%=pr.getProduct().getProductname()%> - <%=pr.getQty()%> <small>kg.</small></small> </li><%
                                    }
                                    %>
                            </ul>
                        </div>
                    </center>

                    <p>please select the quantity you'd like to buy</p>
                    <div class="qty-cat">
                        <input type="radio" id="<%=elem.getIdpackages()%>-box-1" name="gram"  value="1"> <label> 1 </label>
                        <input type="radio" id="<%=elem.getIdpackages()%>-box-2" name="gram" value="2"> <label> 2 </label>
                        <input type="radio" id="<%=elem.getIdpackages()%>-box-3" name="gram"  value="3"> <label> 3 </label>
                        <input type="radio" id="<%=elem.getIdpackages()%>-box-4" name="gram" value="4"> <label> 4 </label>

                    </div>
                </div>
                <br>
                <button data-remodal-action="cancel" class="remodal-cancel">Cancel</button>
                <button data-remodal-action="confirm" class="remodal-confirm" onclick="addtocart(<%=elem.getIdpackages()%>);">add to cart</button>
            </div>
        </div>


        <%
            }
        %>

        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="modal/remodal.js"></script>
        <script src="SnackBar/snackbar.min.js"></script>
        <script src="assets/js/show-alert.js"></script>
        <script type="text/javascript">

                    function load(page) {

                        document.getElementById("main").innerHTML = null;

                        var request = new XMLHttpRequest();

                        request.onreadystatechange = function () {
                            if (request.readyState === 4) {
                                if (request.status === 200) {

                                    var package_object_array = JSON.parse(request.responseText);
                                    for (var i = 0; i < package_object_array.length; i++) {
                                        var pkg = package_object_array[i];

                                        var pageno = pkg.page;

                                        if (pageno == page) {

                                            var pr_div = document.createElement("a");
                                            pr_div.className = "product";
                                            pr_div.setAttribute("href", "#buy-" + pkg.id);


                                            var img = document.createElement("img");
                                            img.src = pkg.img;
                                            img.className = "image";

                                            var pr_text = document.createElement("div");
                                            pr_text.className = "product-text";

                                            var p = document.createElement("p");
                                            p.innerHTML = pkg.name;

                                            var price = document.createElement("p");
                                            price.innerHTML = "price: rs. " + pkg.price;

                                            var small = document.createElement("small");

                                            pr_text.appendChild(img);
                                            pr_text.appendChild(p);
                                            pr_text.appendChild(price);
                                            pr_text.appendChild(document.createElement("br"));
                                            pr_text.appendChild(small);

                                            pr_div.appendChild(pr_text);

                                            document.getElementById("main").appendChild(pr_div);

                                        }



                                    }
                                }
                            }
                        };

                        var priceto = document.getElementById('price-to').value;
                        var pricefrom = document.getElementById('price-from').value;
                        var name = document.getElementById('search').value;
                        var cat = document.getElementById('cat-type').value;

                        request.open("GET", "loadPackages?pricefrom="+pricefrom+"&priceto="+priceto+"&name="+name+"&cat="+cat, true);
                        request.send();
                    }

                    function addtocart(id) {

                        var qty;

                        for (var i = 1; i < 5; i++) {
                            var check = document.getElementById(id + '-box-' + i);
                            if (check.checked) {
                                qty = check.value;
                                break;
                            }
                        }

                        var requset = new XMLHttpRequest();
                        requset.onreadystatechange = function () {
                            if (requset.readyState === 4) {
                                if (requset.status === 200) {
                                    if (requset.responseText === "LOGIN_0") {
                                        window.location = "index.jsp";
                                    } else if (requset.responseText === "done") {
                                        showAlert("added@cart");
                                    } else {
                                        showAlert(requset.responseText);
                                    }
                                }
                            }
                        };
                        requset.open("GET", "CheckPackageInput?id=" + id + "&qtyInput=" + qty, true);
                        requset.send();
                    }
        </script>
    </body>
</html>