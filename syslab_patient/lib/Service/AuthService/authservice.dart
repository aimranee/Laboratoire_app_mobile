import 'dart:convert';
import 'package:patient/config.dart';
import 'package:patient/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class AuthService {

  static const _login = "$apiUrl/login";
  static const _signupUrl = "$apiUrl/signup";

  // //Handles Auth
  // handleAuth() {
  //   return StreamBuilder(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (BuildContext context, snapshot) {
  //         if (snapshot.hasData) {
  //           return const HomeScreen();
  //         } else {
  //           return const LoginSignupScreen();
  //         }
  //       });
  // }

  static Future<bool> signOut() async {
    bool isConn = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    isConn = false;
    
    return isConn;
  }

  //SignIn

  // static Future<bool> signIn(String email, String password) async {
  //   bool isLoggedIn = false;
  //   try {

  //     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  //     isLoggedIn = true;
  //   } on FirebaseAuthException catch (e) {
  //     isLoggedIn = false;
  //     if (e.code == 'user-not-found') {
  //       log('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       log('Wrong password provided for that user.');
  //     }
  //   }
  //   return isLoggedIn;
  // }

  static login(email, password) async {
    final res =
        await http.post(Uri.parse(_login), body: {
          "email": email,
          "password": password
        });
       final data = json.decode(res.body);
    if (res.statusCode == 200) {
      return data;
    } else {
      return "error";
    }
  }

    static signup(UserModel userModel) async {

    final res = await http.post(Uri.parse(_signupUrl), body: userModel.toJsonAdd());
     final data = json.decode(res.body);
    if (res.statusCode == 200) {
      return data;
    } else {
      return "error";
    }

  }

}
  
