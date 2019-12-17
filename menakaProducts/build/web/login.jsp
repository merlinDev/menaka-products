<%-- 
    Document   : login
    Created on : Mar 22, 2018, 11:27:53 PM
    Author     : nipun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link type="text/css" rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:100,300,400">
        <script> history.forward(); </script>
        <title>login</title>
        <style>
            #main input{
                padding: 10px;
                width: 300px;
                height: 35px;
                border-radius: 0;
            }
            #main button{
                width: 300px;
                border-radius: 0;
            }
            .hide{
                display: none;
            }

        </style>
    </head>
    <body>
        <%
            if (request.getSession().getAttribute("user") != null) {
                response.sendRedirect("userAccount.jsp");
            }
        %>
        <%@include file="nav.jsp" %>

        <div style="margin-top: 100px">
            <center>
                <div id="main" style="height:388px;width:360px;margin:auto;margin-top:71px;font-family:Roboto, sans-serif;font-weight:normal;">
                    <h4 class="text-center" data-aos="fade-down" data-aos-duration="750" style="margin-bottom:18px;">login</h4>
                    <input class="form-control" type="text" id="email" placeholder="email" data-aos="fade-up" data-aos-duration="550" required><br>
                    <input class="form-control" type="password" id="password" placeholder="password" data-aos="fade-up" data-aos-duration="550" required><br>
                    <button id="btn" class="btn btn btn-dark" onclick="login();"> log in</button><br><br>
                    <a href="javascript:forgot();">forgot password?</a>
                    <a href="userRegister.jsp">Register</a>
                    <br>
                    <!-- special note -->
                    <div id="note" style="margin-top: 50px;">
                        <%if (request.getSession().getAttribute("note") != null) {
                        %><label style="background-color: khaki;padding: 20px;"><%=request.getSession().getAttribute("note")%></label><%
                                request.getSession().setAttribute("note", null);
                            }
                        %>

                    </div>
                </div>
            </center>

        </div>

        <script type="text/javascript">
            function login() {
                var email = document.getElementById("email").value;
                var password = document.getElementById("password").value;
                
                var request = new XMLHttpRequest();
                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        
                        if (request.responseText === "login@1") {
                            
                            var page = '<%=request.getSession().getAttribute("page")%>';
                            
                            if (page === 'null') {
                                window.location = "index.jsp";
                            } else {
                                window.location = page;
                            }
                            
                        } else if (request.responseText === "paswordmatch@0") {
                            var note = document.getElementById("note");
                            note.innerHTML = "we can't find this account. please check your inputs and try again";
                            note.style.cssText = "background-color : #ff6b6b; padding : 10px; margin : 20px;";
                        }else if(request.responseText === "redirect@adminlogin@1"){
                            window.location = "adminPanel/dashboard.jsp";
                        }else if(request.responseText === "redirect@emplogin@1"){
                            window.location = "empPanel/deliveries.jsp";
                        }else {
                            var note = document.getElementById("note");
                            note.innerHTML = request.responseText;
                            note.style.cssText = "background-color : #ff6b6b; padding : 10px; margin : 20px;";
                        }
                    }
                };
                request.open("POST", "login", false);
                request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                request.send("email=" + email + "&password=" + password);
            }
            
            function forgot() {
                var pass = document.getElementById("password");
                
                pass.className = "hide";
                
                var btn = document.getElementById("btn");
                btn.removeAttribute("onclick");
                btn.innerHTML = "send";
                btn.setAttribute("onclick", "sendEmail();");
                
            }
            
            function sendEmail() {
                var email = document.getElementById("email").value;
                
                var request = new XMLHttpRequest();
                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        if (request.responseText === "send@1") {
                            window.location = "passwordReset.jsp";
                        } else {
                            if (document.getElementById("load") !== null) {
                                document.getElementById("main").removeChild(document.getElementById("load"));
                            }
                            var note = document.getElementById("note");
                            note.innerHTML = request.responseText;
                            note.style.cssText = "padding : 10px; margin : 20px; border : solid 1px rgba(0,0,0,0.3);";
                        }
                    } else {
                        
                        if (document.getElementById("load") === null) {
                            var note = document.getElementById("note");
                            note.style.display = "none";
                            var load = document.createElement("img");
                            load.src = "img/loading.gif";
                            load.id = "load";
                            load.style.cssText = "width:90px";
                            document.getElementById("main").appendChild(load);
                        }
                        
                    }
                };
                request.open("GET", "PasswordReset?email=" + email, true);
                request.send();
            }
        </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.1.1/aos.js"></script>
    </body>
</html>
