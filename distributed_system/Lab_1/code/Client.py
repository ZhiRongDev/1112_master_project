import socket
import sys

host = "127.0.0.1"
port = 20213
msg = b"This is a test from python client"

s = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

s.connect((host, port))
s.send(msg)

while 1:
    buf = s.recv(1024)
    buf = buf.decode('utf-8')
    print(buf)
    break

s.close()