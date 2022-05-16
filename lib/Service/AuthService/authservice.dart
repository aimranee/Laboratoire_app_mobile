import 'package:laboratoire_app/Screen/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laboratoire_app/Screen/Login_SignUp.dart';
import 'package:laboratoire_app/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  //Handles Auth
  handleAuth(back) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return LoginSignupScreen(back: back);
          }
        });
  }

  static Future<bool> signOut() async {
    bool isConn = true;

    bool isOut = await AuthService.signOut();
    if (isOut) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      ToastMsg.showToastMsg("Logged Out");
      isConn = false;
    }
    return isConn;
  }


  //SignIn

  static Future<bool> signIn(String email, String password) async {
    bool isLoggedIn = false;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isLoggedIn = true;
    } on FirebaseAuthException catch (e) {
      isLoggedIn = false;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return isLoggedIn;
  }

}
