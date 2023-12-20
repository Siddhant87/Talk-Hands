import 'package:flutter/material.dart';
import 'package:talkhands/modal/msg_model.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:talkhands/utils/utils.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.username});

  final String username;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _msgController = TextEditingController();
  final List<MsgModel> listMsg = [];

  IO.Socket? socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }

  void connect() {
    //Don't forget to add changes in adroid manifest line
    // add this line -android:usesCleartextTraffic="true"
    socket = IO.io("http:// 192.168.56.1:3000", <String, dynamic>{
      "transport": ["websocket"],
      "autoconnect": false,
    });
    socket!.connect();
    var bool = socket!.connected;
    if (socket!.connected == false) {
      Future.delayed(const Duration(seconds: 1), () {
        showSnackBar(context, "Error connecting to server");
      });
    } else {
      showSnackBar(context, "Connected to server");
    }
    print("we are here = $bool");

    socket!.onConnect((_) {
      print("frontend connected");
      socket!.emit('sendMsg', 'test emit event');
    });

    socket!.onConnectError((data) {
      print("Connection Error: $data");
    });
  }

  void sendMessage(String msg, String senderName) {
    socket!.emit(
        'sendMsg', {"type": "ownMsg", " msg": msg, "senderName": senderName});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Anonymous Group',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Row(
              children: [
                Expanded(
                    child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _msgController,
                    cursorColor: AppTheme.secondarycolor,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          )),
                      hintText: 'Message...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      alignLabelWithHint: true,
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal.shade500,
                          // borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                sendMessage(
                                    _msgController.text, widget.username);
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
