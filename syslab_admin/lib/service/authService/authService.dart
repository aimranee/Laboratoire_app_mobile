import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syslab_admin/config.dart';
import 'package:syslab_admin/screens/homePage.dart';
import 'package:syslab_admin/screens/loginPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
    static const _login = "$apiUrl/login";

  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        }
    );
  }
  // handleAuth() async {
    
  //   //start loading indicator
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   final token = pref.getString("token").toString();
  //   // print(res);
  //   if (token != "" && token != "null") {
  //     String uId = pref.getString("uId");
  //     log("uId : "+uId);
  //     final user = await UserService.getData(uId);
      

  //     pref.setString("fcm", user[0].fcmId);
  //     pref.setString("firstName", user[0].firstName);
  //     pref.setString("lastName", user[0].lastName);
  //     return const HomePage();
  //   }else{
  //     return const LoginPage();
  //   }

  // }

  //Sign out
  static Future<bool> signOut() async {
    bool isSignOut = false;

    await FirebaseAuth.instance.signOut().then((v) {
      isSignOut = true;
    }).catchError((e) {
      print(e); //Invalid otp
      isSignOut = false;
    });

    return isSignOut;
  }

  //SignIn

  static signIn(email, password) async {
    final res =
        await http.post(Uri.parse(_login), body: {
          "email": email,
          "password": password
        });
       final data = json.decode(res.body);
    if (res.statusCode == 200) {
      return data;
    } else {
      log ("error");
      return ("error");
    }
    
    // return isLoggedIn;

  }

}
