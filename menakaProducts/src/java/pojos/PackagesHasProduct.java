package pojos;
// Generated Dec 16, 2019 2:20:15 AM by Hibernate Tools 4.3.1



/**
 * PackagesHasProduct generated by hbm2java
 */
public class PackagesHasProduct  implements java.io.Serializable {


     private Integer id;
     private Packages packages;
     private Product product;
     private Double qty;

    public PackagesHasProduct() {
    }

	
    public PackagesHasProduct(Packages packages, Product product) {
        this.packages = packages;
        this.product = product;
    }
    public PackagesHasProduct(Packages packages, Product product, Double qty) {
       this.packages = packages;
       this.product = product;
       this.qty = qty;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public Packages getPackages() {
        return this.packages;
    }
    
    public void setPackages(Packages packages) {
        this.packages = packages;
    }
    public Product getProduct() {
        return this.product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
    }
    public Double getQty() {
        return this.qty;
    }
    
    public void setQty(Double qty) {
        this.qty = qty;
    }




}

