import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:talkhands/chat_page.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:talkhands/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Talk Hands',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      endDrawer: appDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: AppTheme.secondarycolor,
              backgroundImage: NetworkImage(ap.usermodel.profilePic),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(ap.usermodel.name),
            Text(ap.usermodel.phoneNumber),
            Text(ap.usermodel.email),
            Text(ap.usermodel.bio),
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
                    backgroundColor: AppTheme.primarycolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    )),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(username: ap.usermodel.name)));
                },
                child: const Text('Initiate Group Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
