/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import pojos.Cart;
import pojos.CartHasItem;
import pojos.CartHasPackages;
import pojos.CartHasPackets;
import pojos.User;

/**
 *
 * @author nipun
 */
public class GetDBTotal {
    
    public double getTotal(User user) {

        double total = 0;

        Session s = NewHibernateUtil.getSessionFactory().openSession();

        Cart cart = (Cart) s.createCriteria(Cart.class).add(Restrictions.eq("user", user)).uniqueResult();
         
        List<CartHasItem> itemlist = s.createCriteria(CartHasItem.class)
                .add(Restrictions.eq("cart", cart))
                .add(Restrictions.eq("status", "pending")).list();
        List<CartHasPackets> packetlist = s.createCriteria(CartHasPackets.class)
                .add(Restrictions.eq("cart", cart))
                .add(Restrictions.eq("status", "pending")).list();
        List<CartHasPackages> packagelist = s.createCriteria(CartHasPackages.class)
                .add(Restrictions.eq("cart", cart))
                .add(Restrictions.eq("status", "pending")).list();

        if (!itemlist.isEmpty()) {
            double looseTotal = 0;
            for (CartHasItem cartHasItem : itemlist) {
                looseTotal += cartHasItem.getQty() * cartHasItem.getLooseStock().getUprice();
            }
            total += looseTotal;
            System.out.println("loose items total :" + looseTotal);

        }
        if (!packetlist.isEmpty()) {
            double packetTotal = 0;
            for (CartHasPackets cartHasPacket : packetlist) {
                packetTotal += cartHasPacket.getQty() * cartHasPacket.getPacketStock().getPrice();
            }
            total += packetTotal;
            System.out.println("packet items total :" + packetTotal);

        }
        if (!packagelist.isEmpty()) {
            double pkgTotal = 0;
            for (CartHasPackages cartHasPackage : packagelist) {
                pkgTotal += cartHasPackage.getQty() * cartHasPackage.getPackages().getPrice();
            }
            total += pkgTotal;
            System.out.println("package items total :" + pkgTotal);

        }

        System.out.println("full total :" + total);

        return total;
    }
}
