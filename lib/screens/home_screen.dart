import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:talkhands/screens/chat_page.dart';
import 'package:talkhands/screens/aa.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:talkhands/widgets/app_drawer.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: size.width * 0.3,
            child: Image.asset('images/otp_top.png'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            width: size.width * 0.4,
            child: Image.asset('images/otp_bottom.png'),
          ),
          Column(
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
              Text("Wears Device : ${ap.usermodel.wearDevice}"),
              const SizedBox(height: 40),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
                      backgroundColor: AppTheme.primarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      )),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => //aaPage(),
                              ChatPage(
                                  username: ap.usermodel.name,
                                  wearDevice: ap.usermodel.wearDevice,
                                  // wearDevice: ap.usermodel.wearDevice,
                                  userId: uuid.v1()),
                        ));
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
        ],
      ),
    );
  }
}
