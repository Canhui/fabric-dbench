## 1. Extract all words of a page (inclusing position information)

First, we get page context of a web page,

```java
// load text of a web page
public static String loadPlainText(String urlString) throws IOException {
    MyParserCallback callback = new MyParserCallback();
    ParserDelegator parser = new ParserDelegator();
        
    URL url = new URL(urlString);
    InputStreamReader reader = new InputStreamReader(url.openStream());
    parser.parse(reader, callback, true);
            
    return callback.content;
}
```

Then, we analyze the context including words and positions,
```java
//    // get words and positions of a web page
public static List<String> getWords(String text) {
    String[] words = text.split("[0-9\\W]+");
    ArrayList<String> finalwords = new ArrayList<String>();
////        int p = 0;
    for (String w : words) {
        w = w.toLowerCase();
////            p = p + 1;
        finalwords.add(w);
//////            if (!uniqueWords.contains(w) && !Blacklist_of_Words.contains(w))
//////                uniqueWords.add(w);
    }
//        
    return finalwords;
}
```

Finally, we use the functions. For example, we get the word of the first position,
```java
System.out.println(callback.getWords(callback.loadPlainText(seedurl)).get(1));
```

## 2. Source Code

```java
import javax.swing.text.html.*;
import javax.swing.text.html.HTML.*;
import javax.swing.text.html.parser.*;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Comparator;
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
        
        // Extract all words from this web page: srcPage
        // TO DO <-----------------------
        
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
//      System.out.println(URL_Pool.size());
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
    
    // ---------------------------------------------------
    // handle text of a page
    // ---------------------------------------------------
    public String content = new String();
    public static List<String> Blacklist_of_Words = new ArrayList<String>();

    // handle text of a web page
    @Override
    public void handleText(char[] data, int pos) {
        content += " " + new String(data);
    }
    
    // load text of a web page
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }
    
    // get unique words of a web page
    public static List<String> getUniqueWords(String text) {
        String[] words = text.split("[0-9\\W]+");
        ArrayList<String> uniqueWords = new ArrayList<String>();

        for (String w : words) {
            w = w.toLowerCase();

            if (!uniqueWords.contains(w) && !Blacklist_of_Words.contains(w))
                uniqueWords.add(w);
        }
        
        uniqueWords.sort(new Comparator<String>() {
            @Override
            public int compare(String a, String b) {
                return a.compareTo(b);
            }
        });

        return uniqueWords;
    }
    
//    // get words and positions of a web page
    public static List<String> getWords(String text) {
        String[] words = text.split("[0-9\\W]+");
        ArrayList<String> finalwords = new ArrayList<String>();
////        int p = 0;
        for (String w : words) {
            w = w.toLowerCase();
////            p = p + 1;
            finalwords.add(w);
//////            if (!uniqueWords.contains(w) && !Blacklist_of_Words.contains(w))
//////                uniqueWords.add(w);
        }
//        
        return finalwords;
    }
    

    
    // set Blacklist Words
    public void setBlacklistWords(String x) {
        MyParserCallback.Blacklist_of_Words.add(x);
    }
    
}


public class hello {
    
    public static void main(String[] args) throws Exception {
//      String url = "https://www.york.ac.uk/teaching/cws/wws/webpage1.html";
//        String url = "https://www.g7website.com/website-categories/html-websites.html";
//      String url = "https://www.facebook.com/HowStuffWorks";
//      String seedurl = "http://www.microsoft.com/catalog/default.asp";
        
        // seed url address
        String seedurl = "https://computer.howstuffworks.com/internet/basics/question226.htm";
        
        // new an object of the MyParserCallback class
        MyParserCallback callback = new MyParserCallback();
        callback.setX(1024);
        callback.setY(10);
        callback.setBlacklistURLs("https://computer.howstuffworks.com/question246.htm");
        callback.setBlacklistURLs("https://computer.howstuffworks.com/web-server.htm");
        callback.setBlacklistURLs("https://computer.howstuffworks.com/program.htm");
//      callback.setBlacklistWords("a");
//      callback.setBlacklistWords("about");
//      callback.setBlacklistWords("able");
//      callback.setBlacklistWords("the");
        
        // run the seed url
        callback.getURLs(seedurl);
//      System.out.println(callback.getURLs(seedurl));
        System.out.println(seedurl);
//      System.out.println(callback.loadPlainText(seedurl));
//      System.out.println(callback.getWords(callback.loadPlainText(seedurl)));
        System.out.println(callback.getWords(callback.loadPlainText(seedurl)).get(1));
//      System.out.println(callback.loadPlainText(seedurl));
//      System.out.println(callback.getUniqueWords(callback.loadPlainText(seedurl)));
        
        // run the URLs extraction algorithm
        while(callback.getSizeURLs() > 0) {
            if(callback.getSizeProcessedURLs()<callback.getY()) {
                callback.getURLs(callback.getFirstItemURLs());
                System.out.println(callback.getFirstItemURLs());
                System.out.println(callback.getWords(callback.loadPlainText(callback.getFirstItemURLs())).get(1));
//              System.out.println(callback.getUniqueWords(callback.loadPlainText(callback.getFirstItemURLs())));
//              System.out.println(callback.getURLs(callback.getFirstItemURLs()));
            }else {
                break;
            }
        }
//      System.out.println(callback.getSizeProcessedURLs());
    
    }
    
}
```