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
