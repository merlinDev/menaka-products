<!DOCTYPE html>
<html>

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>userRegister</title>
        <link rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:100,300,400">
        <link rel="stylesheet" href="userRegister/css/Footer-Dark.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.1.1/aos.css">
        <link rel="stylesheet" href="userRegister/css/styles.css">
        <style>
            .done{
                padding: 10px 20px;
                background-color: rgba(0,0,0,0.1);
                border-radius: 5px;
                color: red;
            }
            
            input,button{
                border-radius: 0 !important;
            }

            .info{
                margin-top: 70px;
                padding: 30px;
                color: white;
            }
            .info h4{
                font-weight: bolder;
            }
            #shop-user-info{
                margin-top: 50px;
            }
        </style>
    </head>

    <body style="background-color:rgb(255,255,255);">
        <%@include file="nav.jsp" %>

        <div class="container">
            <div class="row">
                <div class="col">
                    <div id="form-div" style="height:388px;width:360px;margin:auto;margin-top:71px;font-family:Roboto, sans-serif;font-weight:normal;">
                        <div style="padding:20px 20px; text-align: center">
                            <h4 class="text-center" data-aos="fade-down" data-aos-duration="750" style="margin-bottom:18px;">sign up</h4>
                            <div class="form-group"><input class="form-control" type="text" id="name" placeholder="name" data-aos="fade-up" data-aos-duration="550" required></div>
                            <div class="form-group"><input class="form-control" type="email" id="email" placeholder="e-mail" data-aos="fade-up" data-aos-duration="550" data-aos-delay="150" required></div>
                            <div class="form-group"><input class="form-control" type="password" id="password" placeholder="password" data-aos="fade-up" data-aos-duration="550" data-aos-delay="300" required></div>
                            <div class="form-check" style="text-align: left;margin-bottom: 10px;">
                                <input class="form-check-input" type="checkbox" id="isShopUser" data-aos="fade-up" data-aos-duration="550" data-aos-delay="400" required>
                                <label class="form-check-label" for="isShopUser"> register as a shop user.&nbsp;<small> <a href="javascript:scrl();">learn more</a> </small></label>
                            </div>
                            <div class="form-group"><button  class="btn btn-outline-dark btn-block" onclick="register();" data-aos="fade-up" data-aos-duration="550" data-aos-delay="450">REGISTER</button></div>
                            <div class="form-group"><a href="login.jsp" data-aos="fade-up" data-aos-duration="550" data-aos-delay="600"><small>already have an account? click here to sign in.</small></a></div>
                            <div class="form-group"><small> <label id="done"></label></small> </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row info">
                <div>
                    <h4>JUST WANNA BUY SPICES?</h4>
                    <p> (simply register <span style="font-weight: bolder">without</span> checking the "register as a shop user" checkbox.)</p>
                    <p> local buyers has the freedom of buying our spices packages. means we got all covered up for 
                        your kitchen. all you gotta do is, choose what package suits best for your kitchen and order.
                    </p>
                </div>
                <br>
                <br>
                <div id="shop-user-info">
                    <h4>SHOP OWNER?</h4>
                    <p> (simply register checking the "register as a shop user" checkbox.)</p>
                    <p> shop owners can buy all our products at stock price. but.., since packages are our 
                        kind of things, shop users <span style="font-weight: bolder">cannot</span> buy
                        packages.
                    </p>
                </div>
            </div>
        </div>


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
                                window.location = "login.jsp";

                            } else {
                                document.getElementById("done").innerHTML = this.responseText;
                                document.getElementById("done").className = "done";
                            }

                        }
                    }
                };

                request.open("POST", "userRegister", false);
                request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                request.send(bind);

            }

            function scrl() {
                document.getElementById('shop-user-info').scrollIntoView({block: 'start', behavior: 'smooth'});
            }

        </script>
        <script src="userRegister/js/jquery.min.js"></script>
        <script src="style/js/bootstrap.min.js"></script>
        <script src="userRegister/js/bs-animation.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.1.1/aos.js"></script>

    </body>

</html>