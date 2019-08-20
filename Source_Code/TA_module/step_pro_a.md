This part is about seed URLs and the URLs' filter.


## 1. Seed URLs

Our seed URLs is "https://computer.howstuffworks.com/internet/basics/question226.htm".



## 2. Universal Resource Locators (URLs) Filter

Every resource available on the Web -- HTML document, image, video, clip, program, etc -- has an address that may be encoded by a Universal Resource Locator (i.e., URL). URLs typically consist of three pieces:

a. The name of the protocol used to transfer the resource over the Web. In this case, we filter these URLs starting with "http", "https" or "ftp". 

b. The name of the machine hosting the resource. In this case, we have no restrictions on domain names.

c. The name of the resource itself. In this case, we filter these resource ending with ".html" or ".htm".

 

## 3. Source Code

The source code is given as follows,

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
                        if(URL_Pool.size() < 1024 && !URL_Pool.contains(u)) {
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
        String seedurl = "https://computer.howstuffworks.com/internet/basics/question226.htm";
        getURLs(seedurl);
    }
}
```



## Reference
[1. Universal Resource Locators (URLs) Filter] https://www.w3.org/TR/WD-html40-970708/htmlweb.html
