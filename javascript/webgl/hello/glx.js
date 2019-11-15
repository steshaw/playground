GLX = function() {
  var module = {};
  module.getWebGlContext = function(canvas) {
    function tryWebGlContext(contextName) {
      console.log("trying " + contextName);
      try {
        return canvas.getContext(contextName);
      } catch (e) {
        return null;
      }
    }
    return tryWebGlContext("webgl") || tryWebGlContext("experimental-webgl");
  }
  return module;
}();
