<%@page import="servlet.LooseSessionCart"%>
<%@page import="servlet.PacketSessionCart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="pojos.CartHasPackages"%>
<%@page import="pojos.CartHasPackets"%>
<%@page import="pojos.CartHasItem"%>
<%@page import="pojos.Cart"%>
<%@page import="pojos.User"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Packages"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<!doctype html>
<html lang="en" class="no-js">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link href='http://fonts.googleapis.com/css?family=PT+Sans:400,700' rel='stylesheet' type='text/css'>
        <link rel="stylesheet" href="style/css/bootstrap.min.css">
        <link rel="stylesheet" href="modal/remodal.css">
        <link rel="stylesheet" href="modal/remodal-default-theme.css">
        <link rel="stylesheet" href="style/cart.css">
        <link rel="stylesheet" href="nav/fonts/typicons.min.css">
        <link rel="stylesheet" href="SnackBar/snackbar.min.css">
        <title>cart  View</title>

    </head>
    <body onload="showTotal();">
        <%@include file="nav.jsp" %>
        <% request.getSession().setAttribute("page", "viewCart.jsp");%>
        <br>

        <%if (request.getSession().getAttribute("user") == null) {
        %><div id="note" style="background-color: #e0a800;padding: 30px;color: white"> you're not logged in, please login before proceed to checkout. </div><%
            }
        %>
        <br>

        <div class="container">
            <div class="row main">


                <!-- cart items -->
                <div class="col-md-8">
                    <div class="row">


                        <%
                            boolean cartEmpty = true;

                            if (request.getSession().getAttribute("user") != null) {
                                User user = (User) request.getSession().getAttribute("user");
                                Session s = NewHibernateUtil.getSessionFactory().openSession();
                                Cart cart = (Cart) s.createCriteria(Cart.class)
                                        .add(Restrictions.eq("user", user)).uniqueResult();

                                List<CartHasItem> cartItem_list = s.createCriteria(CartHasItem.class)
                                        .add(Restrictions.eq("cart", cart))
                                        .add(Restrictions.eq("status", "pending")).list();

                                List<CartHasPackets> cartPkt_list = s.createCriteria(CartHasPackets.class)
                                        .add(Restrictions.eq("cart", cart))
                                        .add(Restrictions.eq("status", "pending")).list();

                                List<CartHasPackages> cartPkg_list = s.createCriteria(CartHasPackages.class)
                                        .add(Restrictions.eq("cart", cart))
                                        .add(Restrictions.eq("status", "pending")).list();

                                // check for unavilable stocks
                                for (CartHasItem elem : cartItem_list) {
                                    if (!elem.getLooseStock().getStatus().equals("available") || !elem.getLooseStock().getProduct().getStatus().equals("available")) {
                                        s.delete(elem);
                                        s.beginTransaction().commit();
                                        s.flush();
                                        System.out.println("removed unavailable items");
                                    }
                                }

                                for (CartHasPackets elem : cartPkt_list) {
                                    if (!elem.getPacketStock().getStatus().equals("available") || !elem.getPacketStock().getPacket().getStatus().equals("available")) {
                                        s.delete(elem);
                                        s.beginTransaction().commit();
                                        s.flush();

                                        System.out.println("removed unavailable packet");
                                    } else {
                                        System.out.println("stock available $$$$$$$$$$$$$$$");
                                    }
                                }

                                for (CartHasPackages elem : cartPkg_list) {
                                    if (!elem.getPackages().getStatus().equals("available")) {
                                        s.delete(elem);
                                        s.beginTransaction().commit();
                                        s.flush();

                                        System.out.println("removed unavailable package");
                                    }
                                }

                                s.flush();

                                // rearanging only the available items
                                cartItem_list = s.createCriteria(CartHasItem.class)
                                        .add(Restrictions.eq("cart", cart))
                                        .add(Restrictions.eq("status", "pending")).list();

                                cartPkt_list = s.createCriteria(CartHasPackets.class)
                                        .add(Restrictions.eq("cart", cart))
                                        .add(Restrictions.eq("status", "pending")).list();

                                cartPkg_list = s.createCriteria(CartHasPackages.class)
                                        .add(Restrictions.eq("cart", cart))
                                        .add(Restrictions.eq("status", "pending")).list();

                                // check if the cart is empty
                                if (cartItem_list.size() + cartPkt_list.size() + cartPkg_list.size() == 0) {
                                    cartEmpty = true;
                                }

                                for (CartHasItem elem : cartItem_list) {
                                    cartEmpty = false;
                        %>

                        <div class="row cart-item">

                            <div class="col-md-3">
                                <div class="item-img" style="background-image: url('<%=elem.getLooseStock().getProduct().getImg().replace("\\", "/")%>');"></div>
                            </div>

                            <div class="col-md-4">
                                <div class="name"><span class="product"><%=elem.getLooseStock().getProduct().getProductname()%></span><br> <small class="type">(loose item)</small></div>
                                <div class="price"><label> unit price : Rs. <%=elem.getLooseStock().getUprice()%></label> </div>
                            </div>

                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col">
                                        <div class="qty"> qty : <input  id="looseQTY_<%=elem.getIdCartItem()%>" value="<%=elem.getQty()%>"> <small>kg</small>
                                            <button class="btn btn-sm btn-primary" onclick="updateQty(<%=elem.getIdCartItem()%>, 'loose item')">update</button>
                                        </div>

                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="total">
                                            <span>Total : Rs. <%=elem.getQty() * elem.getLooseStock().getUprice()%></span>
                                            <span class="del" onclick="remove(<%=elem.getIdCartItem()%>, 'loose item')"><i class="typcn typcn-trash"></i></span>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>



                        <%
                            }

                            for (CartHasPackets elem : cartPkt_list) {
                                cartEmpty = false;
                        %>

                        <div class="row cart-item">

                            <div class="col-md-3">
                                <div class="item-img" style="background-image: url('<%=elem.getPacketStock().getPacket().getImg().replace("\\", "/")%>');"></div>
                            </div>

                            <div class="col-md-4">
                                <div class="name"><span class="product"><%=elem.getPacketStock().getPacket().getName()%></span><br> <small class="type">(packet item)</small></div>
                                <div class="price">
                                    <label> unit price : Rs. <%=elem.getPacketStock().getPrice()%></label><br>
                                    <small> exp : <%=elem.getPacketStock().getExp()%></small><br>
                                    <small> man : <%=elem.getPacketStock().getMan()%></small>
                                </div>
                            </div>

                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col">
                                        <div class="qty"> qty : <input id="packetQTY_<%=elem.getId()%>" value="<%=elem.getQty()%>">
                                            <button class="btn btn-sm btn-primary" onclick="updateQty(<%=elem.getId()%>, 'spicy packet')">update</button>
                                        </div>

                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="total">
                                            <span>Total : Rs. <%=elem.getQty() * elem.getPacketStock().getPrice()%></span>
                                            <span class="del" onclick="remove(<%=elem.getId()%>, 'spicy packet')"><i class="typcn typcn-trash"></i></span>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <%
                            }

                            for (CartHasPackages elem : cartPkg_list) {
                                cartEmpty = false;
                        %>

                        <div class="row cart-item">

                            <div class="col-md-3">
                                <div class="item-img" style="background-image: url('<%=elem.getPackages().getPackageImage().replace("\\", "/")%>');"></div>
                            </div>

                            <div class="col-md-4">
                                <div class="name"><span class="product"><%=elem.getPackages().getPackageName()%></span><br> <small class="type">(package item)</small></div>
                                <div class="price"><label> unit price : Rs. <%=elem.getPackages().getPrice()%></label> </div>
                            </div>

                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col">
                                        <div class="qty"> qty : <input id="packageQTY_<%=elem.getId()%>" value="<%=elem.getQty()%>">
                                            <button class="btn btn-sm btn-primary" onclick="updateQty(<%=elem.getId()%>, 'package')">update</button>
                                        </div>

                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="total">
                                            <span>Total : Rs. <%=elem.getQty() * elem.getPackages().getPrice()%></span>
                                            <span class="del" onclick="remove(<%=elem.getId()%>, 'package')"><i class="typcn typcn-trash"></i></span>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <%
                            }

                        } else {

                            // session cart
                            cartEmpty = true;

                            if (request.getSession().getAttribute("looseCart") != null) {
                                cartEmpty = false;
                                ArrayList<LooseSessionCart> loose_list = (ArrayList<LooseSessionCart>) request.getSession().getAttribute("looseCart");
                                for (LooseSessionCart elem : loose_list) {
                        %>

                        <div class="row cart-item">

                            <div class="col-md-3">
                                <div class="item-img"  style="background-image: url('<%=elem.getLooseStock().getProduct().getImg().replace("\\", "/")%>');"></div>
                            </div>

                            <div class="col-md-4">
                                <div class="name"><span class="product"><%=elem.getLooseStock().getProduct().getProductname()%></span><br> <small class="type">(loose item)</small></div>
                                <div class="price"><label> unit price : Rs. <%=elem.getLooseStock().getUprice()%></label> </div>
                            </div>

                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col">
                                        <div class="qty"> qty : <input id="looseQTY_<%=elem.getLooseStock().getIditem()%>" value="<%=elem.getLooseStockQty()%>"> <small>kg</small>
                                            <button class="btn btn-sm btn-primary" onclick="updateQty(<%=elem.getLooseStock().getIditem()%>, 'loose item')">update</button>
                                        </div>

                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="total">
                                            <span>Total : Rs. <%=elem.getLooseStockQty() * elem.getLooseStock().getUprice()%></span>
                                            <span class="del" onclick="remove(<%=elem.getLooseStock().getIditem()%>, 'loose item')"><i class="typcn typcn-trash"></i></span>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>


                        <%
                                }
                            }

                            if (request.getSession().getAttribute("packetCart") != null) {
                                cartEmpty = false;
                                ArrayList<PacketSessionCart> pkt_list = (ArrayList<PacketSessionCart>) request.getSession().getAttribute("packetCart");
                                for (PacketSessionCart elem : pkt_list) {
                        %>

                        <div class="row cart-item">

                            <div class="col-md-3">
                                <div class="item-img" style="background-image: url('<%=elem.getPacketStock().getPacket().getImg().replace("\\", "/")%>');"></div>
                            </div>

                            <div class="col-md-4">
                                <div class="name"><span class="product"><%=elem.getPacketStock().getPacket().getName()%></span><br> <small class="type">(packet item)</small></div>
                                <div class="price"><label> unit price : Rs. <%=elem.getPacketStock().getPrice()%></label> </div>
                            </div>

                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col">
                                        <div class="qty"> qty : <input id="packetQTY_<%=elem.getPacketStock().getId()%>" value="<%=elem.getPacketQty()%>">
                                            <button class="btn btn-sm btn-primary" onclick="updateQty(<%=elem.getPacketStock().getId()%>, 'spicy packet')">update</button>
                                        </div>

                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="total">
                                            <span>Total : Rs. <%=elem.getPacketQty() * elem.getPacketStock().getPrice()%></span>
                                            <span class="del" onclick="remove(<%=elem.getPacketStock().getId()%>, 'spicy packet')"><i class="typcn typcn-trash"></i></span>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>


                        <%
                                    }
                                }
                            }

                        %>

                    </div>
                </div>

                <!-- summery -->
                <%                    if (!cartEmpty) {
                %>

                <div class="col-md-4">
                    <div class="sum">
                        <label class="tot"><label>total :</label> <label id="total"></label></label><br>
                        <input placeholder="voucher code" id="voucher"><br>
                        <%if (request.getSession().getAttribute("user") != null) {
                        %><button class="btn btn-primary" onclick="window.location = 'checkout.jsp?voucher=' + document.getElementById('voucher').value;">proceed to checkout</button><%
                            if (request.getSession().getAttribute("limitNote") != null) {
                        %><br><label class="limitNote"><%=request.getSession().getAttribute("limitNote")%></label><%
                                request.getSession().setAttribute("limitNote", null);
                            }

                        } else {
                        %><button class="btn btn-primary" onclick="window.location = 'login.jsp';">login before checkout</button><%
                            }
                            %>
                    </div>
                </div>

                <%
                    }
                %>

            </div>
            <%
                if (cartEmpty) {
            %>

            <div class="row">
                <div class="col">
                    <div class="empty-cart">
                        <center>
                            <h3> your cart is empty </h3>
                            <a href="packets.jsp" class="btn btn-sm btn-secondary"> browse products </a>
                        </center>
                    </div>
                </div>
            </div>


            <%
                }

            %>
        </div>



        <script type="text/javascript">

            function getCart() {
                var cartEmpty = <%=cartEmpty%>;

                if (cartEmpty) {
                    var div = document.getElementById("main");
                    div.innerHTML = null;

                    var cont = document.createElement("div");
                    cont.className = "emptyCart";

                    var lab = document.createElement("label");
                    lab.innerHTML = "your cart is empty.";
                    lab.style.cssText = "margin-top: 160px;font-size:24px;";

                    var button = document.createElement("button");
                    button.className = "btn btn-sm btn-primary";
                    button.innerHTML = "shop now";
                    button.onclick = function () {
                        window.location = "products.jsp";
                    };

                    cont.appendChild(lab);
                    cont.appendChild(document.createElement("br"));
                    cont.appendChild(button);

                    div.appendChild(cont);

                }
            }

        </script>
        <script src="viewCart/js/jquery.min.js"></script>
        <script src="SnackBar/snackbar.min.js"></script>
        <script src="assets/js/show-alert.js"></script>
        <script src="assets/cart.js"></script>
    </body>

</html>