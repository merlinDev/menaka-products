/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import com.twocheckout.Twocheckout;
import com.twocheckout.TwocheckoutCharge;
import com.twocheckout.model.Authorization;
import connection.NewHibernateUtil;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import pojos.Cart;
import pojos.CartHasItem;
import pojos.CartHasPackages;
import pojos.CartHasPackets;
import pojos.DiscountCodes;
import pojos.Invoice;
import pojos.InvoiceHasCartHasPackets;
import pojos.InvoiceHasCartItem;
import pojos.InvoiceHasCartPackages;
import pojos.Location;
import pojos.LooseStock;
import pojos.PacketStock;
import pojos.User;

/**
 *
 * @author nipun
 */
@WebServlet(name = "PaymentCheck", urlPatterns = {"/PaymentCheck"})
public class PaymentCheck extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {

            if (req.getSession().getAttribute("paymentData") != null) {

                JSONObject paymentData = (JSONObject) req.getSession().getAttribute("paymentData");

                User user = (User) paymentData.get("user");
                Location location = (Location) paymentData.get("location");

                double totalLKR = (double) paymentData.get("total");
                double subTotal = totalLKR;
                double voucher = 0;

                voucher = (double) paymentData.get("voucher");

                totalLKR = totalLKR - voucher; // total - voucher (if voucher code valids)
                if (totalLKR < 0) {
                    totalLKR = 0;
                }

                System.out.println("total after voucher code : " + totalLKR);
                double deliveryCharge = (double) paymentData.get("deliverycharge");

                totalLKR += deliveryCharge;

                System.out.println("plus delivery charge" + totalLKR);

                URL url = new URL("https://v3.exchangerate-api.com/bulk/fd0d3921f31091d4cc3b5868/LKR");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();

                connection.connect();
                JSONObject parse = (JSONObject) new JSONParser().parse(new InputStreamReader((InputStream) connection.getContent()));
                JSONObject rates = (JSONObject) parse.get("rates");
                System.out.println("rates : " + rates);

                double toUSD = (double) rates.get("USD");
                System.out.println("USD :" + toUSD);

                double totalUSD = totalLKR * toUSD;
                DecimalFormat decimalFormat = new DecimalFormat("#.##");

                double total = Double.parseDouble(decimalFormat.format(totalUSD));
                System.out.println("total : " + total);

                String token = req.getParameter("token");
                Twocheckout.privatekey = "169E5D0E-D290-4148-BFE3-20D2B7934276";
                Twocheckout.mode = "sandbox";

                System.out.println("sendind data,");
                System.out.println("------------------------");
                System.out.println("user :" + user.getName());
                System.out.println("email :" + user.getEmail());
                System.out.println("tel :" + location.getTel());
                System.out.println("address :" + location.getAddress());
                System.out.println("zip :" + location.getZip().getZipcode());
                System.out.println("total :" + total);
                System.out.println("delivery charge :" + deliveryCharge);
                System.out.println("------------------------");

                HashMap billing = new HashMap();
                billing.put("name", user.getName());
                billing.put("addrLine1", location.getAddress());
                billing.put("city", "Colombo");
                billing.put("state", "Colombo");
                billing.put("country", "Sri Lanka");
                billing.put("zipCode", location.getZip().getZipcode());
                billing.put("email", user.getEmail());
                billing.put("phoneNumber", location.getTel());

                HashMap request = new HashMap();
                request.put("sellerId", "901384140");
                request.put("merchantOrderId", "test123");
                request.put("token", token);
                request.put("currency", "USD");
                request.put("total", total);
                request.put("billingAddr", billing);
                Authorization response = TwocheckoutCharge.authorize(request);

                String message = response.getResponseMsg();
                System.out.println("code : " + response.getResponseCode());
                System.out.println(message);

                if (response.getResponseCode().equals("APPROVED")) {

                    // payment done 
                    //invalidating the paymentData session
                    req.getSession().setAttribute("paymentData", null);
                    // updating the stock,
                    // issuing the invoice
                    Session s = NewHibernateUtil.getSessionFactory().openSession();

                    // saving pre invoice
                    Invoice invoice = new Invoice();

                    invoice.setDate(new Date());
                    invoice.setLocation(location);
                    invoice.setSubTotal(subTotal);
                    invoice.setUser(user);
                    invoice.setNetTotal(totalLKR);
                    invoice.setDiscount(voucher);
                    invoice.setStatus("paid");

                    s.save(invoice);
                    s.beginTransaction().commit();

                    Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();

                    List<CartHasItem> cartItem_list = s.createCriteria(CartHasItem.class)
                            .add(Restrictions.eq("cart", cart))
                            .add(Restrictions.eq("status", "pending")).list();

                    if (!cartItem_list.isEmpty()) {

                        // cartitems
                        for (CartHasItem cartItem : cartItem_list) {

                            InvoiceHasCartItem invoiceItem = new InvoiceHasCartItem();
                            invoiceItem.setInvoice(invoice);
                            invoiceItem.setCartHasItem(cartItem);
                            invoiceItem.setQty(cartItem.getQty());
                            invoiceItem.setPrice(cartItem.getQty() * cartItem.getLooseStock().getUprice());

                            LooseStock looseStock = cartItem.getLooseStock();

                            // updating stock qty
                            looseStock.setQty(looseStock.getQty() - cartItem.getQty());

                            // setting item status to paid
                            cartItem.setStatus("paid");
                            cartItem.setDate(new Date());
                            s.update(cartItem);

                            if (looseStock.getQty() <= 0) {

                                // if stock qty 0
                                looseStock.setStatus("na");
                            }

                            s.save(invoiceItem);

                            s.update(looseStock);
                            s.beginTransaction().commit();
                        }
                    }

                    List<CartHasPackets> cartPkt_list = s.createCriteria(CartHasPackets.class)
                            .add(Restrictions.eq("cart", cart))
                            .add(Restrictions.eq("status", "pending")).list();

                    if (!cartPkt_list.isEmpty()) {

                        for (CartHasPackets cartPacket : cartPkt_list) {

                            InvoiceHasCartHasPackets invoicePkt = new InvoiceHasCartHasPackets();
                            invoicePkt.setCartHasPackets(cartPacket);
                            invoicePkt.setInvoice(invoice);
                            invoicePkt.setQty(cartPacket.getQty());
                            invoicePkt.setPrice(cartPacket.getQty() * cartPacket.getPacketStock().getPrice());

                            PacketStock packetStock = cartPacket.getPacketStock();

                            // updating pkt stock qty
                            packetStock.setQty(packetStock.getQty() - cartPacket.getQty());

                            // setting pkt status to paid
                            cartPacket.setStatus("paid");

                            if (packetStock.getQty() <= 0) {
                                packetStock.setStatus("na");
                            }
                            s.save(invoicePkt);
                            s.update(packetStock);

                            s.beginTransaction().commit();
                        }

                    }

                    List<CartHasPackages> cartPkg_list = s.createCriteria(CartHasPackages.class)
                            .add(Restrictions.eq("cart", cart))
                            .add(Restrictions.eq("status", "pending")).list();

                    if (!cartPkg_list.isEmpty()) {

                        for (CartHasPackages cartPackage : cartPkg_list) {

                            InvoiceHasCartPackages invoicePkg = new InvoiceHasCartPackages();
                            invoicePkg.setCartHasPackages(cartPackage);
                            invoicePkg.setInvoice(invoice);
                            invoicePkg.setQty(cartPackage.getQty());
                            invoicePkg.setPrice(cartPackage.getQty() * cartPackage.getPackages().getPrice());

                            // setting pkg status to paid
                            cartPackage.setStatus("paid");

                            s.save(invoicePkg);
                            s.update(cartPackage);
                            s.beginTransaction().commit();
                        }

                    }

                    List<DiscountCodes> list = s.createCriteria(DiscountCodes.class).
                            add(Restrictions.eq("user", user)).list();

                    if (!list.isEmpty()) {
                        DiscountCodes code = list.get(0);
                        code.setStatus("na");
                        s.update(code);
                        s.beginTransaction().commit();
                        System.out.println("voucher code removed");
                    }

                    s.flush();
                    s.close();

                    servlet.Logger.doLog(user.getEmail(), "purchased items, invoice #" + invoice.getIdinvoice());
                    resp.sendRedirect("paymentdone.jsp?inv-id=" + invoice.getIdinvoice());
                }

            } else { // payment session timeout
                System.out.println("payment session timeout");
                resp.sendRedirect("viewCart.jsp");
            }

        } catch (NullPointerException e) {
            e.printStackTrace();
            System.out.println("error in paymentData sessoion");
            // error in paymentData sessoion
            resp.sendRedirect("viewCart.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            String message = e.toString();
            System.out.println(message);
            resp.sendRedirect("carderror.html");
        }
    }

}
