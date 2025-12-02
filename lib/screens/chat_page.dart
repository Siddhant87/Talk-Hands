import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkhands/modal/msg_model.dart';
import 'package:talkhands/screens/gif_page.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:talkhands/utils/utils.dart';
import 'package:talkhands/widgets/fetch_gesture_dialog.dart';
import 'package:talkhands/widgets/other_msg_widget.dart';
import 'package:talkhands/widgets/own_msg_widget.dart';
import 'package:talkhands/widgets/text_to_speech.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String userId;
  final String wearDevice;

  const ChatPage(
      {super.key,
      required this.username,
      required this.wearDevice,
      required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _msgController = TextEditingController();
  final List<MsgModel> listMsg = [];
  final ScrollController _scrollController = ScrollController();

  late IO.Socket socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (socket.connected) {
      socket.disconnect();
    }
    // _subscription?.cancel();
    super.dispose();
  }

  void connect() {
    //Don't forget to add changes in adroid manifest line
    // add this line -android:usesCleartextTraffic="true"

    socket = IO.io("http://192.168.1.4:3000", <String, dynamic>{
      // for local host
      //socket = IO.io("https://valuable-lime-navy.glitch.me", <String, dynamic>{
      //for glitch host

      'transports': ["websocket"],
      "autoConnect": false,
    });

    socket.connect();

    Future.delayed(const Duration(seconds: 3), () {
      print("server connected = ${socket.connected}");
      if (socket.connected == false) {
        showSnackBar(context, "Error connecting to Server");
      } else {
        showSnackBar(context, "Connected to Server");
      }
    });

    socket.onConnect((_) {
      print("frontend connected");
      socket.on("sendMsgServer", (msg) {
        if (mounted) {
          List<MsgModel> tempList = List.from(listMsg);

          print(listMsg);
          print("----------------------------------- ${listMsg.length} ");

          print("$msg------- ${listMsg.length}");

          if (msg["userId"] != widget.userId) {
            tempList.add(MsgModel(
                type: msg["type"], msg: msg["msg"], sender: msg["senderName"]));
            setState(() {
              listMsg.clear();
              listMsg.addAll(tempList);
            });

            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        }
      });
    });
  }

  void sendMessage(String msg, String senderName) {
    MsgModel ownMsg = MsgModel(type: "ownMsg", msg: msg, sender: senderName);
    listMsg.add(ownMsg);
    if (mounted) {
      setState(() {});
    }
    socket.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": senderName,
      "userId": widget.userId,
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  final DatabaseReference _messagesRef = FirebaseDatabase.instance
      .ref(); //Returns a [DatabaseReference] representing the location in the Database corresponding to the provided path. If no path is provided, the Reference will point to the root of the Database.

  StreamSubscription<DatabaseEvent>? _subscription;
  var data;
  void _fetchMessages() async {
    DataSnapshot dataSnapshot = await _messagesRef.get();
    data = dataSnapshot.value;
    if (data != null) {
      sendMessage(data['Prediction'], widget.username);
      print(listMsg.length);
      print(data);
      _subscription?.cancel();
    } else {
      print('No data available or data is not in the expected format.');
    }

    //tested for writing the data in realtime database
    // DatabaseReference ref = FirebaseDatabase.instance.ref();
    // await ref.set({
    //   "name": "John",
    //   "age": 18,
    //   "address": {"line1": "100 Mountain View"}
    // });
  }

  void _showFetchGestureDialog() {
    FetchGestureDialog(
      context: context,
      onCountdownComplete: _fetchMessages,
    ).show();
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
          Expanded(
              child: Container(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 80),
                      controller: _scrollController,
                      itemCount: listMsg.length,
                      itemBuilder: (context, index) {
                        if (listMsg[index].type == "ownMsg") {
                          return OwnMsgWidget(
                              msg: listMsg[index].msg,
                              sender: listMsg[index].sender);
                        } else {
                          return OtherMsgWidget(
                              msg: listMsg[index].msg,
                              sender: listMsg[index].sender);
                        }
                      }))),
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
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.gif, size: 40),
                            onPressed: () async {
                              //API key from giphy website- https://developers.giphy.com/dashboard/
                              String? gifUrl = await GiphyPicker.show(
                                  context, "2rg3CMo2i92XxWNManZXOmtmNovyqpJt");

                              if (gifUrl != null) {
                                sendMessage(gifUrl, widget.username);
                                // your WebSocket send function
                              }
                            },
                          ),
                          if (widget.wearDevice == 'YES')
                            Tooltip(
                              message: 'Fetch gesture',
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.teal.shade500,
                                ),
                                child: IconButton(
                                    onPressed: _showFetchGestureDialog,
                                    icon: const Icon(
                                      Icons.download_for_offline_outlined,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          Tooltip(
                            message: 'Send Message',
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.teal.shade500,
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      sendMessage(
                                          _msgController.text, widget.username);
                                      _msgController.clear();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ],
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
