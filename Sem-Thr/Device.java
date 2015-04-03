/* 
 * Sean Vincent
 * CS 4485
 * Senior Project
 * Device
 */
package Testing;

// List of imports
import java.io.*;
import java.net.*;
import java.util.*;

public class Device 
{
    // String to be sent over socket
    private String search = "connector stainless:3/4\"+1/4\":Stainless Steel";
    
    // String to temporarily store return data
    private String inputLine = "start";
    
    // Declaring socket for sending string
    Socket socket;
    
    PrintWriter out;
    
    // Main Method
    public static void main(String[] args)
    {
        try
        {
            Device device = new Device();
            
            device.Sender();
        }
        catch(IOException e)
        {
            System.out.println("exc in client");
        }
    }
    
    // Sender Method
    private void Sender() throws IOException
    {
        // Creating the socket on the host name and port number
        socket = new Socket("localhost", 8000);
        
        System.out.println("Client Connected to " + "localhost" + 
                " on Port " + 8000 + '\n');
        
        // Opening the PrintWriter OutputStream on the socket
        out = new PrintWriter(socket.getOutputStream(), true);
        
        // Create BufferedReader InputStream on the socket
        BufferedReader in = new BufferedReader(
            new InputStreamReader(socket.getInputStream()));
        
        // Send search string over socket
        out.println(search);
        out.flush();
        
        while(!"end".equals(inputLine))
        {
            inputLine = in.readLine();
        }
    }
}
