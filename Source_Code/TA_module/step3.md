## 3. Get Unique Words from the Text Content

For different purposes, we want a list of unique words from a text content. For example, we have the following paragraph (java.txt) that includes English words, numbers, and symbols.

Now we are going to retrive the unique words from a web text. First, we need to split the paragraph into words. The easy way is using the `split()` method of the String object with a regular expression. As we wan to keep words only, we can use the following to match all non-alphabet characters and use them as delimiters to split the paragraph.


获取一个网页的Unique Words，完整代码如下

```java
// read web page
import java.net.*;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
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
    // Input
    // Output
    //
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

    //
    // main()
    //
    public static void main(String[] args) throws Exception {
        String url = "https://www.york.ac.uk/teaching/cws/wws/webpage1.html";
        System.out.println(getUniqueWords(loadPlainText(url)));
    }
}

```


