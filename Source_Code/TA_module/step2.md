## 2. Retrive Text from Web Page

step2 is to retrive text from the web page. The `javax.swing.text.html.HTMLEditorKit` package provides a parser for parsing web pages. With the parser, we can download a web page that the HTML tags and the text of the target web page are separated.

#### 2.1. ParserCallback

The `ParserCallback` class provides the methods for handling the web content.





#### 2.2. Define a New ParserCallback

We can define a new `ParserCallback` class based on the original `ParserCallback` class. For example, the `handleText()` function is very useful for scraping the web content in the plain text format. So, we now define a new `ParserCallback` class and override the `hadleText()` method for outputting a plain text content of a target web page.

混沌完整版 (在step1的基础上)

```java
// read web page
import java.net.*;
import java.io.*;

// ParserCallback
import javax.swing.text.html.*;
import javax.swing.text.html.HTML.*;
import javax.swing.text.html.HTMLEditorKit.*;
import javax.swing.text.html.parser.*;
import javax.swing.text.*;

/*
 * MyParserCallback class
 */
class MyParserCallback extends HTMLEditorKit.ParserCallback {
    public String content = new String();

    @Override
    public void handleText(char[] data, int pos) {
        content += " " + new String(data);
    }
}

/*
 * Main class
 */
public class hello {
    
    //
    // Input: a web-page URL string
    // Output: a content string of the web page, if the size of the web page > 1024 bytes, it will fail
    //
    public static String loadWebPage(String urlString) {
        byte[] buffer = new byte[1024];
        String content = new String();
        
        try {
            URL url = new URL(urlString);
            InputStream in = url.openStream();
            
            int len;
            while((len = in.read(buffer)) != -1) {
                content += new String(buffer);
            }
        } catch (IOException e) {
                content = "<h1>Unable to download the page</h1>" + urlString;
        }
        return content;
    }
    
    //
    // Input: a web-page URL string
    // Output: a parsed content string of the web page
    //
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }

    
    //
    // main()
    //
    public static void main(String[] args) throws Exception {
        String url = "https://docs.oracle.com/javase/tutorial/networking/urls/readingURL.html";
        System.out.println(loadPlainText(url));
    }
}
```



核心完整版 (删除step1的代码)

```java
// read web page
import java.net.*;
import java.io.*;

// ParserCallback
import javax.swing.text.html.*;
import javax.swing.text.html.HTML.*;
import javax.swing.text.html.HTMLEditorKit.*;
import javax.swing.text.html.parser.*;
import javax.swing.text.*;

/*
 * MyParserCallback class
 */
class MyParserCallback extends HTMLEditorKit.ParserCallback {
    public String content = new String();

    @Override
    public void handleText(char[] data, int pos) {
        content += " " + new String(data);
    }
}

/*
 * Main class
 */
public class hello {
    
    //
    // Input: a web-page URL string
    // Output: a parsed content string of the web page
    //
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }

    //
    // main()
    //
    public static void main(String[] args) throws Exception {
        String url = "https://www.york.ac.uk/teaching/cws/wws/webpage1.html";
        System.out.println(loadPlainText(url));
    }
}
```


## 2.3. Conclusion

The handleText() method accepts two parameters: data and pos. The parameter data contains the bodu text of a tag, and pos indicates the starting position of the body text. 

The parse() method of the `ParserDelegator` instance drives the callback to parse the web content retrived from the input stream reader. The last parameter  