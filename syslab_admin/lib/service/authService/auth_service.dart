import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/config.dart';
// import 'package:syslab_admin/screens/homePage.dart';
// import 'package:syslab_admin/screens/loginPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const _login = "$apiUrl/login";

  static Future<bool> signOut() async {
    bool isConn = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    isConn = false;
    
    return isConn;
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
