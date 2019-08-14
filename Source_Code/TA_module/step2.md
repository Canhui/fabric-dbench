## 2. Retrive Text from Web Page

step2 is to retrive text from the web page. The `javax.swing.text.html.HTMLEditorKit` package provides a parser for parsing web pages. With the parser, we can download a web page that the HTML tags and the text of the target web page are separated.

#### 2.1. ParserCallback

The `ParserCallback` class provides the methods for handling the web content.

```example here

```






#### 2.2. Define a New ParserCallback

We can define a new `ParserCallback` class based on the original `ParserCallback` class. For example, the `handleText()` function is very useful for scraping the web content in the plain text format. So, we now define a new `ParserCallback` class and override the `hadleText()` method for outputting a plain text content of a target web page.

