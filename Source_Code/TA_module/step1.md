## 1. Read Web Pages to String in Java


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


#### Method 2.  Check Size of the Web Page before Downloading

