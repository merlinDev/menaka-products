<%-- 
    Document   : indextest
    Created on : Jun 27, 2018, 7:56:13 PM
    Author     : nipun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Menaka Products</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/simple-line-icons/2.4.1/css/simple-line-icons.css">
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/styles.css">

        <style>
            .slide img{
                width: 700px;
                height: 300px;
                position: absolute;
            }
            .slide{
                display: flex;
                justify-content: center;
            }
        </style>
    </head>
    <body>
        <% request.getSession().setAttribute("page", "index.jsp");%>
        <div class="container-fluid">

            <!-- navbar -->
            <%@include file="nav.jsp" %>

            <!-- top -->
            <div class="row">
                <div class="col">
                    <div class="top">

                        <h1> <span style="color: white;background-color: black;padding: 0 10px;">Menaka</span> Products </h1>
                        <h4>the place where your taste bud meets the good old spicy taste. </h4>

                        <div data-aos="fade-down" data-aos-duration="1000" class="count-me" onclick="scrl();">
                            <%
                            if(request.getSession().getAttribute("user") == null){
                                %>
                                <button class="btn btn-sm btn-outline-dark" onclick="scrl();">count me in</button>
                            <%
                            }
                            %>
                        </div>

                    </div>

                </div>
            </div>


            <div id="div-02" class="container">
                <section id="section-02">
                    <div class="row">
                        <div class="col">
                            <div style="text-align:center;margin-top:190px;"><img src="assets/img/chili.jpg" style="width:37%;transform:scaleX(-1);">
                                <h1 data-aos="fade-up" data-aos-duration="700" data-aos-once="true" style="color:rgb(0,0,0);line-height:62px;letter-spacing:-2px;font-weight:bold;">JUST SPICE IT.</h1>
                                <p data-aos="fade-up" data-aos-duration="700" data-aos-delay="200" data-aos-once="true" style="color:rgb(0,0,0);">you choose exactly what you need and leave the rest to us.</p><button class="btn btn-outline-danger" type="submit" data-aos="fade-up" data-aos-duration="500" data-aos-delay="400" data-aos-once="true" style="width:175px;border-radius:20px;margin-top:15px;">browse spices</button></div>
                        </div>
                    </div>
                    <div class="row info" id="info-list">
                        <div class="col-md-4">
                            <p>we promise to deliver you the best quality and the best taste for your kitchen.</p> 
                        </div>
                        <div class="col-md-4 do-border">
                            <p>order your own packages. weekly, monthly or create a package that suits for your home.</p>
                        </div>
                        <div class="col-md-4">
                            <p> if you're a shop owner, buy our products at stock price.</p>
                        </div>
                    </div> 
                </section>
            </div>
        </div>


        <%
            if (request.getSession().getAttribute("user") == null) {
        %>

        <div id="reg-div" class="container-fluid" style="margin: 50px 0;">
            <div class="row" style="background-color: black; padding: 20px;">
                <div class="col-md-4" style="background-color: white; max-width: 380px;">
                    <div id="form-div" style="font-family:Roboto, sans-serif;font-weight:normal">
                        <div style="padding:20px 20px; text-align: center;">
                            <h4 class="text-center" data-aos="fade-down" data-aos-duration="750" style="margin-bottom:18px;">REGISTER</h4>
                            <div class="form-group"><input class="form-control" type="text" id="name" placeholder="name" data-aos="fade-up" data-aos-duration="550" required></div>
                            <div class="form-group"><input class="form-control" type="email" id="email" placeholder="e-mail" data-aos="fade-up" data-aos-duration="550" data-aos-delay="150" required></div>
                            <div class="form-group"><input class="form-control" type="password" id="password" placeholder="password" data-aos="fade-up" data-aos-duration="550" data-aos-delay="300" required></div>
                            <div class="form-check" style="text-align: left;margin-bottom: 10px;">
                                <input class="form-check-input" type="checkbox" id="isShopUser" data-aos="fade-up" data-aos-duration="550" data-aos-delay="400" required>
                                <label class="form-check-label" for="isShopUser"> register as a shop user.</label>
                            </div>
                            <div class="form-group"><button  class="btn btn-outline-dark btn-block" onclick="register();" >REGISTER</button></div>
                            <div class="form-group"><a href="login.jsp"><small>already have an account? click here to sign in.</small></a></div>
                            <div class="form-group"><small> <label id="done"></label></small> </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="reg-info">
                        <div>
                            <h4>JUST WANNA BUY SPICES?</h4>
                            <p> (simply register <span style="font-weight: bolder">without</span> checking the "register as a shop user" checkbox.)</p>
                            <p> local buyers has the freedom of buying our spices packages. means we got all covered up for 
                                your kitchen. all you gotta do is, choose what package suits best for your kitchen and order.
                            </p>
                        </div>
                        <br>
                        <br>
                        <div>
                            <h4>SHOP OWNER?</h4>
                            <p> (simply register checking the "register as a shop user" checkbox.)</p>
                            <p> shop owners can buy all our products at stock price. but.., since packages are our 
                                kind of things, shop users <span style="font-weight: bolder">cannot</span> buy
                                packages.
                            </p>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%
            }
        %>

        <!--product info-->
    <center>
        <h1 style="font-weight: bolder"> ON A NUTSHELL </h1>
        <p style="font-weight: 300"> here are our products</p>
    </center>
    <div class="container">
        <div class="row items">
            <div class="col">
                <div class="row spice">
                    <div class="col-sm-4 item-img"></div>
                    <div class="col-sm-8 item-info">
                        <h3>spices</h3>

                        <p> local buyers has the freedom of buying our spices packages. means we got all covered up for 
                            your kitchen. all you gotta do is, choose what package suits best for your kitchen and order.
                        </p>
                        <br>
                        <button onclick="window.location = 'products.jsp';" class="btn btn-sm btn-outline-dark"> browse spices </button>
                    </div>
                </div>
                <div class="row packet">
                    <div class="col-sm-4 item-img"></div>
                    <div class="col-sm-8 item-info">
                        <h3>spices packets</h3>

                        <p> local buyers has the freedom of buying our spices packages. means we got all covered up for 
                            your kitchen. all you gotta do is, choose what package suits best for your kitchen and order.
                        </p>
                        <br>
                        <button onclick="window.location = 'packets.jsp';" class="btn btn-sm btn-outline-dark"> browse spices packets </button>
                    </div>
                </div>
                <div class="row package">
                    <div class="col-sm-4 item-img"></div>
                    <div class="col-sm-8 item-info">
                        <h3>packages</h3>

                        <p> local buyers has the freedom of buying our spices packages. means we got all covered up for 
                            your kitchen. all you gotta do is, choose what package suits best for your kitchen and order.
                        </p>
                        <br>
                        <button onclick="window.location = 'packages.jsp';" class="btn btn-sm btn-outline-dark"> browse packages </button>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
                            AOS.init();

                            function scrl() {
                                document.getElementById('reg-div').scrollIntoView({block: 'start', behavior: 'smooth'});
                            }
                            
    </script>

    <script type="text/javascript">

        function register() {

            var name = document.getElementById("name");
            var email = document.getElementById("email");
            var password = document.getElementById("password");
            var isShopUser = document.getElementById("isShopUser").checked;
            var userType = '2';

            if (isShopUser) {
                userType = '3';
            }


            var request = new XMLHttpRequest();

            var bind = "name=" + name.value + "&email=" + email.value + "&password=" + password.value + "&usertype=" + userType;

            request.onreadystatechange = function () {
                if (request.readyState === 4) {
                    if (request.status === 200) {

                        if (request.responseText === "user_saved") {
                            document.getElementById("done").innerHTML = "done";
                            document.getElementById("done").className = "done";
                            window.location = "userGuide.jsp";

                        } else {
                            document.getElementById("done").innerHTML = this.responseText;
                            document.getElementById("done").className = "done";
                        }

                    }
                }
            };

            request.open("POST", "userRegister", true);
            request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            request.send(bind);
        }

    </script>
</body>
</html>
