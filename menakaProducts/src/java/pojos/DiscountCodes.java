package pojos;
// Generated Dec 16, 2019 2:20:15 AM by Hibernate Tools 4.3.1


import java.util.Date;

/**
 * DiscountCodes generated by hbm2java
 */
public class DiscountCodes  implements java.io.Serializable {


     private Integer id;
     private User user;
     private String message;
     private Date expDate;
     private String code;
     private Double value;
     private String status;

    public DiscountCodes() {
    }

	
    public DiscountCodes(User user) {
        this.user = user;
    }
    public DiscountCodes(User user, String message, Date expDate, String code, Double value, String status) {
       this.user = user;
       this.message = message;
       this.expDate = expDate;
       this.code = code;
       this.value = value;
       this.status = status;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public User getUser() {
        return this.user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    public String getMessage() {
        return this.message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    public Date getExpDate() {
        return this.expDate;
    }
    
    public void setExpDate(Date expDate) {
        this.expDate = expDate;
    }
    public String getCode() {
        return this.code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    public Double getValue() {
        return this.value;
    }
    
    public void setValue(Double value) {
        this.value = value;
    }
    public String getStatus() {
        return this.status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }




}


