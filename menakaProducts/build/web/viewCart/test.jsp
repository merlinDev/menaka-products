<%-- 
    Document   : test
    Created on : May 31, 2018, 10:58:58 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="servlet.PacketSessionCart"%>
<%@page import="servlet.LooseSessionCart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="pojos.CartHasPackages"%>
<%@page import="pojos.CartHasPackets"%>
<%@page import="java.util.List"%>
<%@page import="pojos.Cart"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.CartHasItem"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
                                        <%if (request.getSession().getAttribute("user") != null) {
                                                Session s = NewHibernateUtil.getSessionFactory().openSession();

                                                User user = (User) request.getSession().getAttribute("user");
                                                Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();

                                                List<CartHasItem> looselist = s.createCriteria(CartHasItem.class)
                                                        .add(Restrictions.eq("cart", cart))
                                                        .add(Restrictions.eq("status", "pending")).list();

                                                for (CartHasItem item : looselist) {
                                        %><tr>
                                            <td><img src="<%=item.getLooseStock().getProduct().getImg()%>"></td>
                                            <td><%=item.getLooseStock().getProduct().getProductname()%></td>
                                            <td><%=item.getLooseStock().getUprice()%></td>
                                            <td><input type="number" value="<%=item.getQty()%>"></td>
                                            <td><button onclick="updateQty(<%=item.getIdCartItem()%>,'loose item')" class="btn btn-sm btn-warning">update</button></td>
                                            <td><%=item.getQty() * item.getLooseStock().getUprice()%></td>
                                        </tr><%
                                            }

                                            List<CartHasPackets> pktlist = s.createCriteria(CartHasPackets.class)
                                                    .add(Restrictions.eq("cart", cart))
                                                    .add(Restrictions.eq("status", "pending")).list();

                                            for (CartHasPackets item : pktlist) {
                                        %><tr>
                                            <td><img src="<%=item.getPacketStock().getPacket().getImg()%>"></td>
                                            <td><%=item.getPacketStock().getPacket().getName()%></td>
                                            <td><%=item.getPacketStock().getPrice()%></td>
                                            <td><input type="number" value="<%=item.getQty()%>"></td>
                                            <td><button onclick="updateQty(<%=item.getId()%>,'spicy packet')" class="btn btn-sm btn-warning">update</button></td>
                                            <td><%=item.getQty() * item.getPacketStock().getPrice()%></td>
                                        </tr><%
                                            }

                                            List<CartHasPackages> pkglist = s.createCriteria(CartHasPackages.class)
                                                    .add(Restrictions.eq("cart", cart))
                                                    .add(Restrictions.eq("status", "pending")).list();

                                            for (CartHasPackages item : pkglist) {
                                        %><tr>
                                            <td><img src="<%=item.getPackages().getPackageImage()%>"></td>
                                            <td><%=item.getPackages().getPackageName()%></td>
                                            <td><%=item.getPackages().getPrice()%></td>
                                            <td><input type="number" value="<%=item.getQty()%>"></td>
                                            <td><button onclick="updateQty(<%=item.getId()%>,'package')" class="btn btn-sm btn-warning">update</button></td>
                                            <td><%=item.getQty() * item.getPackages().getPrice()%></td>
                                        </tr><%
                                            }

                                        } else { // session cart

                                            if (request.getSession().getAttribute("looseCart") != null) { // loose session cart
                                                ArrayList<LooseSessionCart> looseSession = (ArrayList<LooseSessionCart>) request.getSession().getAttribute("looseCart");

                                                for (LooseSessionCart item : looseSession) {
                                        %><tr>
                                            <td><img src="<%=item.getLooseStock().getProduct().getImg()%>"></td>
                                            <td><%=item.getLooseStock().getProduct().getProductname()%></td>
                                            <td><%=item.getLooseStock().getUprice()%></td>
                                            <td><input type="number" value="<%=item.getLooseStockQty()%>"></td>
                                            <td><button onclick="updateQty(<%=item.getLooseStock().getIditem()%>,'loose item')" class="btn btn-sm btn-warning">update</button></td>
                                            <td><%=item.getLooseStockQty() * item.getLooseStock().getUprice()%></td>
                                        </tr><%
                                                }

                                            }

                                            if (request.getSession().getAttribute("packetCart") != null) {
                                                ArrayList<PacketSessionCart> pktSession = (ArrayList<PacketSessionCart>) request.getSession().getAttribute("looseCart");

                                                for (PacketSessionCart item : pktSession) {
                                        %><tr>
                                            <td><img src="<%=item.getPacketStock().getPacket().getImg()%>"></td>
                                            <td><%=item.getPacketStock().getPacket().getName()%></td>
                                            <td><%=item.getPacketStock().getPrice()%></td>
                                            <td><input type="number" value="<%=item.getPacketQty()%>"></td>
                                            
                                            <td><%=item.getPacketQty() * item.getPacketStock().getPrice()%></td>
                                        </tr><%
                                                    }
                                                }
                                            }


                                        %>





    </body>
</html>
