require('./underscore-min.js');
var http = require('http');

var serverFunc = function(req,res) {
  res.writeHead(200);
  res.end('Hellooo');
}

http.createServer(serverFunc).listen(8080);
 
 var options = {
   host: 'www.google.com',
     port: 80,
       path: '/index.html'
       };
       
       http.get(options, function(res) {
         console.log("Got response: " + res.statusCode);
         }).on('error', function(e) {
           console.log("Got error: " + e.message);
           });   