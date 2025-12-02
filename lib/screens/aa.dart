import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//socket testing demo page

class aaPage extends StatefulWidget {
  @override
  _aaPageState createState() => _aaPageState();
}

class _aaPageState extends State<aaPage> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    // Change the IP address and port to match your server
    socket = IO.io('http://192.168.1.101:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
    });
    print(socket.connected);

    socket.on('chat message', (msg) {
      print('Received message: $msg');
    });
  }

  void sendMessage(String message) {
    socket.emit('chat message', message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Flutter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                sendMessage('Hello from Flutter!');
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
