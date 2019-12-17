/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import connection.NewHibernateUtil;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.json.simple.parser.ParseException;
import pojos.Deliverydata;
import pojos.Location;
import pojos.User;
import pojos.Zip;

/**
 *
 * @author nipun
 */
@WebServlet(name = "location", urlPatterns = {"/location"})
public class location extends HttpServlet {
    
    
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        try {
            if (req.getSession().getAttribute("user") != null) {
                User user = (User) req.getSession().getAttribute("user");
                
                String marked = req.getParameter("marked");
                System.out.println(marked);
                String address = req.getParameter("address");
                String street = req.getParameter("street");
                String zip = req.getParameter("zip");
                String contact = req.getParameter("contact");
                System.out.println(contact);
                if (contact.contains("94")) {
                    System.out.println("+94 found");
                } else {
                    System.out.println(" no +94 found");
                }
                
                String latitude = req.getParameter("latitude");
                String longitude = req.getParameter("longitude");
                
                Session s = NewHibernateUtil.getSessionFactory().openSession();
                
                Deliverydata data = (Deliverydata) s.createCriteria(Deliverydata.class).uniqueResult();
                double distance = 0;
                
                if (marked.equals("false")) {
                    latitude = "0";
                    longitude = "0";
                    distance = -1;
                } else {
                    String origin = data.getDeliveryPoint(); // lat , long format
                    String destination = latitude + "," + longitude;
                    distance = new Distance().GetDistance(origin, destination);
                    // distance = 0 means the place is far far away
                }
                
                if (distance > data.getMinKm() || distance == 0) {
                    resp.getWriter().write("oops... sorry we only delivery under " + data.getMinKm() + " Km.");
                } else if (address.equals("")) {
                    resp.getWriter().write("address cannot be empty");
                } else if (zip.equals("")) {
                    resp.getWriter().write("zip cannot be empty");
                } else if (street.equals("")) {
                    resp.getWriter().write("street cannot be empty");
                } else if (contact.equals("")) {
                    resp.getWriter().write("contact cannot be empty");
                } else if (contact.length() < 9 || contact.length() > 10) {
                    resp.getWriter().write("enter a valid contact number");
                } else {
                    
                    Zip zipcode = (Zip) s.createCriteria(Zip.class).add(Restrictions.eq("zipcode", zip)).uniqueResult();
                    
                    List list = s.createCriteria(Location.class)
                            .add(Restrictions.eq("user", user))
                            .add(Restrictions.eq("address", address))
                            .add(Restrictions.eq("street", street))
                            .add(Restrictions.eq("zip", zipcode)).list();
                    
                    int listCount = s.createCriteria(Location.class)
                            .add(Restrictions.eq("user", user)).list().size();
                    
                    if (listCount < 4) {
                        if (list.isEmpty()) {
                            Location location = new Location();
                            
                            location.setUser(user);
                            location.setAddress(address);
                            location.setStreet(street);
                            
                            location.setZip(zipcode);
                            location.setTel(Integer.parseInt(contact));
                            try {
                                
                                if (distance == 0) { // far far away 
                                    latitude = "0";
                                    longitude = "0";
                                }
                                
                                location.setLat(Double.parseDouble(latitude));
                                location.setLang(Double.parseDouble(longitude));
                            } catch (Exception e) {
                                System.out.println("coordinates are currupted");
                            }
                            s.save(location);
                            s.beginTransaction().commit();
                            System.out.println("LOCATION@saved");
                            resp.getWriter().write("LOCATION@saved");
                            servlet.Logger.doLog(user.getEmail(), "location added, location id #"+location.getIdlocation());
                        } else {
                            resp.getWriter().write("this address alreay in your account");
                        }
                    } else {
                        resp.getWriter().write("sorry. max four addresses can be stored.");
                    }
                    
                }
                
            } else {
                resp.getWriter().write("LOGIN_0");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.getWriter().write("wrong contact number");
        } catch (ParseException ex) {
            Logger.getLogger(location.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
//    public double GetDistance(String origin, String destination) throws IOException, ParseException {
//        String distance = null;
//        try {
//            String start = origin;
//            String end = destination;
//            
//            System.out.println("origin : " + origin);
//            System.out.println("desination : " + destination);
//            
//            String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=" + start + "&destinations=" + end + "&key=AIzaSyBCem9OP50lTpl7nt8zqycbY7e4-_PlIoo";
//            
//            HttpClient client = new DefaultHttpClient();
//            HttpGet request = new HttpGet(url);
//            
//            request.addHeader("User-Agent", USER_AGENT);
//            
//            HttpResponse response = client.execute(request);
//            
//            BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
//            
//            StringBuffer result = new StringBuffer();
//            String line = "";
//            while ((line = rd.readLine()) != null) {
//                result.append(line);
//            }
//            
//            JSONObject jo = (JSONObject) new JSONParser().parse(result.toString());
//            
//            System.out.println(jo);
//            
//            JSONArray all = (JSONArray) jo.get("rows");
//            JSONObject rows = (JSONObject) all.get(0);
//            
//            System.out.println(rows);
//            
//            JSONArray distanceArray = (JSONArray) rows.get("elements");
//            JSONObject elements = (JSONObject) distanceArray.get(0);
//            JSONObject data = (JSONObject) elements.get("distance");
//
//            // here getting distance
//            String distanceText = (String) data.get("text");
//            long value = (long) data.get("value");
//            
//            System.out.println(distanceText);
//            System.out.println(value);
//            
//            distance = distanceText.replace(" ", "").replace("km", "");
//            
//        } catch (NullPointerException e) {
//            System.out.println("place is far far away");
//            distance = "0";
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return Double.parseDouble(distance);
//    }
}
