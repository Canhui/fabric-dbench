## 1. Implement the URLs Extraction Algorithm

#### 1.1. Blacklist of URLs

 This blacklist contains the URLs of the web pages that the search engine would not scollect information from. In our implementation, these URLs are expressed in regular form.

In our implementation, by default, the `Blacklist_of_URLs` is empty as follows. 
```java
public static List<String> Blacklist_of_URLs = new ArrayList<String>();
```

Users can add new blacklist of URLs to the `Blacklist_of_URLs` as follows,
```java
callback.setBlacklistURLs("https://computer.howstuffworks.com/question246.htm");
callback.setBlacklistURLs("https://computer.howstuffworks.com/web-server.htm");
callback.setBlacklistURLs("https://computer.howstuffworks.com/program.htm");
```

#### 1.2. Data Structure of URLs

`URL_Pool` and `Processed_URL_Pool` are used to store URLs, where `URL_Pool` can store at most `X_URLs` URLs. If the number of URLs in the `Processed_URL_Pool` is not less than `Y_URLs`, then it stops.

```java
public int X_URLs = 1024; // initial value, at most extract 1024 URLs
public int Y_URLs = 6; // initial value, at least read with 512 URLs
public static List<String> URL_Pool = new ArrayList<String>();
public static List<String> Processed_URL_Pool = new ArrayList<String>();
```

Note that both `X_URLs` and `Y_URLs` are design parameters. Initially, `int X_URLs = 1024` and `int Y_URLs = 6`. We can alse change it in the run time,
```java
// new an object of the MyParserCallback class
MyParserCallback callback = new MyParserCallback();
callback.setX(1024);
callback.setY(10);
```

#### 1.3. Algorithm

Extract all URLs from a web page. For each of these URLs, add it to the URL Pool if it satisfies four conditions: First, it is not listed in the given blacklist; Second, it does not appear in URL Pool; Third, it does not appear in the Processed URL Pool and the number of URLs in the URL Pool is less than X. 

If the number of URLs in the Processed URL Pool is less than Y, then retrieve and remove the first URL from the URL Pool add this URL to Processed URL Pool, and get the corresponding web page. Otherwise, stop.


## Source Code

```java
import javax.swing.text.html.*;
import javax.swing.text.html.HTML.*;
import javax.swing.text.html.parser.*;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import javax.swing.text.*;

class MyParserCallback extends HTMLEditorKit.ParserCallback {
    
    public int X_URLs = 1024; // initial value, at most extract 1024 URLs
    public int Y_URLs = 6; // initial value, at least read with 512 URLs
    public static List<String> URL_Pool = new ArrayList<String>();
    public static List<String> Processed_URL_Pool = new ArrayList<String>();
    public static List<String> Blacklist_of_URLs = new ArrayList<String>();
    
    MyParserCallback(){
//      Blacklist_of_URLs.add("https://computer.howstuffworks.com/question222.htm"); // initial value
    }
    
    @Override
    public void handleStartTag(Tag tag, MutableAttributeSet attrSet, int pos) 
    {
        if (tag.toString().equals("a")) {
            Enumeration e = attrSet.getAttributeNames();
            while (e.hasMoreElements()) {
                Object aname = e.nextElement();
                if (aname.toString().equals("href")) {
                    String u = (String) attrSet.getAttribute(aname);
                    boolean url_protocol_matches = u.startsWith("http://")
                            || u.startsWith("https://") 
                            || u.startsWith("ftp://");
                    boolean url_resources_matches = u.endsWith(".html")
                            || u.endsWith(".htm"); 
                    if (url_protocol_matches && url_resources_matches) {
                        if(URL_Pool.size() < X_URLs && !URL_Pool.contains(u) && !Blacklist_of_URLs.contains(u) && !Processed_URL_Pool.contains(u)) {
                            URL_Pool.add(u);
                        }
                    }

                }
            }
        }
    }
    
    // Extract all URLs of a given page
    public List<String> getURLs(String srcPage) throws IOException {
        
        if (URL_Pool.contains(srcPage)) {
            URL_Pool.remove(srcPage);
        }
        
        URL url = new URL(srcPage);
        InputStreamReader reader = new InputStreamReader(url.openStream());

        ParserDelegator parser = new ParserDelegator();
        MyParserCallback callback = new MyParserCallback();
        parser.parse(reader, callback, true);
        Processed_URL_Pool.add(srcPage);
        return callback.URL_Pool;
    }

    // get number of URLs processed
    public int getSizeProcessedURLs() {
        return Processed_URL_Pool.size();
    }
    
    // get number of URLs to be processed
    public int getSizeURLs() {
        System.out.println(URL_Pool.size());
        return URL_Pool.size();
    }
    
    // get one URL to process
    public String getFirstItemURLs() {
        return URL_Pool.get(0);
    }
    
    // get X_URLs
    public int getX() {
        return X_URLs;
    }
    
    // get Y_URLs
    public int getY() {
        return Y_URLs;
    }
    
    // set X_URLs
    public void setX(int x) {
        this.X_URLs = x;
    }
    
    // set Y_URLs
    public void setY(int y) {
        this.Y_URLs = y;
    }
    
    // set Blacklist URLs
    public void setBlacklistURLs(String x) {
        MyParserCallback.Blacklist_of_URLs.add(x);
    }
}


public class hello {

    public static void main(String[] args) throws Exception {
//      String url = "https://www.york.ac.uk/teaching/cws/wws/webpage1.html";
//        String url = "https://www.g7website.com/website-categories/html-websites.html";
//      String url = "https://www.facebook.com/HowStuffWorks";
//      String seedurl = "http://www.microsoft.com/catalog/default.asp";
        //
        
        // seed url address
        String seedurl = "https://computer.howstuffworks.com/internet/basics/question226.htm";
        
        // new an object of the MyParserCallback class
        MyParserCallback callback = new MyParserCallback();
        callback.setX(1024);
        callback.setY(10);
        callback.setBlacklistURLs("https://computer.howstuffworks.com/question246.htm");
        callback.setBlacklistURLs("https://computer.howstuffworks.com/web-server.htm");
        callback.setBlacklistURLs("https://computer.howstuffworks.com/program.htm");
        
        // run the seed url
        System.out.println(callback.getURLs(seedurl));
        
        // run the URLs extraction algorithm
        while(callback.getSizeURLs() > 0) {
            if(callback.getSizeProcessedURLs()<callback.getY()) {
                System.out.println(callback.getURLs(callback.getFirstItemURLs()));
            }else {
                break;
            }
        }
        System.out.println(callback.getSizeProcessedURLs());
    
    }
}
```




