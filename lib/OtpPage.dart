import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:talkhands/user_info_screen.dart';
import 'package:talkhands/utils/utils.dart';

class otp_page extends StatefulWidget {
  const otp_page(
      {super.key,
      required this.name,
      required this.phone,
      required this.verifyId});

  final String name, phone, verifyId;

  @override
  State<otp_page> createState() => _otp_pageState();
}

class _otp_pageState extends State<otp_page> {
  bool iscircle = false;
  String? _userOtp;
  String? ch1, ch2, ch3, ch4, ch5, ch6;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  verifyOtp(context, String userOtp) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    // print(widget.verifyId);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verifyId,
      userOtp: userOtp,
      onsuccess: () {
        ap.checkExistingUser().then((value) async {
          //print(value);
          if (value == true) {
            //user exist
          } else {
            //new user
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserInfoScreen(),
                ));
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => UserInfoScreen()),
            //     (route) => false);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.verifyId);

    Size size = MediaQuery.of(context).size;
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'OTP',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child:
                (isLoading == true) ? circularprogressindicator(context) : null,
          ),
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
          Container(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 200,
                  child: SvgPicture.asset(
                    'images/otp.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'The OTP has been sent to the phone number +91 ${widget.phone}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 60,
                                width: 48,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                      ch1 = value;
                                    } else {
                                      ch1 = '';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              //const SizedBox(width: 5),
                              SizedBox(
                                height: 60,
                                width: 48,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                      ch2 = value;
                                    } else {
                                      FocusScope.of(context).previousFocus();
                                      ch2 = '';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 60,
                                width: 48,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                      ch3 = value;
                                    } else {
                                      FocusScope.of(context).previousFocus();
                                      ch3 = '';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 60,
                                width: 48,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                      ch4 = value;
                                    } else {
                                      FocusScope.of(context).previousFocus();
                                      ch4 = '';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 60,
                                width: 48,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                      ch5 = value;
                                    } else {
                                      FocusScope.of(context).previousFocus();
                                      ch5 = '';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 60,
                                width: 48,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      ch6 = value;
                                    } else {
                                      ch6 = '';
                                      FocusScope.of(context).previousFocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
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
                              _userOtp =
                                  ch1! + ch2! + ch3! + ch4! + ch5! + ch6!;
                              if (_userOtp!.length == 6) {
                                verifyOtp(context, _userOtp!);
                              } else {
                                showSnackBar(context, "Enter 6 digit OTP");
                              }
                            },
                            child: const Text('Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Didn't receive any code?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
