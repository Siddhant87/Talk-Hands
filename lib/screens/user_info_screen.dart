import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkhands/auth_provider.dart';
import 'package:talkhands/screens/home_screen.dart';
import 'package:talkhands/modal/user_model.dart';
import 'package:talkhands/theme/usertheme.dart';
import 'package:talkhands/utils/utils.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  Widget textfield(
      {required String hintText,
      required IconData icon,
      required TextInputType inputType,
      required int maxLine,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: AppTheme.secondarycolor,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLine,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppTheme.primarycolor,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              )),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
      ),
    );
  }

  //store data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "");
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          //once data is saved we need to store it locally also
          ap
              .saveUserDataToSP()
              .then((value) => ap.setSignIn().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ))));
        },
      );
    } else {
      showSnackBar(context, "Please upload your profile");
    }
  }

//for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'User Information',
          style: AppTheme.heading1,
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
                InkWell(
                  onTap: () {
                    selectImage();
                  },
                  child: image == null
                      ? CircleAvatar(
                          backgroundColor: AppTheme.secondarycolor,
                          radius: 50,
                          child: const Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 50,
                        ),
                ),
                Container(
                  width: size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      //name field
                      textfield(
                        hintText: 'John Smith',
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLine: 1,
                        controller: nameController,
                      ),

                      //email
                      textfield(
                        hintText: 'abc@gmail.com',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLine: 1,
                        controller: emailController,
                      ),

                      //bio
                      textfield(
                        hintText: 'Enter your bio here...',
                        icon: Icons.edit,
                        inputType: TextInputType.name,
                        maxLine: 2,
                        controller: bioController,
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
                            storeData();
                          },
                          child: const Text('Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
