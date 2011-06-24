class Hello {
  static function main() {
    trace("Hello world!");
    js.Lib.alert(js.Lib.window.location.href);

    var w = js.Lib.window;
    w.status = "Steven Shaw was here";

    js.Lib.document.onclick = function(e) {
      w.status = "Clicked";
    }
  }
}
