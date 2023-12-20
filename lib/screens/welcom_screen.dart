import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkhands/screens/signup_page.dart';
import 'package:talkhands/screens/home_screen.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:talkhands/theme/usertheme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // here listen= false means when the state in auth provider gets changes and notify listner is called then here widget state will not rebuild
    // if listen = true then on state change widget is rebuild
    final ap = Provider.of<AuthProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset('images/signup_bottom.png'),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            'images/signup_bottom.png',
            width: size.width * 0.25,
          ),
        ),
        Container(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 200,
                child: SvgPicture.asset(
                  'images/signup.svg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                child: const Center(
                  child: Text(
                    "Let's get started",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                child: const Center(
                  child: Text(
                    "Never a better time than now to start.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                      backgroundColor: AppTheme.primarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      )),
                  onPressed: () async {
                    print(ap.isSignedIn);

                    if (ap.isSignedIn == true) {
                      // when true, fetch shared preferences data
                      await ap.getDataFromSP().whenComplete(
                            () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            ),
                          );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('Get started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
