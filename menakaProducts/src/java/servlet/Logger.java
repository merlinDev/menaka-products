/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author nipun
 */
public class Logger {

    public static void doLog(String user, String note) {
        
        String log = new Date().toString() + " , user : " + user + " : " + note;

        try {
            SimpleDateFormat dateDormat = new SimpleDateFormat("yyyy-MM-dd");
            String date = dateDormat.format(new Date());
            
            File file = new File("web/loggers/"+date+".txt");
            
            FileWriter fw = new FileWriter(file, true); 
            fw.write(log+System.getProperty("line.separator"));
            fw.close();
            
            String lineSeparator = System.lineSeparator();
            
            System.out.println(log);
            System.out.println("done");
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
        }
    }
    
    public static void main(String args[]){
        doLog("test","testing logger");
    }

}
