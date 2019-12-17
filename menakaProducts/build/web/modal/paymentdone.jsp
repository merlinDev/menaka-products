<%-- 
    Document   : paymentdone
    Created on : Jun 8, 2018, 3:23:45 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="pojos.CartHasPackages"%>
<%@page import="pojos.PacketStock"%>
<%@page import="pojos.CartHasPackets"%>
<%@page import="java.util.Date"%>
<%@page import="pojos.LooseStock"%>
<%@page import="pojos.CartHasItem"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.Session"%>
<%@page import="pojos.Cart"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/css/bootstrap.min.css">
        
        <style>
            body{
                background-color: rgba(0,0,0,0.05);
            }
            .invoice{
                margin: 0 auto;
                margin-top: 50px;
                background-color: white;
                height: 70vh;
                max-width: 700px; 
                padding: 50px;
            }
            .logo img{
                width: 180px;
            }
        </style>
        <title>invoice</title>
    </head>
    <body>


        <div class="container">
            <div class="row">
                <div class="col-md-12"> 
                    <div class="invoice">
                        <div class="logo"><img src="img/menaka-logo.png"></div>
                    </div>
                </div>
            </div>
        </div>

        <%

            // payment done 
            // updating the stock,
            // issuing the invoice
            User user = (User) request.getSession().getAttribute("user");

            Session s = NewHibernateUtil.getSessionFactory().openSession();
            Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();

            List<CartHasItem> cartItem_list = s.createCriteria(CartHasItem.class)
                    .add(Restrictions.eq("cart", cart))
                    .add(Restrictions.eq("status", "pending")).list();

            // cartitems
            for (CartHasItem cartItem : cartItem_list) {
                LooseStock looseStock = cartItem.getLooseStock();

                // updating stock qty
                looseStock.setQty(looseStock.getQty() - cartItem.getQty());

                // setting item status to closed
                cartItem.setStatus("closed");
                cartItem.setDate(new Date());
                s.update(cartItem);

                if (looseStock.getQty() <= 0) {

                    // if stock qty 0
                    looseStock.setStatus("na");
                }
                s.update(looseStock);
                s.beginTransaction().commit();
            }

            List<CartHasPackets> cartPkt_list = s.createCriteria(CartHasPackets.class)
                    .add(Restrictions.eq("cart", cart))
                    .add(Restrictions.eq("status", "pending")).list();

            for (CartHasPackets cartPacket : cartPkt_list) {
                PacketStock packetStock = cartPacket.getPacketStock();

                // updating pkt stock qty
                packetStock.setQty(packetStock.getQty() - cartPacket.getQty());

                // setting pkt status to closed
                cartPacket.setStatus("closed");

                if (packetStock.getQty() <= 0) {
                    packetStock.setStatus("na");
                }
                s.update(packetStock);
                s.beginTransaction().commit();
            }

            List<CartHasPackages> cartPkg_list = s.createCriteria(CartHasPackages.class)
                    .add(Restrictions.eq("cart", cart))
                    .add(Restrictions.eq("status", "pending")).list();

            for (CartHasPackages cartPackage : cartPkg_list) {

                // setting pkg status to closed
                cartPackage.setStatus("closed");
                s.update(cartPackage);
                s.beginTransaction().commit();
            }

            s.flush();
            s.close();

        %>

    </body>
</html>
