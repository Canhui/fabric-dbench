## 1. URL处理的算法

```java
import java.net.*;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.List;

import javax.swing.text.MutableAttributeSet;
import javax.swing.text.html.HTML.Tag;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.parser.ParserDelegator;
import java.io.*;


class MyParserCallback extends HTMLEditorKit.ParserCallback {
    
    public String content = new String();
    public List<String> urls_within_a_page = new ArrayList<String>();

    // Override ParserCallback.handleText Function
    @Override
    public void handleText(char[] data, int pos) {
        content += new String(data) + " ";
    }
    
    // Override ParserCallback.handleStartTag Function
    @Override
    public void handleStartTag(Tag tag, MutableAttributeSet attrSet, int pos) 
    {
        if (tag.toString().equals("a")) {
            Enumeration e = attrSet.getAttributeNames();
            while (e.hasMoreElements()) {
                Object aname = e.nextElement();
                if (aname.toString().equals("href")) {
                    String u = (String) attrSet.getAttribute(aname);
                    if (urls_within_a_page.size() < 1024 && !urls_within_a_page.contains(u))
                        urls_within_a_page.add(u);
                }
            }
        }
    }
    
    // Customized Function for Parsed Text
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }
    
    // Customized Function for Unique Words
    public static List<String> getUniqueWords(String text) {
        String[] words = text.split("[0-9\\W]+");
        ArrayList<String> uniqueWords = new ArrayList<String>();

        for (String w : words) {
            w = w.toLowerCase();

            if (!uniqueWords.contains(w))
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
    
    // Customized Function for Getting URLs within a Page
    public static List<String> getURLs(String srcPage) throws IOException {
//      URL url = new URL(srcPage);
        URL url = new URL(getRedirectUrl(srcPage));
        InputStreamReader reader = new InputStreamReader(url.openStream());

        ParserDelegator parser = new ParserDelegator();
        MyParserCallback callback = new MyParserCallback();
        parser.parse(reader, callback, true);
        
        for (int i=0; i<callback.urls_within_a_page.size(); i++) {
            String str = callback.urls_within_a_page.get(i);
            if (!isAbsURL(str)) {
                callback.urls_within_a_page.set(i, toAbsURL(str, url).toString());
            } else {
            }
        }

        return callback.urls_within_a_page;
    }

    public static boolean isAbsURL(String str) {
        return str.matches("^[a-z0-9]+://.+");
    }

    public static URL toAbsURL(String str, URL ref) throws MalformedURLException {
        URL url = null;
        
        String prefix = ref.getProtocol() + "://" + ref.getHost();
        
        if (ref.getPort() > -1)
            prefix += ":" + ref.getPort();
        
        if (!str.startsWith("/")) {
//            int len = ref.getPath().length() - ref.getFile().length();
            String tmp = "/" + ref.getPath() + "/";
            prefix += tmp.replace("//", "/");
        }
        url = new URL(prefix + str);
        return url; 
    }
    
    public static String getRedirectUrl(String stringurl) throws MalformedURLException, IOException {
        URLConnection con = new URL( stringurl ).openConnection();
        con.connect();
        InputStream is = con.getInputStream();
        is.close();
        return con.getURL().toString();
    }
    
}



class URLExtractionAlgorithm{
    
    // ---------------------------------------------------
    // Handle URLs
    // ---------------------------------------------------
    public String seedURL = "http://www.comp.hkbu.edu.hk";
//  String seedurl = "http://www.sci.hkbu.edu.hk";
    public int X_URLs = 10;
    public int Y_URLs = 100;
    public static List<String> URL_Pool = new ArrayList<String>();
    public static List<String> Processed_URL_Pool = new ArrayList<String>();
    
    // ---------------------------------------------------
    // Handle Text of A Page
    // ---------------------------------------------------
    public String content = new String();
    public static List<String> Blacklist_of_Words = new ArrayList<String>();
    public static List<String> Ignore_of_Words = new ArrayList<String>();
    
    
    public static String getRedirectUrl(String stringurl) throws MalformedURLException, IOException {
        URLConnection con = new URL( stringurl ).openConnection();
        con.connect();
        InputStream is = con.getInputStream();
        is.close();
        return con.getURL().toString();
    }
    
    
    public void Algorithm() throws IOException {
        
        MyParserCallback Parser = new MyParserCallback();
        
        // Handle the seedurl
        URL_Pool.add(getRedirectUrl(seedURL));
        String ta = URL_Pool.get(0);
        Processed_URL_Pool.add(ta);
        URL_Pool.remove(ta);
        List<String> t1 = new ArrayList<String>();
        t1 = Parser.getURLs(ta);
        for(int i = 0; i < t1.size(); i++) {
            if (!URL_Pool.contains(t1.get(i)) && URL_Pool.size() < X_URLs && !Processed_URL_Pool.contains(t1.get(i))) {
                URL_Pool.add(t1.get(i));
            }
        }
                    
        
        // All Rounds
        while(URL_Pool.size() != 0 ) {
            if(Processed_URL_Pool.size() >= Y_URLs) {
                break;
            }
            // First in First Out -> URL_Pool
            String tb = URL_Pool.get(0);
            Processed_URL_Pool.add(tb); 
            URL_Pool.remove(tb);
            List<String> t2 = new ArrayList<String>();
            t2 = Parser.getURLs(tb);
            for(int i = 0; i < t2.size(); i++) {
                if (!URL_Pool.contains(t2.get(i)) && URL_Pool.size() < X_URLs && !Processed_URL_Pool.contains(t2.get(i))) {
                    System.out.println("URL_Pool pops: "+tb+ ", then URL_Pool size: "+URL_Pool.size()+", new urls: "+t2.get(i));
                    URL_Pool.add(t2.get(i));
                }
            }
        }
                
    }
       
}


public class dataStorage {
    
    // main
    public static void main(String[] args) throws Exception {
        URLExtractionAlgorithm URLs = new URLExtractionAlgorithm();
        URLs.Algorithm();
    }
}
```

