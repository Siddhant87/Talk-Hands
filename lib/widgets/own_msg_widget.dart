import 'package:flutter/material.dart';
import 'package:talkhands/widgets/text_to_speech.dart';

class OwnMsgWidget extends StatelessWidget {
  final String sender;
  final String msg;
  const OwnMsgWidget({super.key, required this.msg, required this.sender});

  bool get isGif {
    return msg.toLowerCase().endsWith(".gif") ||
        msg.contains("giphy.com") ||
        msg.contains(".gif?");
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isGif)
              IconButton(
                  onPressed: () {
                    MessageSpeaker.speakMessage(msg);
                  },
                  icon: const Icon(
                    Icons.play_circle_fill,
                    size: 40,
                  )),
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.grey.shade800,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sender,
                        style: TextStyle(
                            color: Colors.purple.shade200,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      isGif
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                msg,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              msg,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
