<%-- 
    Document   : passwordReset
    Created on : May 23, 2018, 2:39:43 PM
    Author     : nipun
--%>

<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Resetcode"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="style/css/bootstrap.min.css" rel="stylesheet">
        <title>password reset</title>

        <style>
            .main{
                margin-top: 150px;
                text-align: center;
            }
            .main input {
                width: 290px;
                padding: 5px;
            }
            .verify{
                width: 290px;
            }
            .alrt{
                padding: 20px;
                background-color: #fab1a0;
                border: none;
                border-radius: 3px;
            }
        </style>
    </head>
    <body>

        <section>

            <center>
                <div class="main" id="main">
                    <input id="code" type="text" placeholder="enter the code here"><br><br>
                    <button id="verify" class="btn btn-sm btn-primary verify" onclick="verify();"> verify </button>

                </div>
                <div id="note">

                </div>
            </center>


        </section>

        <script type="text/javascript">
            var resetCode;
            function verify() {
                var code = document.getElementById("code");
                resetCode = code.value;
                var request = new XMLHttpRequest();
                request.onreadystatechange = function () {
                    
                    if (request.readyState === 4 && request.status === 200) {
                        
                        if (request.responseText === "verified@1") {
                            
                            var note = document.getElementById("note");
                            note.innerHTML = null;
                            
                            var password = document.createElement("input");
                            password.type = "password";
                            password.id = "password";
                            var confirm = document.createElement("input");
                            confirm.type = "password";
                            confirm.id = "confirm";
                            
                            var note = document.createElement("h4");
                            note.innerHTML = "reset your password";
                            
                            var reset = document.createElement("button");
                            reset.innerHTML = "reset password";
                            reset.className = "btn btn-sm btn-primary verify";
                            reset.setAttribute("onclick", "resetPassword();");
                            
                            var main = document.getElementById("main");
                            var verify = document.getElementById("verify");
                            main.removeChild(code);
                            main.removeChild(verify);
                            
                            main.appendChild(note);
                            main.appendChild(document.createElement("br"));
                            main.appendChild(document.createElement("br"));
                            main.appendChild(password);
                            main.appendChild(document.createElement("br"));
                            main.appendChild(document.createElement("br"));
                            main.appendChild(confirm);
                            main.appendChild(document.createElement("br"));
                            main.appendChild(document.createElement("br"));
                            main.appendChild(reset);
                            
                        } else if ("verified@0") {
                            var note = document.getElementById("note");
                            note.innerHTML = null;
                            
                            var alert = document.createElement("label");
                            alert.className = "alrt";
                            alert.style.cssText = "width:300px;";
                            alert.innerHTML = "this verification code is not valid";
                            note.appendChild(document.createElement("br"));
                            note.appendChild(document.createElement("br"));
                            note.appendChild(alert);
                        }
                    }
                    
                };
                request.open("POST", "PasswordReset", true);
                request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                request.send("type=verify" + "&code=" + code.value);
            }
            
            
            
            function resetPassword() {
                
                var password = document.getElementById("password").value;
                var confirm = document.getElementById("confirm").value;
                
                var request = new XMLHttpRequest();
                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        if (request.responseText === "reset@1") {
                            alert("password reseted");
                            window.location = "login.jsp";
                        }
                    }
                };
                request.open("POST", "PasswordReset", true);
                request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                request.send("password=" + password + "&confirm=" + confirm + "&type=reset" + "&code=" + resetCode);
            }
        </script>
    </body>
</html>
