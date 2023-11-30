import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkhands/modal/user_modal.dart';
import 'package:talkhands/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  bool _isSignedIn = false;

  bool get isSignedIn {
    return _isSignedIn;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  String? _uid;

  String get uid {
    return _uid!;
  }

  UserModel? _userModel;
  UserModel get usermodel {
    return _userModel!;
  }

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _isSignedIn = pref.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onsuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseauth.signInWithCredential(cred)).user!;

      if (user != null) {
        //carry out logic
        _uid = user.uid;
        onsuccess();
        //print(user.uid);
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());

      _isLoading = false;
      notifyListeners();
    }
    ;
  }

//Database operations
  Future<bool> checkExistingUser() async {
    print("CHECK EXISTING USER FUNC");
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    print(await _firebaseFirestore.collection("users").doc(_uid).get());
    if (snapshot.exists) {
      print("User exist");
      return true;
    } else {
      print("New user");
      return false;
    }
  }

  //save data to firebase
  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      //uploading image to firebase
      storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseauth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseauth.currentUser!.phoneNumber!;
      });
      _userModel = userModel;

      //uploading to database firebase
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    print(uploadTask.snapshot.ref.getDownloadURL());
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //storing data locally
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(usermodel.toMap()));
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseauth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
    //print('SIGN OUT');
  }
}
