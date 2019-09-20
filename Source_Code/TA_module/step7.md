## 7. Ststic Search Engine

**步骤1.** 往`src/main/resources`中新建文件夹`static`。

**步骤2.** 往`static`文件夹下新建`index.html`，内容如下，
```html
<html>
<head>
    <title>My Search Engine</title>
</head>
<body>
    <h1>My Search Engine</h1>
    <form action="load" method="GET">
        <p>Search: <input type="text" name="query" /> <input type="submit"/></p>
        </form>
    </form>
</body>
</html>
```

**步骤3.** 修改MyController.java文件，如下，
```java
package hk.edu.hkbu.comp.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyController {
    @GetMapping("load")
    @ResponseBody
    String load(HttpServletRequest request) {
        return String.format("You are browsing %s with %s",
            request.getRequestURI(), request.getQueryString());
    }
}
```

**步骤4.** 测试如下，
```
http://localhost:8080/
```


<br />
<br />


## 参考资料
[1. 网易云课堂] https://study.163.com/course/courseLearn.htm?courseId=1005999004#/learn/video?lessonId=1053361078&courseId=1005999004


this is a test