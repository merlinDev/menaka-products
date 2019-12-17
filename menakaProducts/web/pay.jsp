<%-- 
    Document   : pay
    Created on : May 27, 2018, 10:49:41 PM
    Author     : nipun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:100,400">
        
        <title>payment</title>
        <style>

            img{
                width: 5%;
                margin-left: 10px;
                display: none;
            }

            .pay{
                background-color: white;
                border-radius: 5px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
                padding: 50px;
                width: 390px;
                margin-top: 100px;
                font-family: 'Roboto',cursive;
                font-size: 14px;
                font-weight: 100;
            }
            .pay input[type="text"]{

                padding: 5px 10px;
                border-style: solid;
                border-radius: 3px;
                border-width: 1px;
                border-color: rgba(1,1,1,0.2);
            }
            .ccv{
                width: 240px;
            }
            .cvv{
                width: 100px;
            }
            .mm{
                width: 50px;
            }
            .yyyy{
                width: 50px;
            }
            .pay button{
                width: 390px;
            }

            #msg{
                background-color: #e74c3c;
                border-radius: 5px;
                color: white;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
                padding: 10px;
                width: 390px;
                margin-top: 30px;
                font-family: 'Roboto',cursive;
                font-size: 14px;
                display: none;
                text-align: center;
            }
        </style>
    </head>
    <body style="background-color: #ecf0f1;">
        <%
        if (request.getSession().getAttribute("paymentData") == null) {
                response.sendRedirect("viewCart.jsp");
            }
        %>
        <%@include file="nav.jsp" %>

    <center>
        <div class="pay">
            <form id="myCCForm" action="PaymentCheck" method="post">
                <input name="token" type="hidden" value="" />
                <div>
                    <input onkeyup="validateccv();" class="ccv" placeholder="card number" id="ccNo" type="text" autocomplete="off" required /> <img id="ccv-tick" src="img/tick.png">
                </div><br>
                <div>
                    <span>expire date :</span>   
                    <input onkeyup="validateexp();"  placeholder="MM" id="expMonth" type="text" size="4" required />
                    <span>/</span>
                    <input onkeyup="validateexp();" class="yyyy" placeholder="YY" id="expYear" type="text" size="4" required />
                </div><br>
                <div>
                    <span>cvc number : </span>
                    <input onkeyup="validatecvc();" placeholder="CVC" class="cvv" id="cvv" type="text" autocomplete="off" required /> <img id="cvv-tick" src="img/tick.png">
                </div><br>
                <input class="btn btn-sm btn-warning" type="submit" value="Submit Payment" />
            </form>
        </div>

        <label id="msg"></label>

    </center>

    <script type="text/javascript">
        function validateccv() {
            var key = document.getElementById("ccNo").value;
            var icon = document.getElementById("ccv-tick");
            var ticked = false;

            if ((key.length === 13 || key.length === 14 || key.length === 16 || key.length === 15 || key.length === 19) && !isNaN(key)) {
                ticked = true;
            } else {
                ticked = false;
            }

            if (ticked) {
                icon.style.cssText = "display:inline";
            } else {
                icon.style.cssText = "display:none";
            }
        }

        function validatecvc() {
            var key = document.getElementById("cvv").value;
            var icon = document.getElementById("cvv-tick");
            var ticked = false;

            if ((key.length === 3 || key.length === 4) && !isNaN(key)) {
                ticked = true;
            } else {
                ticked = false;
            }

            if (ticked) {
                icon.style.cssText = "display:inline";
            } else {
                icon.style.cssText = "display:none";
            }
        }


    </script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://www.2checkout.com/checkout/api/2co.min.js"></script>
    <script type="text/javascript">

        var successCallback = function (data) {
            var myForm = document.getElementById('myCCForm');
            myForm.token.value = data.response.token.token;
            myForm.submit();
        };

        var errorCallback = function (data) {
            if (data.errorCode === 200) {
            } else {
                var msg = document.getElementById("msg");
                msg.style.cssText = "display:block";
                msg.innerHTML = data.errorMsg;
            }
        };

        var tokenRequest = function () {
            var args = {
                sellerId: "901384140",
                publishableKey: "007D5331-256C-462E-B4EA-2DF582B9C2B2",
                ccNo: $("#ccNo").val(),
                cvv: $("#cvv").val(),
                expMonth: $("#expMonth").val(),
                expYear: $("#expYear").val()
            };

            TCO.requestToken(successCallback, errorCallback, args);
        };

        $(function () {

            TCO.loadPubKey('sandbox');

            $("#myCCForm").submit(function (e) {
                tokenRequest();
                return false;
            });
        });

    </script>
</body>
</html>
