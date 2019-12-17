/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import pojos.LooseStock;
import pojos.PacketStock;

/**
 *
 * @author nipun
 */
public class LooseSessionCart {

    // loose stock
    private LooseStock looseStock;
    private double looseStockQty;

    public LooseStock getLooseStock() {
        return looseStock;
    }

    public double getLooseStockQty() {
        return looseStockQty;
    }

    public void setLooseStock(LooseStock looseStock) {
        this.looseStock = looseStock;
    }

    public void setLooseStockQty(double looseStockQty) {
        this.looseStockQty = looseStockQty;
    }
    
    
}