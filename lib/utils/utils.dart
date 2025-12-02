import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:talkhands/screens/signup_page.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:talkhands/theme/usertheme.dart';

showSnackBar(BuildContext context, String content) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Widget circularprogressindicator(context) {
  return Container(
    color: Colors.black.withOpacity(0.2),
    child: const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    ),
  );
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}
