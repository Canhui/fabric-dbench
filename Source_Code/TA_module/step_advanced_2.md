## 1. Java写文件

#### 1.1. 基本写文件操作

下面我们通过BufferedWriter实现写文件功能如下：其一，如果一个文件不存在，则创建在执行目录下创建一个文件，并执行写文件操作；如果一个文件存在，则打开该文件，并执行添加内容到文件操作。

测试代码如下，
```java
// File appender
public static void FileWriter(String file, String content) {
    BufferedWriter out = null;
    try {
        out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true))); 
            out.write(content); 
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            out.close();
        }catch(IOException e) {
            e.printStackTrace();
        }
    }
}
    
// Main function
public static void main(String[] args) {
    FileWriter("E:\\eclipse-workspace\\SearchEngine_v2\\src\\main\\resources\\storage\\1","data");
}
```

该成功运行之后。如果目录"E:\\eclipse-workspace\\SearchEngine_v2\\src\\main\\resources\\storage"下面没有文件"1"，则程序创建文件"1"，并往文件"1"中写入内容"data"；如果目录"E:\\eclipse-workspace\\SearchEngine_v2\\src\\main\\resources\\storage"下面存在文件"1"，则程序打开已有文件"1"，并添加内容"data"到文件末尾。


#### 1.2. 散列函数存储

我们对内容计算散列值，然后根据散列值决定内容存放到哪一个文件。代码如下，

```java
package hk.edu.hkbu.comp.controller;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

public class extractData {
    
    // File appender
    public static void FileWriter(String file, String content) {
        BufferedWriter out = null;
        try {
            out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true))); 
            out.write(content); 
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                out.close();
            }catch(IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Main function
    public static void main(String[] args) {
        int STORAGEFILES = 10;
        
        String msg1 = "word";
        String msg2 = "hello";
        
        System.out.println("hashCode of msg1 is " + msg1.hashCode());
        System.out.println("hashCode of msg2 is " + msg2.hashCode());
        
        System.out.println("location of msg1 is " + Math.abs(msg1.hashCode())%STORAGEFILES);
        System.out.println("location of msg2 is " + Math.abs(msg2.hashCode())%STORAGEFILES);
        
        FileWriter("E:\\eclipse-workspace\\SearchEngine_v2\\src\\main\\resources\\storage\\"+Math.abs(msg1.hashCode())%STORAGEFILES, msg1);
        FileWriter("E:\\eclipse-workspace\\SearchEngine_v2\\src\\main\\resources\\storage\\"+Math.abs(msg2.hashCode())%STORAGEFILES, msg2);
    }

}
```


