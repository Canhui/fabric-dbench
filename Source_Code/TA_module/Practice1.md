## 1. 新建Spring Boot项目

新建一个Spring Boot项目，配置依赖项，并运行Spring Boot。

<br />





## 2. 添加静态资料

#### 2.1. 新建目录

在`src/main/resources/static`下面新建文件index.html

```html
<html>
<head>
    <title>My Search Engine</title>
</head>
<body>
    <h1>My Search Engine v2</h1>
    <form action="load" method="GET">
        <p>Search: <input type="text" name="query" /> <input type="submit"/></p>
        </form>
    </form>
</body>
</html>
```

该index.html文件新建一个form表单——用于向服务器传输数据，调用服务器的"load"方法。





<br />

## 2. 新建Controller

#### 2.1. 新建目录

在`src/main/java`下面新建目录

#### 2.2. 添加Controller

@GetMapping annotation maps HTTP GET requests onto specific handler methods.

```java
package hk.edu.hkbu.comp.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyController {
    
    // A function to handle request.getQueryString()
    // and then return results
    
    // The response function
    @GetMapping("load")
    @ResponseBody
    String load(HttpServletRequest request) {
        return String.format("You are browsing %s with %s",
            request.getRequestURI(), request.getQueryString());
    }
    
}
```


<br />

## 3. Storage中准备数据
testdata数据文件如下，
```shell
web https://computer.howstuffworks.com/internet/basics/question226.htm
servers https://computer.howstuffworks.com/internet/basics/question226.htm
pages https://computer.howstuffworks.com/internet/basics/question226.htm
titles https://computer.howstuffworks.com/web-page.htm
icons https://computer.howstuffworks.com/web-page.htm
html https://computer.howstuffworks.com/web-page.htm
web https://computer.howstuffworks.com/web-page.htm
```

<br />

## 4. Controller中进行Search Keywords
MyController.java代码如下，

```java
package hk.edu.hkbu.comp.controller;

import java.io.BufferedReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyController {
    
    // A function to handle request.getQueryString(), and then return results
    public static ArrayList<String> search_Keywords_Localfiles(String keywords){
        // read local files
        ArrayList<String> array = new ArrayList<String>();
        ArrayList<String> returns = new ArrayList<String>();
        try(BufferedReader br = Files.newBufferedReader(Paths.get("E:\\\\eclipse-workspace\\\\SearchEngine_v2\\\\src\\\\main\\\\resources\\\\storage\\\\testdata"))){
            String line;
            while((line = br.readLine())!=null) {
                array.add(line);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // match keywords
        for(int i = 0; i < array.size(); i++) {
            String[] items = array.get(i).split(" ");
//          System.out.println(items[0]);
//          System.out.println(items[1]);
            if(items[0].contains(keywords)) {
                returns.add(items[1]);
            }
        }
        
        return returns;
    }
    
    // The response function
    @GetMapping("load")
    @ResponseBody
    String load(HttpServletRequest request) {
        String str = ((request.getQueryString()).replaceFirst("^query=*", "")).replace("+"," "); 
        
        return String.format("You are browsing %s with %s",
            request.getRequestURI(), search_Keywords_Localfiles(str));
    }
    
}
```







<br />

## 4. Controller向离线Storage中请求数据




