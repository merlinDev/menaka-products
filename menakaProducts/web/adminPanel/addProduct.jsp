<%-- 
    Document   : addItem
    Created on : Mar 10, 2018, 7:52:02 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="pojos.Packages"%>
<%@page import="pojos.Product"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.Criteria"%>
<%@page import="pojos.Category"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="../style/bootstrap.css" rel="stylesheet">
        <title>product add</title>
        <style type="text/css">

            .img{
                border-style: solid;
                border-width: 0.5px;
                border-radius: 3px;
                border-color: gray;
                width: 270px;
                height: 270px;
                margin-top: 10px;
            }
            .done{
                display: none;
                transition: 2s;
            }
            .item-register *, .package-register *, .packet-register *, .item-add *{
                margin: 10px;
                width: 350px;
            }
            input{
                padding: 5px 0 5px 10px;
            }
            select{
                height: 40px;
            }
            .item-register, .package-register, .packet-register,.item-add{
                text-align: center;
                padding: 20px;
                box-shadow: 0 3px 5px rgba(0,0,0,0.1);
                background-color: white;
                border-radius: 5px;
                max-width: 400px;
                height: auto;
                margin: 30px;
            }
            .sec{
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
                justify-items: center;
                grid-gap : 0px;
                grid-row-gap: 30px;
            }
        </style>
    </head>
    <body style="background-color: #636e72">


        <%
            Session s = NewHibernateUtil.getSessionFactory().openSession();

            Criteria c = s.createCriteria(Category.class);
            c.add(Restrictions.eq("status", "available"));

            List<Category> list = c.list();
        %>

        <div class="sec">

            <div>

                <!-- product register -->
                <div class="item-register" id="item-register">
                    <h5> products register </h5>
                    <input id="lol" type="text" placeholder="product name" ><br>
                    <select id="type">
                        <option>powder</option>
                        <option>pieces</option>
                    </select>
                    <label for="img" class="btn btn-outline-primary"> choose an image.</label><br>
                    <input type="file" id="img" style="display: none;">

                    <button class="btn btn-outline-danger" onclick="addItem();"> add product </button>
                    <br>

                </div>

                <!-- packets register -->
                <div class="packet-register" id="packet-register">
                    <h5> packets register </h5>
                    <input type="text" id="pkt-name" placeholder="packet name"><br>
                    <input type="number" min="0" placeholder="weight(g)" id="gram"><br>
                    <select id="pkt-type">
                        <option>powder</option>
                        <option>pieces</option>
                    </select>
                    <label for="pkt-img" class="btn btn-outline-primary"> choose an image.</label><br>
                    <input type="file" id="pkt-img" style="display: none;">

                    <button class="btn btn-outline-danger" onclick="addPacket();"> add packet </button>
                    <br>
                    <h3 id="done" style="color: blue"></h3>
                </div>

            </div>


            <!-- package register -->
            <div class="package-register" id="package-register">
                <h5> packages register </h5>
                <input type="text" id="pkg-name" placeholder="package name"><br>
                <textarea placeholder="description" id="pkg-desc" style="min-height: 120px; max-height: 120px;"></textarea><br><br>
                <select id="pkg-cat">
                    <option selected disabled>category</option>
                    <%
                        for (Category cat : list) {
                    %><option><%=cat.getType()%></option><%
                        }
                    %>
                </select><br>
                <input type="number" min="0" placeholder="package price(rs.)" id="pkg-price"><br>
                <label for="pkg-img" class="btn btn-outline-primary"> choose an image.</label><br>
                <input type="file" id="pkg-img" style="display: none;">

                <button class="btn btn-outline-danger" onclick="addPackage();"> add package </button>
                <br>

            </div>
        </div>

        <script type="text/javascript">
            function addItem() {

                var request = new XMLHttpRequest();

                var prname = document.getElementById("lol").value;
                var type = document.getElementById("type").value;
                console.log("name :" + prname);
                var img = document.getElementById("img").files;
                var fileType = img[0].name;
                var form = new FormData();
                form.append("prname", prname);
                form.append("type", type);
                form.append("imgType", fileType);
                form.append("img", img[0]);

                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        alert(request.responseText);
                    }

                };
                request.open("POST", "../saveProduct", true);
                request.send(form);

            }


            function addPackage() {
                var pkgName = document.getElementById("pkg-name").value;
                var pkgCat = document.getElementById("pkg-cat").value;
                var pkgDesc = document.getElementById("pkg-desc").value;
                var pkgPrice = document.getElementById("pkg-price").value;

                var img = document.getElementById("pkg-img").files;
                var fileType = img[0].name;

                var form = new FormData();

                form.append("pkgName", pkgName);
                form.append("pkgPrice", pkgPrice);
                form.append("pkgCat", pkgCat);
                form.append("pkgDesc", pkgDesc);
                form.append("imgType", fileType);
                form.append("pkgImg", img[0]);

                var request = new XMLHttpRequest();

                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        //var done = document.getElementById("done");
                        alert(request.responseText);
                    }

                };

                request.open("POST", "../savePackage", true);
                request.send(form);
            }

            function addPacket() {

                var pktName = document.getElementById("pkt-name").value;
                var gram = document.getElementById("gram").value;
                var type = document.getElementById("pkt-type").value;

                var img = document.getElementById("pkt-img").files;
                var fileType = img[0].name;

                var form = new FormData();

                form.append("pktName", pktName);
                form.append("type", type);
                form.append("gram", gram);
                form.append("imgType", fileType);
                form.append("pktImg", img[0]);

                var request = new XMLHttpRequest();

                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        //var done = document.getElementById("done");
                        alert(request.responseText);
                    }

                };

                request.open("POST", "../savePacket", true);
                request.send(form);
            }

            function changediv(div) {
                var change;
                if (div === 1) {
                    change = document.getElementById("item-register");
                    document.getElementById("package-register").style.cssText = "display : none";
                    document.getElementById("packet-register").style.cssText = "display : none";
                } else if (div === 2) {
                    change = document.getElementById("package-register");
                    document.getElementById("item-register").style.cssText = "display : none";
                    document.getElementById("packet-register").style.cssText = "display : none";
                } else if (div === 3) {
                    change = document.getElementById("packet-register");
                    document.getElementById("item-register").style.cssText = "display : none";
                    document.getElementById("package-register").style.cssText = "display : none";
                }
                document.getElementById("change").className = "item-register";
                change.style.cssText = "display: block;";
                document.getElementById("change").innerHTML = null;
                document.getElementById("change").innerHTML = change.innerHTML;
            }

        </script>
    </body>
</html>
