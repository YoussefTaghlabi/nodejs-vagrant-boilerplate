var http = require("http"),
    mongoose = require("mongoose"),
    server
;

server = http.createServer(function (req, res) {
    res.writeHead(200, {"Content-Type": "text/plain"});
    res.end("Coming Soon!\n");
});

server.listen(process.env.PORT || "3000");

console.log("Server running on port " + (process.env.PORT || "3000") );