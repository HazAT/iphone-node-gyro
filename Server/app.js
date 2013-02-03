var express = require('express'),
    http = require('http'),
    app = express(),
    server = http.createServer(app),
    io = require('socket.io').listen(server),
    path = require('path');

app.configure(function(){
  app.set('port', 3000);
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.static(path.join(__dirname, 'public')));
});

app.get('/', function (req, res) {
  res.sendfile('./public/index.html');
});

server.listen(app.get('port'));

io.sockets.on('connection', function (socket) {

  socket.on('move', function (data) {
    socket.broadcast.emit('move', data);
  });

});

console.log('Gyro Server running on, port: ' + app.get('port'));
