<%@page import="pojos.User"%>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style/css/bootstrap.min.css">
    <link rel="stylesheet" href="nav/fonts/typicons.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Bubbler+One">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/simple-line-icons/2.4.1/css/simple-line-icons.css">
    <link rel="stylesheet" href="nav/css/styles.css">
    <link rel="stylesheet" href="SnackBar/snackbar.min.css">
</head>
<nav class="navbar navv navbar-light navbar-expand-md sticky-top shadow" style="background-color:#ffffff;font-family:'Bubbler One', sans-serif;">
    <div class="container-fluid"><a class="navbar-brand" href="index.jsp" style="color:#000000;font-family:'Bubbler One', sans-serif;"><img class="logo" src="img/menaka-logo.png">menaka products</a><button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1"><span class="sr-only">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navcol-1">
            <ul class="nav navbar-nav mx-auto">
                <li class="nav-item" role="presentation"><a class="nav-link active" href="products.jsp" style="color:#000000;font-weight:normal;">spices</a></li>
                <li class="nav-item" role="presentation"><a class="nav-link" href="packets.jsp" style="color:#000000;">spices packets</a></li>
                    <%

                        if (request.getSession().getAttribute("user") != null) {
                            User user = (User) request.getSession().getAttribute("user");
                            if (user.getUsertype().getIdusertype() == 2) { // local user
                    %><li class="nav-item" role="presentation"><a class="nav-link" href="packages.jsp" style="color:#000000;">spices packages</a></li><%
                            }
                        }
                    %>
            </ul>
            <ul class="nav navbar-nav" style="margin-right:53px;">
                <% if (request.getSession().getAttribute("user") != null) {
                        User user = (User) request.getSession().getAttribute("user");
                %>
                <li class="nav-item" role="presentation"><a class="nav-link active" href="userAccount.jsp" style="color:#000000;"><i class="icon-user"><small style="font-family: 'Bubbler One', sans-serif;"><%=user.getName()%></small></i></a></li>
                <li class="nav-item" role="presentation"><a class="nav-link active" href="Logout" style="color:#000000;"><small>logout</small></a></li>

                <%
                } else {
                %>
                <li class="nav-item" role="presentation"><a class="nav-link active" href="login.jsp" style="color:#000000;">login</a></li>
                <li class="nav-item" role="presentation"><a class="nav-link" href="userRegister.jsp" style="color:#000000;">register</a></li>
                    <%
                        }%>

            </ul>
            <ul class="nav navbar-nav">
                <li class="nav-item" role="presentation"><a class="nav-link active" href="viewCart.jsp" style="color:#000000;"><i class="typcn typcn-shopping-cart" style="font-size:24px;"></i></a></li>
            </ul>
        </div>
    </div>
</nav>
<script src="nav/js/jquery.min.js"></script>
<script src="style/js/bootstrap.min.js"></script>
<script src="SnackBar/snackbar.min.js"></script>
<script src="assets/js/show-alert.js"></script>

</html>