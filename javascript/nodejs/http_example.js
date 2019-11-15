var http = require('http');
var console = require('sys');

http.createServer(function(req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end("Hello world!\n");
}).listen(8888, '127.0.0.1');

console.log("Server running at http://127.0.0.1:8888");
