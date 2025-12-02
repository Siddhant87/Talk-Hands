import 'package:flutter_tts/flutter_tts.dart';

class MessageSpeaker {
  static late FlutterTts flutterTts = FlutterTts();

  static Future<void> speakMessage(String message) async {
    await flutterTts.setVolume(1.0); // 0.0 - 1.0
    await flutterTts.setSpeechRate(0.5); // 0.0 - 1.0
    await flutterTts.setPitch(1.0); //0.5 - 2.0

    if (message != null) {
      if (message.isNotEmpty) {
        await flutterTts.speak(message);
      }
    }
  }
}
