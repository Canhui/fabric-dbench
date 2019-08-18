## 6. Change Source Code of the Spring Boot Project

**步骤1.** 添加下面两个dependencies到pom.xml文件中
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
</dependency>
```


**步骤2.** /src/main/java下新建hk.edu.hkbu.comp.controller压缩文件夹。然后，hk.edu.hkbu.comp.controller压缩文件夹下新建MyController.java文件，内容如下，

```java
package hk.edu.hkbu.comp.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyController {
    @GetMapping("**")
    @ResponseBody
    String load(HttpServletRequest request) {
        return String.format("You are browsing %s",
            request.getRequestURI(), request.getQueryString());
    }
}
```

**步骤3.** 右键项目 -> "Run As" -> "Spring Boot App"


**步骤4.** 浏览器中输入"http://localhost:8080/xyz/hello.html" 或者 "http://localhost:8080/"

Congratulations! Your first web service now is up and running.


The load() method of the `MyParserCallback` class performs the following tasks:
a. Create a file object using the request URL.
b. If the file object refers to a directory, create a new file object refers to the index.html file under the path.
c. Read the file content and store in the variable `response`.
d. If the file does not exist or there is any I/O exception, assign an error message to the variable `response` instead.
e. Return the variable `response`.


**步骤3.** 增加greeting函数，丰富代码功能，如下，
```java
package hk.edu.hkbu.comp.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyController {
    @GetMapping("**")
    @ResponseBody
    String load(HttpServletRequest request) {
        return String.format("You are browsing %s with %s",
            request.getRequestURI(), request.getQueryString());
    }
    
    
    @GetMapping("greeting")
    @ResponseBody
    String sayHello(
        @RequestParam(name = "name", required = false, defaultValue = "there") 
        String name) {
        return "<h1>Hello " + name + "!</h1>";
    }

}
```

访问如下，
```
http://localhost:8080/
http://localhost:8080/greeting
http://localhost:8080/greeting?name=Bob
```