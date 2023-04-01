const server = require('fastify')();

let john = {
    name: "john",
    age: 18,
    attack: 100,
    defense: 100
};

let tom = {
    name: "tom",
    age: 19,
    attack: 105,
    defense: 90
};

let hogRiders = [john, tom];

server.get('/hogRider', function (req, res) {
    return hogRiders;
});

server.get('/hogRider/:name', function (req, res) {
    // 請依Lab說明寫作
});

server.post('/hogRider', function (req, res) {
    // 請依Lab說明寫作
});

server.put('/hogRider/:name', function (req, res) {
    // 請依Lab說明寫作
});


server.listen(3000, "127.0.0.1");
