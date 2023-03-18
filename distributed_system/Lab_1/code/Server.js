const dgram = require('dgram');
const server = dgram.createSocket('udp4');
server.bind(20213);

server.on('message', (msg, rinfo) => {
    console.log(`${msg}`);
    const message = Buffer.from(`${rinfo.port}:${msg}`);
    server.send(message, rinfo.port, 'localhost', (err) => {
        server.close();
    })
});
