/**
 * Static HTTP Server
 *
 * Create a static file server instance to serve files
 * and folder in the './public' folder
 * https://www.kevinleary.net/simple-node-static-server/
 */

// modules
var static = require('node-static'),
    port = 8080,
    http = require('http');

// config
var file = new static.Server('../dist', {
    cache: 3,
    gzip: false
});

const open = require('open');
open('http://localhost:8080/ld46.html');

// serve
http.createServer(function (request, response) {
    request.addListener('end', function () {
        file.serve(request, response);
    }).resume();
}).listen(port);
