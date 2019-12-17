/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import pojos.PacketStock;

/**
 *
 * @author nipun
 */
public class PacketSessionCart {

    private PacketStock packetStock;
    private double packetPrice;
    private int packetQty;

    public PacketStock getPacketStock() {
        return packetStock;
    }

    public double getPacketPrice() {
        return packetPrice;
    }

    public int getPacketQty() {
        return packetQty;
    }

    public void setPacketStock(PacketStock packetStock) {
        this.packetStock = packetStock;
    }

    public void setPacketPrice(double packetPrice) {
        this.packetPrice = packetPrice;
    }

    public void setPacketQty(int packetQty) {
        this.packetQty = packetQty;
    }
    
}
