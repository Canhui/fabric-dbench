## 1. Read Web Pages to String in Java

#### 1.1. Introduction

There are many ways to write a program to download web pages in Java. The simpler way is using the URL class with its input stream. The following example function is used to download a web page and return a string.



#### 1.2. Examples

First version without functions

```java
import java.net.*;
import java.io.*;

public class dataStorage {

    public static void main(String[] args) throws Exception {
        // TODO Auto-generated method stub
        URL oracle = new URL("http://www.comp.hkbu.edu.hk");
        BufferedReader in = new BufferedReader(new InputStreamReader(oracle.openStream()));
        
        String inputLine;
        while((inputLine = in.readLine()) != null) {
            System.out.println(inputLine);
        }
        in.close();
    }
}
```

Second version with main functions

```java
import java.net.*;
import java.io.*;

public class dataStorage {
    
    // Load the content of a web page
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
    
    // main
    public static void main(String[] args) throws Exception {
        String seedurl = "http://www.comp.hkbu.edu.hk";
        System.out.println(loadWebPage(seedurl));
    }
}
```


Step 1: create an URL object named oracle from the string "http://www.comp.hkbu.edu.hk" using the URL() function. 

See more URL function reference at https://docs.oracle.com/javase/7/docs/api/java/net/URL.html.


Step 2: You can call the URL's openStream() function to get a stream from which you can read the contents of the URL. The openStream() method returns a java.io.InputStream object, so reading a URL is as easy as reading from an input stream. The InputStreamReader() method is a bridge from the byte streams to character streams. The BufferedReader() method reads text from a character-input stream, and the buffering characters so as to provide for the efficient reading of characters, arrays, and lines. The buffer size may be specified, or the default size may be used. The default is large enough for most purposes.

See more openStream function reference at https://docs.oracle.com/javase/tutorial/networking/urls/readingURL.html

See more InputStreamReader function reference at https://docs.oracle.com/javase/7/docs/api/java/io/InputStreamReader.html

See more BufferedReader function reference at https://docs.oracle.com/javase/8/docs/api/java/io/BufferedReader.html


#### 1.3. Problems and Solutions (to be discussed)

Without any error, the string contains the full content of the target web page including HTML tags and values. If you want to remove all HTML tags such as "body", "html" and "script" tags etc. So, we need to use Regular Expression to match the HTML tags and delete them.

The javax.swing.text.html.HTMLEditorKit package provides a parser for parsing web pages. With the parser, we can download a web page that the HTML tags and the text of the target web page are separated. 

We have some updated.