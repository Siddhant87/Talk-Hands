import 'package:flutter/material.dart';
import 'dart:async';

class GestureDialog extends StatefulWidget {
  final VoidCallback onCountdownComplete;

  GestureDialog({required this.onCountdownComplete});

  @override
  _GestureDialogState createState() => _GestureDialogState();
}

class _GestureDialogState extends State<GestureDialog> {
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        widget.onCountdownComplete();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Perform a Gesture'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('$_countdown seconds remaining'),
        ],
      ),
    );
  }
}

class FetchGestureDialog {
  final BuildContext context;
  final VoidCallback onCountdownComplete;

  FetchGestureDialog(
      {required this.context, required this.onCountdownComplete});

  void show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDialog(
          onCountdownComplete: () {
            Navigator.of(context).pop();
            onCountdownComplete();
          },
        );
      },
    );
  }
}
