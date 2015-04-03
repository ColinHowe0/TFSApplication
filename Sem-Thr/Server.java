/* 
 * Sean Vincent
 * CS 4485
 * Senior Project
 * Server
 */
package Testing;

// List of imports
import java.io.*;
import java.net.*;
import java.util.*;
import java.util.concurrent.Semaphore;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Server 
{
    // List of Semaphores
    Semaphore parseToSearch = new Semaphore(1);
    Semaphore queryToReturn = new Semaphore(0);
    Semaphore parseSearch = new Semaphore(1);
    Semaphore queryReturn = new Semaphore(0);
    
    // List of Queues
    Queue<String[]> request = new LinkedList<>();
    Queue<String> reply = new LinkedList<>();
    
    // Main Method
    public static void main(String[] args)
    {
        Server server = new Server();

        server.Receiver();
    }
    
    // Receiver Method
    private void Receiver()
    {
        try
        {
            // Create the socket on port number 8000
            ServerSocket serverSocket = new ServerSocket(8000);
            
            System.out.println("Server Running on Port " + 8000);
            
            Query task1 = new Query();
            
            new Thread(task1).start();
            
            // Continuously listen for connections to the socket
            while(true)
            {
                // Accept client connection to the server over the socket
                Socket clientSocket = serverSocket.accept();
                
                System.out.println("Client connected on " + new Date());
                
                InetAddress clientAddress = clientSocket.getInetAddress();
                
                System.out.println("Host name for client is: " 
                        + clientAddress.getHostName());
                System.out.println("IP Address for client is: " 
                        + clientAddress.getHostAddress());
                
                // Create a new thread for the connection
                Parse task2 = new Parse(clientSocket);
                
                // Start the new thread
                new Thread(task2).start();
            }
        }
        catch(IOException e)
        {
            System.out.println("Exception caught when trying to " 
                + "listen on port or listening for a connection");
            System.out.println(e.getMessage());
        }
    }
    
    // Subclass Query
    class Query implements Runnable
    {
        private String[] tokens;
        
        public Query(){
        }
        
        @Override
        // Start running the thread
        public void run()
        {
            while(true)
            {
                try
                {
                    queryToReturn.acquire();
                    parseToSearch.acquire();
                    
                    tokens = request.remove();
                }
                catch (InterruptedException ex)
                {
                    Logger.getLogger(Server.class.getName()).log(
                            Level.SEVERE, null, ex);
                }
                finally
                {
                    parseToSearch.release();
                }
                
                System.out.println("From Query");
                
                for(int x = 0; x < tokens.length; x++)
                {
                    System.out.println(tokens[x]);
                }
                
                try
                {
                    parseSearch.acquire();
                    
                    reply.offer("end");
                }
                catch (InterruptedException ex)
                {
                    Logger.getLogger(Server.class.getName()).log(
                            Level.SEVERE, null, ex);
                }
                finally
                {
                    queryReturn.release();
                    parseSearch.release();
                }
            }
        }
    }
    
    // Subclass NewClient
    class Parse implements Runnable
    {
        private Socket socket;
        private String input;
        private String[] tokens;
        
        // Link to socket
        public Parse(Socket cSocket)
        {
            this.socket = cSocket;
        }
        
        @Override
        // Start running the thread
        public void run()
        {
            try
            {
                // Create PrintWriter OutputStream on the socket
                PrintWriter out = new PrintWriter(
                        socket.getOutputStream(), true);
                // Create BufferedReader InputStream on the socket
                BufferedReader in = new BufferedReader(new InputStreamReader(
                        socket.getInputStream()));
                
                System.out.println("Now Serving New Client");
                
                // Continuously serve the clients
                while(true)
                {
                    input = in.readLine();
                    
                    tokens = input.split("[:]");
                    
                    System.out.println("From Parse");
                    
                    for(int x = 0; x < tokens.length; x++)
                    {
                        System.out.println(tokens[x]);
                    }
                    
                    try 
                    {
                        parseToSearch.acquire();
                        
                        request.offer(tokens);
                    } 
                    catch (InterruptedException ex) 
                    {
                        Logger.getLogger(Server.class.getName()).log(
                                Level.SEVERE, null, ex);
                    }
                    finally
                    {
                        queryToReturn.release();
                        parseToSearch.release();
                    }
                    
                    try 
                    {
                        queryReturn.acquire();
                        parseSearch.acquire();
                        
                        input = reply.remove();
                    } 
                    catch (InterruptedException ex) 
                    {
                        Logger.getLogger(Server.class.getName()).log(
                                Level.SEVERE, null, ex);
                    }
                    finally
                    {
                        parseSearch.release();
                    }
                    
                    out.println(input);
                    out.flush();
                }
            }
            catch(IOException ex)
            {
                System.err.println(ex);
            }
        }
    }
}
