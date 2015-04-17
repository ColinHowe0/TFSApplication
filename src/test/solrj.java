package test;

import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import javax.imageio.ImageIO;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.noggit.JSONUtil;
import sun.misc.BASE64Encoder;
/**
 *
 * @author Alexandre
 */
public class solrj {
    File file = new File("test.json");
    String url = "http://localhost:8983/solr/";
  // String url = "http://45.56.71.18:8983/solr/";
    ArrayList<String> imageList = new ArrayList();
    String rowNum;
    SolrServer server = new HttpSolrServer(url);
    private static IPadresults resultPanel;
    private boolean isFirstToken;
    
    public solrj(IPadresults resultPanel) throws SolrServerException{
        solrj.resultPanel = resultPanel;
    }
    public void executeQuery(String[] str) throws SolrServerException, IOException{
        isFirstToken = true;
        String queryStr = "";
        
        // Turn all the strings from the textfield and comboBoxes into a query string
        queryStr = combineTexts(str, queryStr);

        // Query
        SolrQuery query = new SolrQuery(url);
        query.setRows(Integer.parseInt(rowNum));
        query.setQuery(queryStr);
        sendQueryResponse(server, query);
    }
    // Get the results from querying and send the results to the IPadresults panel
    private void sendQueryResponse(SolrServer server, SolrQuery query) throws IOException{
        try {
            QueryResponse response = server.query(query);
            SolrDocumentList results = response.getResults();             
            Iterator<SolrDocument> iterator = results.iterator();
            String resultString = "";
            int count = 0;
            while(iterator.hasNext()){
                
                SolrDocument a = iterator.next();
                String PName = "Part Name: " +(String)a.getFieldValue("PName");
                String group = "Group: " +(String)a.getFieldValue("Group");
                String mclass = "Material Class: " + (String)a.getFieldValue("Class");
                String size1 = "Size 1: " + (String)a.getFieldValue("Size1");
                String size2 = "Size 2: " + (String)a.getFieldValue("Size2");
                String ET1 = "End Type 1: " + (String)a.getFieldValue("ET1");
                String ET2 = "End Type 2: " + (String)a.getFieldValue("ET2");
                String MFG1 = "Manufacturer 1: " + (String)a.getFieldValue("MFG1");
                
                resultString += PName + "\n" + group+ "\n" + mclass + "\n" +
                        size1 + "\n" + size2 + "\n" + ET1 + "\n" +ET2 + "\n" +
                        MFG1 + "\n\n";
                count++;
                
                if(!imageList.contains((String)a.getFieldValue("ImageName"))){
                    imageList.add((String)a.getFieldValue("ImageName"));
                }
            }
            
            // Add each unique image name from the result 
            // as the field name with its Base64 string as the value to the list 
            // i.e. {"ImageName": "Base64 string"}
            for(int i = 0; i< imageList.size(); i++){
                SolrDocument imageDoc = new SolrDocument();
                imageDoc.addField(imageList.get(i), convertToBase64(imageList.get(i)));
                results.add(imageDoc);
            }
            
            outputToJSON(results);
            
            // Send the result to the result panel in IPadresults.form
            resultPanel.getResultLabel().setText(resultPanel.getResultLabel().getText() + "" + count);
            // Send the result to textfield in IPadresults.form
            resultPanel.getTextArea().setText(resultString);
        } catch (SolrServerException ex) {
            System.out.println(ex);
        }
    }
    
    //Convert the image to Base64 string
    public String convertToBase64(String imageName) throws IOException{
        BufferedImage img = ImageIO.read(new File("src/image/" +imageName+".jpg"));
        String imageString = null;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();

        try {
            ImageIO.write(img, "jpg", bos);
            byte[] imageBytes = bos.toByteArray();

            BASE64Encoder encoder = new BASE64Encoder();
            imageString = encoder.encode(imageBytes);
            bos.close();
        } 
        catch (IOException e) {
        }
        
        return imageString;
    }
    
    
    // Set the maximum number of rows the result can show.
    public void setRowNum(String rowNum){
        this.rowNum = rowNum;
    }
    
    // Output the result to the JSON file
    private void outputToJSON(SolrDocumentList result) throws IOException{
        try (BufferedWriter output = new BufferedWriter(new FileWriter(file))) {
            output.write(JSONUtil.toJSON(result));
            output.close();
        }
        System.out.println("The JSON file size is " + file.length() + " bytes");
    }
    
    // Compile all the texts from the search field and drop down fields
    // into a query string.
    private String combineTexts(String[] str, String queryStr){
        if(!str[0].isEmpty()){
            queryStr = tokenizeGeneralSearchString(str[0], queryStr);
        }
        if(!str[1].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND Group:" + str[1];
            else{
                queryStr = "Group:" + str[1];
                isFirstToken = false;
            }
        }
        if(!str[2].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND PT:" + str[2];
            else{
                queryStr = "PT:" + str[2];
                isFirstToken = false;
            }
        }
        if(!str[3].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND Class:" + str[3];
            else{
                queryStr = "Class:" + str[3];
                isFirstToken = false;
            }
        }
        if(!str[4].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND Size1:" + str[4];
            else{
                queryStr = "Size1:" + str[4];
                isFirstToken = false;
            }
        }
        if(!str[5].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND Size2:" + str[5];
            else{
                queryStr = "Size2:" + str[5];
                isFirstToken = false;
            }
        }
        if(!str[6].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND ET1:" + str[6];
            else{
                queryStr = "ET1:" + str[6];
                isFirstToken = false;
            }
        }
        if(!str[7].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND ET2:" + str[7];
            else{
                queryStr = "ET2:" + str[7];
                isFirstToken = false;
            }
        }
        if(!str[8].isEmpty()){
            if(!isFirstToken)
                queryStr += " AND MFG1:" + str[8];
            else{
                queryStr = "MFG1:" + str[8];
                isFirstToken = false;
            }
        }
        return queryStr;
    }
    private String tokenizeGeneralSearchString(String genStr, String queryStr){
        String[] token = genStr.split("[ ]+");
        token = modifyString(token);
        isFirstToken = true;
        queryStr = "PName:" + token[0];
        if(token.length > 1){
            for(int i = 1; i < token.length; i++){
                queryStr += " AND PName:" + token[i];
            }
        }
       return queryStr;
    }
    
    // Convert AND, OR, and NOT to lowercase or else the program will take them 
    // as boolean logics.
    private String[] modifyString(String[] token){      
        for(int i = 0; i < token.length; i++){
            String newstr;
            if(token[i].indexOf("AND") >= 0 || token[i].indexOf("OR") >= 0
                    || token[i].indexOf("NOT") >= 0){
                newstr = token[i].toLowerCase();
            }
            else
                newstr = insertBackSlash(token[i]);
            token[i] = newstr;
        }
        return token;
    }
    // Insert a backslash before a special character
    public String insertBackSlash(String tokenIndex){
        String newstr = "";
        for(int i = 0; i < tokenIndex.length(); i++){
            switch(tokenIndex.charAt(i)){
                case '"': 
                    newstr += "\\\"";
                    break;
                case'(': 
                    newstr += "\\(";
                    break;
                case')': 
                    newstr += "\\)";
                    break;
                case'/':
                    newstr += "\\/";
                    break;
                case'\\': 
                    newstr += "\\\\";
                    break;
                case'-':
                    newstr += "\\-";
                    break;
                case'!':
                    newstr += "\\!";
                    break;
                case '^':
                    newstr += "\\^";
                    break;
                case '+':
                    newstr += "\\+";
                    break;
                case '{':
                    newstr += "\\{";
                    break;
                case '}':
                    newstr += "\\}";
                    break;
                case'[':
                    newstr += "\\[";
                    break;
                case']':
                    newstr += "\\]";
                    break;
                case '~':
                    newstr += "\\~";
                    break;
                case ':':
                    newstr += "\\:";
                    break;
                default:
                    newstr += tokenIndex.charAt(i);
                    break;
                }
        }
        return newstr;
    }
}
