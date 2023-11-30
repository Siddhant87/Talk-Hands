import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talkhands/SignupPage.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:talkhands/home_screen.dart';
import 'package:talkhands/theme/usertheme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

@override
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToHomeScreen();
    });
  }

  _navigateToHomeScreen() {
    // here listen= false means when the state in auth provider gets changes and notify listner is called then here widget state will not rebuild
    // if listen = true then on state change widget is rebuild
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    print(authprovider.isSignedIn);
    authprovider.isSignedIn == true // when true, fetch shared preferences data
        ? Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => const HomeScreen(),
              // pageBuilder: (context, _, __) => HomePage(),
            ),
          )
        : Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => const SignupPage(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          margin: const EdgeInsets.only(bottom: 150.0),
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: size.width,
                height: size.height * 0.5,
                child: Image.asset(
                  "images/logo.jpg",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Text(
                'TalkHands',
                style: GoogleFonts.sacramento(
                    textStyle: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primarycolor,
                )),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'YOUR \nCOMPANION',
                style: TextStyle(
                  color: AppTheme.primarycolor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          height: 50,
          width: size.width,
          child: Center(
            child: Text(
              "MADE IN INDIA",
              style: TextStyle(
                color: AppTheme.primarycolor,
                fontSize: 18.0,
              ),
            ),
          ),
        ));
  }
}
