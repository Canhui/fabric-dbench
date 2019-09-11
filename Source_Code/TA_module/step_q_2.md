## 1. Parser and Retrive Text from String of Web Page

The ParserCallback class provides the methods for handling the web content. It has the following methods, such as handleStartTag(), handleEndTag(), handleSimpleTag(), handleText(), handleComment(), handleError(), and handleEndofLineString(). 

The ParserCallback() class is a father class. In practice, we can use the keyword "extends" to create a subclass that inherits the ParserCallback() class. It means that when defining our own ParserCallback subclass, we can select some functions (not all) from the ParserCallback father class.


#### 1.1. Example

In this example, we select the handleText() function that is useful for scraping the web content in the plain text format (excluding HTML tags), to implement our own PaeserCallback() subclass to parser and retrive text from web-page string. 

```java
import java.net.*;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.parser.ParserDelegator;
import java.io.*;

class MyParserCallback extends HTMLEditorKit.ParserCallback {
    public String content = new String();

    // Override Function: override the ParserCallback handleText() function
    @Override
    public void handleText(char[] data, int pos) {
        content += " "+new String(data);
    }
}

public class dataStorage {
    
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }
    
    // main
    public static void main(String[] args) throws Exception {
        String seedurl = "http://www.comp.hkbu.edu.hk";
        System.out.println(loadPlainText(seedurl));
    }
}
```

TO DO: what is the handleText() texts handled by ParserCallback.handleText()?

TO DO: what it will be when parser.parse(reader, callback, false)? The last parameter of the parse() method indicates whether it ignores the charset of not. If the ignoreCharSet is equal to false, the parser may throw ChangedCharSetException when it parses a redirected page or the page without specified CharSet.



#### 1.2. Getting Unique Words from Text Content

For different purposes, we want a list of unique words from a text content. For example, we have a paragraph that includes English words, numbers and symbols. Now, we are going to retrive the unique words (no duplicated words, numbers, and symbols) from the above paragraph. First, we need to split the paragraph into words. The easy way is using the split() method of the string object with a regular expression. As we want to keep words only, we can use the following to match all non-alphabet characters and use them as delimiters to split the paragraph.

An example code is given as follows,

```java
import java.net.*;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.parser.ParserDelegator;
import java.io.*;

class MyParserCallback extends HTMLEditorKit.ParserCallback {
    public String content = new String();

    // Override Function: override the ParserCallback handleText() function
    @Override
    public void handleText(char[] data, int pos) {
        content += new String(data) + " ";
    }
}

public class dataStorage {
    
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }
    
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
    
    
    // main
    public static void main(String[] args) throws Exception {
        String seedurl = "http://www.comp.hkbu.edu.hk";
        System.out.println(getUniqueWords(loadPlainText(seedurl)));
    }
}
```

TO DO: what does the "[\\d\\W]+" meaning?



#### 1.3. Get Hyperlinks from the Text Content

We know that the <a> tag is used for defining a hyperlink in the HTML document. The href attribute specifies the destination address of the link. The following code will use handleStartTag() method for storing the URLs retrived from the <a> tags. 

The first version of source code is given as follows,

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
    public List<String> urls = new ArrayList<String>();

    // Override Function: override the ParserCallback handleText() function
    @Override
    public void handleText(char[] data, int pos) {
        content += new String(data) + " ";
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
                    if (urls.size() < 1024 && !urls.contains(u))
                        urls.add(u);
                }
            }
        }
    }
}

public class dataStorage {
    
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }
    
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
    
    public static List<String> getURLs(String srcPage) throws IOException {
        URL url = new URL(srcPage);
        InputStreamReader reader = new InputStreamReader(url.openStream());

        ParserDelegator parser = new ParserDelegator();
        MyParserCallback callback = new MyParserCallback();
        parser.parse(reader, callback, true);
        return callback.urls;
    }
    
    
    // main
    public static void main(String[] args) throws Exception {
        String seedurl = "http://www.comp.hkbu.edu.hk";
        System.out.println(getURLs(seedurl));
    }
}
```

We get a list that contains the elements as follows,

```shell
https://www.facebook.com/hkbu.comp
http://www.weibo.com/hkbucs/
?page=hkbu
?page=sci
?page=buniport
?page=library
?page=alumni
?page=job_vacancies
?page=intranet
?page=sitemap
/v1/?lang=tc
/v1/?lang=sc
?page=home
?page=about_us
?page=people
?page=research
?page=prospective_students
?page=current_students
?page=facilities
?page=head
?page=whats_new
?page=achievements
http://www.comp.hkbu.edu.hk/msc/
?page=awards_and_scholarships
?page=news
?page=events
?pid=14
?page=highlights
?pid=16
/outreach/
?page=std_ach&id=128
?page=news&id=446
general/video_html/intro_eng.php?time=0
#
?page=highlights&id=215
?page=highlights&id=201
?page=highlights&id=202
?page=dept_events&id=201
?page=seminars&id=540
?page=seminars&id=539
http://www.hkbu.edu.hk/eng/about/privacy.jsp
```

We can find that some elements do not have the protocol and host name. They are not absolute URLs and they are relative URLs retrived from local links defind in the web page. But they do not work individually. We need to add the protocols and host names back so that they become absolute URLs.


The second version of source code is given as follows,

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
    public List<String> urls = new ArrayList<String>();

    // Override Function: override the ParserCallback handleText() function
    @Override
    public void handleText(char[] data, int pos) {
        content += new String(data) + " ";
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
                    if (urls.size() < 1024 && !urls.contains(u))
                        urls.add(u);
                }
            }
        }
    }
}

public class dataStorage {
    
    public static String loadPlainText(String urlString) throws IOException {
        MyParserCallback callback = new MyParserCallback();
        ParserDelegator parser = new ParserDelegator();
        
        URL url = new URL(urlString);
        InputStreamReader reader = new InputStreamReader(url.openStream());
        parser.parse(reader, callback, true);
            
        return callback.content;
    }
    
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
    

    public static List<String> getURLs(String srcPage) throws IOException {
        URL url = new URL(srcPage);
        InputStreamReader reader = new InputStreamReader(url.openStream());

        ParserDelegator parser = new ParserDelegator();
        MyParserCallback callback = new MyParserCallback();
        parser.parse(reader, callback, true);
        
        for (int i=0; i<callback.urls.size(); i++) {
            String str = callback.urls.get(i);
            if (!isAbsURL(str))
                callback.urls.set(i, toAbsURL(str, url).toString());
        }

        return callback.urls;
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
            int len = ref.getPath().length() - ref.getFile().length();
            String tmp = "/" + ref.getPath().substring(0, len) + "/";
            prefix += tmp.replace("//", "/");
        }
        url = new URL(prefix + str);

        return url; 
    }

    
    // main
    public static void main(String[] args) throws Exception {
        String seedurl = "http://www.comp.hkbu.edu.hk";
        System.out.println(getURLs(seedurl));
    }
}
```

We get a list that contains the elements as follows,

```shell
https://www.facebook.com/hkbu.comp
http://www.weibo.com/hkbucs/
http://www.comp.hkbu.edu.hk/?page=hkbu
http://www.comp.hkbu.edu.hk/?page=sci
http://www.comp.hkbu.edu.hk/?page=buniport
http://www.comp.hkbu.edu.hk/?page=library
http://www.comp.hkbu.edu.hk/?page=alumni
http://www.comp.hkbu.edu.hk/?page=job_vacancies 
http://www.comp.hkbu.edu.hk/?page=intranet
http://www.comp.hkbu.edu.hk/?page=sitemap
http://www.comp.hkbu.edu.hk/v1/?lang=tc
http://www.comp.hkbu.edu.hk/v1/?lang=sc
http://www.comp.hkbu.edu.hk/?page=home
http://www.comp.hkbu.edu.hk/?page=about_us
http://www.comp.hkbu.edu.hk/?page=people
http://www.comp.hkbu.edu.hk/?page=research
http://www.comp.hkbu.edu.hk/?page=prospective_students 
http://www.comp.hkbu.edu.hk/?page=current_students
http://www.comp.hkbu.edu.hk/?page=facilities
http://www.comp.hkbu.edu.hk/?page=head
http://www.comp.hkbu.edu.hk/?page=whats_new
http://www.comp.hkbu.edu.hk/?page=achievements 
http://www.comp.hkbu.edu.hk/?page=newsletter
http://www.comp.hkbu.edu.hk/?page=dept_profile
http://www.comp.hkbu.edu.hk/?page=video_introduction
http://www.comp.hkbu.edu.hk/?page=contact
http://www.comp.hkbu.edu.hk/?page=faculty
http://www.comp.hkbu.edu.hk/?page=admin
http://www.comp.hkbu.edu.hk/?page=research_staff
http://www.comp.hkbu.edu.hk/?page=pg_students
http://www.comp.hkbu.edu.hk/?page=research_areas 
http://www.comp.hkbu.edu.hk/?page=centres
http://www.comp.hkbu.edu.hk/?page=funded_projects 
http://www.comp.hkbu.edu.hk/?page=journal_editorship
http://www.comp.hkbu.edu.hk/?page=technical_reports
http://www.comp.hkbu.edu.hk/?pid=32
http://www.comp.hkbu.edu.hk/?page=4_prospective_stud_ug_prog
http://www.comp.hkbu.edu.hk/?page=4_prospective_stud_ug_prog_nj
http://www.comp.hkbu.edu.hk/?page=prospective_stud_pg
http://www.comp.hkbu.edu.hk/?page=mscais
http://www.comp.hkbu.edu.hk/?page=mscitm
http://www.comp.hkbu.edu.hk/?page=current_stud_ug
http://www.comp.hkbu.edu.hk/?page=current_stud_pg 
http://www.comp.hkbu.edu.hk/?pid=273
http://www.comp.hkbu.edu.hk/?pid=95
http://www.comp.hkbu.edu.hk/?pid=128
http://www.comp.hkbu.edu.hk/?pid=174
http://www.comp.hkbu.edu.hk/?pid=175
http://www.comp.hkbu.edu.hk/?page=facilities_teaching
http://www.comp.hkbu.edu.hk/?page=facilities_research
http://www.comp.hkbu.edu.hk/msc/
http://www.comp.hkbu.edu.hk/?page=news
http://www.comp.hkbu.edu.hk/?page=events
http://www.comp.hkbu.edu.hk/?pid=14
http://www.comp.hkbu.edu.hk/?page=highlights
http://www.comp.hkbu.edu.hk/?pid=16
http://www.comp.hkbu.edu.hk/outreach/
http://www.comp.hkbu.edu.hk/?page=std_ach&id=128
http://www.comp.hkbu.edu.hk/?page=news&id=446
http://www.comp.hkbu.edu.hk/general/video_html/intro_eng.php?time=0
http://www.comp.hkbu.edu.hk/#
http://www.comp.hkbu.edu.hk/?page=highlights&id=220
http://www.comp.hkbu.edu.hk/?page=highlights&id=201
http://www.comp.hkbu.edu.hk/?page=highlights&id=212
http://www.comp.hkbu.edu.hk/?page=dept_events&id=201
http://www.comp.hkbu.edu.hk/?page=seminars&id=540
http://www.comp.hkbu.edu.hk/?page=seminars&id=539
http://www.hkbu.edu.hk/eng/about/privacy.jsp
```


