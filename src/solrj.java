import java.util.Iterator;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.noggit.JSONUtil;
/**
 *
 * @author Alexandre
 */
public class solrj {
    private static int count = 0;
    private static IPadresults r;
    private boolean isFirstToken = true;
    public solrj(IPadresults r) throws SolrServerException{
        solrj.r = r;
    }
    
    // Get the results from querying and send the results to the IPadresults 
    // panel
    private void sendQueryResponse(SolrServer server, SolrQuery query) throws SolrServerException{
        QueryResponse response = server.query(query);
         SolrDocumentList results = response.getResults();
        // String returnValue = JSONUtil.toJSON(results); //this has the json documents
         
         Iterator<SolrDocument> iterator = results.iterator();
         String result = "";
        while(iterator.hasNext()){
            SolrDocument a = iterator.next();
            result += (String)a.getFieldValue("PName")+ "\n" +
                    (String)a.getFieldValue("Group") + "\n" +
                    (String)a.getFieldValue("Class") + "\n" +
                    (String)a.getFieldValue("Size1") + "\n" +
                    (String)a.getFieldValue("ET1") + "\n\n";
            count++;
        }
        
        // Send the results
        r.getResultLabel().setText(r.getResultLabel().getText() + "" + count);
        r.getTextArea().setText(result);
    }
    
    // Return the result panel of IPadresults
    public IPadresults getResultPanel(){
        return r;
    }
    public void executeQuery(String[] str) throws SolrServerException{
        String queryStr = "";
        queryStr = combineTexts(str, queryStr);
        String url = "http://localhost:8983/solr/";
        SolrServer server = new HttpSolrServer(url);
         
        // Query
        SolrQuery query = new SolrQuery(url);
        query.setRows(10);
        query.setQuery(queryStr);
        sendQueryResponse(server, query);
    }
    
    // Compile all the texts from the search field and drop down fields
    // into a query string.
    private String combineTexts(String[] str, String queryStr){
        if(!str[0].isEmpty()){
            queryStr = tokenizeGeneralSearchString(str[0], queryStr);
        }
        if(!str[1].isEmpty()){
            queryStr = "Group:" + str[1];
            if(!isFirstToken)
                queryStr += " AND " + queryStr;
        }
        if(!str[2].isEmpty()){
            queryStr = "PT:" + str[2];
            if(!isFirstToken)
                queryStr += " AND " + queryStr;
        }
        if(!str[3].isEmpty()){
            queryStr = "Class:" + str[3];
            if(!isFirstToken)
                queryStr += " AND " + queryStr;
        }
        if(!str[4].isEmpty()){
            queryStr = "Size1:" + str[4];
            if(!isFirstToken)
                queryStr += " AND " + queryStr;
        }
        return queryStr;
    }
    private String tokenizeGeneralSearchString(String genStr, String queryStr){
        String[] token = genStr.split("[ ]+");
        token = insertBackSlash(token);
        isFirstToken = true;
        for(int i = 0; i < token.length; i++){
            System.out.println(token[i]);
        }
        queryStr = "PName:" + token[0];
        if(token.length > 1){
            for(int i = 1; i < token.length; i++){
                queryStr += " AND PName:" + token[i];
            }
        }
       return queryStr;
    }
    private String[] insertBackSlash(String[] token){      
        for(int i = 0; i < token.length; i++){
            String newstr = "";
            // AND and OR are boolean logics in Solr so if a user types either, 
        // which is highly unlikely, the program will convert them to regular 
        // words "and" and "or".
        if(token[i].indexOf("AND") >= 0 || token[i].indexOf("OR") >= 0){
            newstr = token[i].toLowerCase();
        }
        else
            for(int j = 0; j < token[i].length(); j++){
                if(token[i].charAt(j) == '\"')
                    newstr += "\\\"";
                else
                    newstr += token[i].charAt(j);
            }
        token[i] = newstr;
        }
        return token;
    }
}
