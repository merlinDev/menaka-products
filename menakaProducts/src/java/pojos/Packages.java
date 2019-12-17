package pojos;
// Generated Dec 16, 2019 2:20:15 AM by Hibernate Tools 4.3.1


import java.util.HashSet;
import java.util.Set;

/**
 * Packages generated by hbm2java
 */
public class Packages  implements java.io.Serializable {


     private Integer idpackages;
     private Category category;
     private String packageName;
     private String packageImage;
     private String status;
     private String description;
     private Double price;
     private Set<PackagesHasProduct> packagesHasProducts = new HashSet<PackagesHasProduct>(0);
     private Set<PackageReview> packageReviews = new HashSet<PackageReview>(0);
     private Set<CartHasPackages> cartHasPackageses = new HashSet<CartHasPackages>(0);

    public Packages() {
    }

	
    public Packages(Category category) {
        this.category = category;
    }
    public Packages(Category category, String packageName, String packageImage, String status, String description, Double price, Set<PackagesHasProduct> packagesHasProducts, Set<PackageReview> packageReviews, Set<CartHasPackages> cartHasPackageses) {
       this.category = category;
       this.packageName = packageName;
       this.packageImage = packageImage;
       this.status = status;
       this.description = description;
       this.price = price;
       this.packagesHasProducts = packagesHasProducts;
       this.packageReviews = packageReviews;
       this.cartHasPackageses = cartHasPackageses;
    }
   
    public Integer getIdpackages() {
        return this.idpackages;
    }
    
    public void setIdpackages(Integer idpackages) {
        this.idpackages = idpackages;
    }
    public Category getCategory() {
        return this.category;
    }
    
    public void setCategory(Category category) {
        this.category = category;
    }
    public String getPackageName() {
        return this.packageName;
    }
    
    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }
    public String getPackageImage() {
        return this.packageImage;
    }
    
    public void setPackageImage(String packageImage) {
        this.packageImage = packageImage;
    }
    public String getStatus() {
        return this.status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    public String getDescription() {
        return this.description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    public Double getPrice() {
        return this.price;
    }
    
    public void setPrice(Double price) {
        this.price = price;
    }
    public Set<PackagesHasProduct> getPackagesHasProducts() {
        return this.packagesHasProducts;
    }
    
    public void setPackagesHasProducts(Set<PackagesHasProduct> packagesHasProducts) {
        this.packagesHasProducts = packagesHasProducts;
    }
    public Set<PackageReview> getPackageReviews() {
        return this.packageReviews;
    }
    
    public void setPackageReviews(Set<PackageReview> packageReviews) {
        this.packageReviews = packageReviews;
    }
    public Set<CartHasPackages> getCartHasPackageses() {
        return this.cartHasPackageses;
    }
    
    public void setCartHasPackageses(Set<CartHasPackages> cartHasPackageses) {
        this.cartHasPackageses = cartHasPackageses;
    }




}

