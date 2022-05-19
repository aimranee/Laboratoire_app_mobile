import 'dart:developer';
import 'package:laboratoire_app/Screen/Login_SignUp.dart';
import 'package:laboratoire_app/Screen/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginSignupScreen();
          }
        });
  }

  static Future<bool> signOut() async {
    bool isConn = true;

    await FirebaseAuth.instance.signOut().then((v) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.clear();
      pref.setString("fcm", "");
      isConn = false;
    }).catchError((e) {
      log(e); //Invalid otp
      isConn = true;
    });
    
    return isConn;
  }

  //SignIn

  static Future<bool> signIn(String email, String password) async {
    bool isLoggedIn = false;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      isLoggedIn = true;
    } on FirebaseAuthException catch (e) {
      isLoggedIn = false;
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
    return isLoggedIn;
  }

}
