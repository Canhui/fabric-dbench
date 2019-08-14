## 1. Read Web Pages to String in Java

step 1 is to translate a web page into a string in Java. There are two methods to implement it.

There are many ways to write a program to download web pages in Jave. The simpler way is using the URL class with its input stream. The following example function is used to download a web page and return a string. Without any error, the string contains the full content of the target web page including HTML tags and values. If you want to remove all HTML tags. So, you need to use Regular Expression to match the HTML tags and delete them.



#### Method 1.  Reading Directly from a URL

see official tutorial: https://docs.oracle.com/javase/tutorial/networking/urls/readingURL.html

example source code:
```java
import java.net.*;
import java.io.*;

public class hello {

    public static void main(String[] args) throws Exception {
        // TODO Auto-generated method stub
        URL oracle = new URL("https://docs.oracle.com/javase/tutorial/networking/urls/readingURL.html");
        BufferedReader in = new BufferedReader(new InputStreamReader(oracle.openStream()));
        
        String inputLine;
        while((inputLine = in.readLine()) != null) {
            System.out.println(inputLine);
        }
        in.close();
    }
}
```


#### Method 2.  Check Size of the Web Page before Downloading (Recommended)

Instead directly download the web page, the web downloader will first check the size of the web page. For example, for these web pages whose sizes are larger than 1024 bytes, the web downloader will fail to download them. 

```java
import java.net.*;
import java.io.*;

public class hello {
    
    /*
     * Input: a web-page URL string
     * Output: a content string of the web page, if the size of the web page > 1024 bytes, it will fail
     */
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
    
    /*
     * main()
     */
    public static void main(String[] args) throws Exception {
        String url = "https://docs.oracle.com/javase/tutorial/networking/urls/readingURL.html";
        System.out.println(loadWebPage(url));
    }
}
```