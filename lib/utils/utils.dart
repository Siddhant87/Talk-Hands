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

circularprogressindicator(context) {
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

Widget appDrawer(BuildContext context) {
  final ap = Provider.of<AuthProvider>(context, listen: false);
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              color: AppTheme.primarycolor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              )),
          accountName: Text(
            ap.usermodel.name,
            style: AppTheme.heading1,
          ),
          accountEmail: Text(
            ap.usermodel.email,
            style: AppTheme.subheading,
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: NetworkImage(ap.usermodel.profilePic),
            radius: 50,
          ),
        ),
        ListTile(
          splashColor: Colors.grey,
          leading: const Icon(Icons.phone),
          title: Text(ap.usermodel.phoneNumber),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          splashColor: Colors.grey,
          leading: const Icon(Icons.book),
          title: Text(ap.usermodel.bio),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const AboutListTile(
          icon: Icon(Icons.info),
          applicationIcon: Icon(Icons.local_play),
          applicationName: 'Talk Hands',
          applicationVersion: '1.0.0',
          applicationLegalese: '© 2023 Company',
          child: Text('About App'),
        ),
        const SizedBox(height: 40),
        ListTile(
          splashColor: Colors.grey,
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
                content: const Text('Are you sure you want to logout !!'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('YES'),
                        onPressed: () {
                          ap.userSignOut().then(
                                (value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignupPage()),
                                  (route) => false,
                                ),
                              );
                        },
                      ),
                      const SizedBox(width: 50),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('NO'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );

            //Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
