import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talkhands/screens/otp_page.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:talkhands/utils/utils.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool iscircle = false;
  String _name = "", _phone = "";
  static String verifyId = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  sendotp(context) async {
    setState(() {
      iscircle = true;
      //print(iscircle);
    });
    // Adding a delay to allow the UI to update
    await Future.delayed(const Duration(seconds: 1));
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: '+91$_phone',
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          showSnackBar(context, error.message.toString());
          throw Exception(error.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          // print('+91${_phone}');
          verifyId = verificationId;

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    otp_page(name: _name, phone: _phone, verifyId: verifyId),
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        iscircle = false;
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      setState(() {
        iscircle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Sign up',
          style: AppTheme.heading1,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child:
                (iscircle == true) ? circularprogressindicator(context) : null,
          ),
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
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                  child: const Center(
                    child: Text(
                      'Use your phone number to create an account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "Provide a name";
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'abc',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppTheme.primarycolor,
                                ),
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onSaved: (input) => _name = input!,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              validator: (input) {
                                if (input!.isEmpty || input.length != 10) {
                                  return 'Provide Phone number';
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: '9999999999',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: AppTheme.primarycolor,
                                  ),
                                  labelText: 'Phone number',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0))),
                              onSaved: (input) => _phone = input!,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(
                                      100.0, 20.0, 100.0, 20.0),
                                  backgroundColor: AppTheme.primarycolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  )),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  sendotp(context);
                                }
                              },
                              child: const Text('Get OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  )),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
