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


