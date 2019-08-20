## 4. Get Hyperlinks from the Text Content

We know that the tag <a> is used for defining a hyperlink in the HTML document. The href attribute specifies the destination address of the link.

We can override the `handleStartTag` method of MyParserCallback class for getting the hyperlinks in target web page. 


代码如下，
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
    
    public List<String> urls = new ArrayList<String>();
    
    @Override
    public void handleStartTag(Tag tag, MutableAttributeSet attrSet, int pos) 
    {
        if (tag.toString().equals("a")) {
            Enumeration e = attrSet.getAttributeNames();
            while (e.hasMoreElements()) {
                Object aname = e.nextElement();
                if (aname.toString().equals("href")) {
                    String u = (String) attrSet.getAttribute(aname);
                    if (urls.size() < 1024 && !urls.contains(u))
                        urls.add(u);
                }
            }
        }
    }

}


public class hello {

    static List<String> getURLs(String srcPage) throws IOException {
        URL url = new URL(srcPage);
        InputStreamReader reader = new InputStreamReader(url.openStream());

        ParserDelegator parser = new ParserDelegator();
        MyParserCallback callback = new MyParserCallback();
        parser.parse(reader, callback, true);
        return callback.urls;
    }

    
    public static void main(String[] args) throws Exception {
        String url = "https://www.york.ac.uk/teaching/cws/wws/webpage1.html";
        System.out.println(getURLs(url));
    }
}
```


加入Blacklist URLs功能如下，
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
    
    public List<String> URL_Pool = new ArrayList<String>();
    public List<String> Processed_URL_Pool = new ArrayList<String>();
    public List<String> Blacklist_of_URLs = new ArrayList<String>();
    
    @Override
    public void handleStartTag(Tag tag, MutableAttributeSet attrSet, int pos) 
    {
        Blacklist_of_URLs.add("https://computer.howstuffworks.com/question222.htm"); 
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
                        if(URL_Pool.size() < 1024 && !URL_Pool.contains(u) && !Blacklist_of_URLs.contains(u)) {
                            System.out.println(u);
                            URL_Pool.add(u);
                        }
                    }

                }
            }
        }
    }

}

public class hello {

    static List<String> getURLs(String srcPage) throws IOException {
        URL url = new URL(srcPage);
        InputStreamReader reader = new InputStreamReader(url.openStream());

        ParserDelegator parser = new ParserDelegator();
        MyParserCallback callback = new MyParserCallback();
        parser.parse(reader, callback, true);
        return callback.URL_Pool;
    }
    
    public static void main(String[] args) throws Exception {
//      String url = "https://www.york.ac.uk/teaching/cws/wws/webpage1.html";
//        String url = "https://www.g7website.com/website-categories/html-websites.html";
//      String url = "https://www.facebook.com/HowStuffWorks";
//      String seedurl = "http://www.microsoft.com/catalog/default.asp";
        String seedurl = "https://computer.howstuffworks.com/internet/basics/question226.htm";
//        System.out.println(getURLs(seedurl));
        getURLs(seedurl);
    }
}
```