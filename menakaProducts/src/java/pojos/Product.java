package pojos;
// Generated Dec 16, 2019 2:20:15 AM by Hibernate Tools 4.3.1


import java.util.HashSet;
import java.util.Set;

/**
 * Product generated by hbm2java
 */
public class Product  implements java.io.Serializable {


     private Integer idproduct;
     private String productname;
     private String img;
     private String status;
     private String type;
     private Set<PackagesHasProduct> packagesHasProducts = new HashSet<PackagesHasProduct>(0);
     private Set<Supplier> suppliers = new HashSet<Supplier>(0);
     private Set<LooseStock> looseStocks = new HashSet<LooseStock>(0);

    public Product() {
    }

	
    public Product(String productname) {
        this.productname = productname;
    }
    public Product(String productname, String img, String status, String type, Set<PackagesHasProduct> packagesHasProducts, Set<Supplier> suppliers, Set<LooseStock> looseStocks) {
       this.productname = productname;
       this.img = img;
       this.status = status;
       this.type = type;
       this.packagesHasProducts = packagesHasProducts;
       this.suppliers = suppliers;
       this.looseStocks = looseStocks;
    }
   
    public Integer getIdproduct() {
        return this.idproduct;
    }
    
    public void setIdproduct(Integer idproduct) {
        this.idproduct = idproduct;
    }
    public String getProductname() {
        return this.productname;
    }
    
    public void setProductname(String productname) {
        this.productname = productname;
    }
    public String getImg() {
        return this.img;
    }
    
    public void setImg(String img) {
        this.img = img;
    }
    public String getStatus() {
        return this.status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    public String getType() {
        return this.type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    public Set<PackagesHasProduct> getPackagesHasProducts() {
        return this.packagesHasProducts;
    }
    
    public void setPackagesHasProducts(Set<PackagesHasProduct> packagesHasProducts) {
        this.packagesHasProducts = packagesHasProducts;
    }
    public Set<Supplier> getSuppliers() {
        return this.suppliers;
    }
    
    public void setSuppliers(Set<Supplier> suppliers) {
        this.suppliers = suppliers;
    }
    public Set<LooseStock> getLooseStocks() {
        return this.looseStocks;
    }
    
    public void setLooseStocks(Set<LooseStock> looseStocks) {
        this.looseStocks = looseStocks;
    }




}


