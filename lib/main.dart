import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:talkhands/screens/splashscreen.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate();

    print(FirebaseAppCheck.instance.getToken());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
} //

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Talk Hands',
        theme: ThemeData(
          primaryColor: AppTheme.primarycolor,
        ),
        home: const SplashScreen(),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
