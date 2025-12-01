# Autumn_frame_example
## 快速开始
使用moonb工具创建一个moonbit项目
```bash
moon new hello_world

cd hello_world
```
用的是如果你是使用vistual studio code进行开发的话可以使用
```bash
code .
```
进入你的项目
再使用
```bash
moon update
```
更新的项目
然后添加Autumn_frame
```bash
moon add PingGuoMiaoMiao/Autumn_frame@0.1.0
```
因为本项目的sql连接主体是使用moonbit 外部函数接口 (FFI)外接了一个c语言后端实现的所以
在项目根目录中寻找到moon.mod.json,在最后位置加入
```json
"preferred-target": "native"
```
使他默认加载后端为native(注意这个的意思是加载本地的的后端)
上面的也有代替方法
在vistual studio code里按下F1会出现一个
```
>
```
我们可以输入moonbit 
选择moonbit: select backend 
一般有四个选项,"native","js","wasm-gc","wasm"
选择native
现在到如何配置本地后端
可以参考我的
```bash
 "link": {
    "native": {
      "cc": "/usr/bin/gcc",
      "cc-flags": "-fwrapv -fno-strict-aliasing",
      "cc-link-flags": "-lsqlite3 -lmysqlclient -lpq"
    }
  },
```
第一个cc 选项用于指定用于编译 moonc 生成的 C 源文件的编译器。它可以是编译器的完整路径，也可以是通过 PATH 环境变量可访问的简单名称
第二个cc-flags 选项用于覆盖传递给编译器的默认标志。例如，您可以使用以下标志来定义一个名为 MOONBIT 的宏。
第三个cc-link-flags 选项用于覆盖传递给链接器的默认标志。由于链接器是通过编译器驱动程序调用的（例如，通过 cc 而不是 ld，通过 cl 而不是 link），因此在传递特定选项时，应该使用 -Wl, 或 /link 前缀。
如果没看懂可以参考https://docs.moonbitlang.cn/language/ffi.html https://docs.moonbitlang.cn/toolchain/moon/package.html#native-backend-link-options 

然后我们需要放一个http_server.o文件在你的cmd/main文件里,这个本身要在Autumn_frame用c编译出来的,嫌麻烦可以直接用
在我们的main.mbt里加入
```moonbit
///|
fn main {
  // 1. 初始化配置与 IoC 容器
  let config = [("server.port", "8081"), ("app.name", "Autumn_frame_Hello")]
  let _ctx = @ApplicationContext.ApplicationContext::new(config, "demo")

  // 2. 定义 HTML 控制器
  let hello_controller = @Controller.Controller::new("/hello").get("/", fn(
    _req : @Http.HttpRequest,
  ) {
    let html = "<!DOCTYPE html>\n" +
      "<html lang=\"zh-CN\">\n" +
      "<head>\n" +
      "  <meta charset=\"utf-8\" />\n" +
      "  <title>Hello Autumn_frame</title>\n" +
      "</head>\n" +
      "<body>\n" +
      "  <h1>Autumn_frame Hello&#128562;!</h1>\n" +
      "</body>\n" +
      "</html>\n"
    @Http.HttpResponse::ok(html).set_header(
      "Content-Type", "text/html; charset=utf-8",
    )
  })
  // 3. 注册控制器并启动服务器
  let dispatcher = @Dispatcher.DispatcherServlet::new().register_controller(
    "helloHtmlController", hello_controller,
  )
  println("Autumn_frame 启动中: http://localhost:8081/hello")
  @Boot.BootApplication::run(8081, fn() { dispatcher })
}
```
然后我可以运行这简单的web程序
```bash
moon run cmd/main
```
会出现一个这个
```bash
Autumn_frame_example main  ❯ moon run cmd/main
Autumn_frame 启动中: http://localhost:8081/hello
[Boot] Starting Autumn Boot application...
[Server] Starting embedded server on port 8081
[C] Server socket created successfully on port 8081
[Server] ✅ Server is running at http://localhost:8081
[Server] Press Ctrl+C to stop the server
```

我使用ctrl + 鼠标点击,可以进入http://localhost:8081/hello
可以看到

目前支持数据库操作但是还在试验阶段,但是市面上的流行数据库都正在做适配,例如sqllite,mysql,porgressql,等等,具体的连接方式也是使用了FFI经行连接,需要编写对应的sql连接的c文件并且编译

本项目因实现过于"抽象",希望诸位大佬可以当笑料就好