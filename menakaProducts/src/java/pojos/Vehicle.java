package pojos;
// Generated Dec 16, 2019 2:20:15 AM by Hibernate Tools 4.3.1



/**
 * Vehicle generated by hbm2java
 */
public class Vehicle  implements java.io.Serializable {


     private int idvehicle;
     private User user;
     private Vehicletype vehicletype;
     private String number;
     private String status;
     private String color;

    public Vehicle() {
    }

	
    public Vehicle(int idvehicle, User user, Vehicletype vehicletype) {
        this.idvehicle = idvehicle;
        this.user = user;
        this.vehicletype = vehicletype;
    }
    public Vehicle(int idvehicle, User user, Vehicletype vehicletype, String number, String status, String color) {
       this.idvehicle = idvehicle;
       this.user = user;
       this.vehicletype = vehicletype;
       this.number = number;
       this.status = status;
       this.color = color;
    }
   
    public int getIdvehicle() {
        return this.idvehicle;
    }
    
    public void setIdvehicle(int idvehicle) {
        this.idvehicle = idvehicle;
    }
    public User getUser() {
        return this.user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    public Vehicletype getVehicletype() {
        return this.vehicletype;
    }
    
    public void setVehicletype(Vehicletype vehicletype) {
        this.vehicletype = vehicletype;
    }
    public String getNumber() {
        return this.number;
    }
    
    public void setNumber(String number) {
        this.number = number;
    }
    public String getStatus() {
        return this.status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    public String getColor() {
        return this.color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }




}


