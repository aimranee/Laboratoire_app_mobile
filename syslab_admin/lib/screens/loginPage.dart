// import 'package:syslab_admin/service/drProfileService.dart';
import 'dart:developer';

import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/service/authService/authService.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isEmailVerificationSend = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF01beb2),
              Color(0xFF04A99E),
            ],
          )),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _adminImage(),
                const Text(
                  "Admin App",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 20.0,
                      color: Colors.white),
                ),
                _cardContent(),
                _isLoading?  Container() : passwordResetBtn()
              ],
            ),
          ))),
    );
  }

  Widget passwordResetBtn() {
    return TextButton(
        onPressed: _isEmailVerificationSend
            ? null
            : () async {
                if (_userIdController.text.contains("@")) {
                  setState(() {
                    _isEmailVerificationSend = true;
                  });
                  ToastMsg.showToastMsg("Sending");
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _userIdController.text)
                        .then((value) {
                      log("link sent");
                      setState(() {
                        _isEmailVerificationSend = false;
                        ToastMsg.showToastMsg(
                            "verification link has been sent to ${_userIdController.text} ");
                      });
                    });
                  } on FirebaseAuthException catch (e) {
                    ToastMsg.showToastMsg(e.message);
                    setState(() {
                      _isEmailVerificationSend = false;
                    });
                  }
                } 
                // else
                //   ToastMsg.showToastMsg("Enter a valid email");
              },
        child: const Text("Forget or Reset Password",
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
              color: Colors.white,
            )));
  }

  Widget _userIdField() {
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TextFormField(
        cursorColor: primaryColor,
        controller: _userIdController,
        validator: (item) {
          Pattern pattern =r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
          
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(item) || item == null) {
            return 'Enter a valid email address';
          } else {
            return null;
          }
          // return item.contains('@')  null : "Enter correct email";
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person,
            ),
            labelText: "User email",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TextFormField(
        cursorColor: primaryColor,
        obscureText: true,
        controller: _passwordController,
        validator: (item) {
          return item.isNotEmpty ? null : "Enter password";
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock,
            ),
            labelText: "Password",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  Widget _adminImage() {
    return Image.asset(
      "assets/images/image1.png",
      height: 100,
      fit: BoxFit.fill,
    );
  }

  Widget _cardContent() {
    return Container(
      decoration:
          const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 250,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _userIdField(),
                _passwordField(),
                _isLoading?
                     Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadingIndicatorWidget(),
                      )
                    : _loginBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return LoginButtonsWidget(
      onPressed: _handleLogIn,
      title: "Login",
    );
  }

  void _handleLogIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      final res = await AuthService.signIn(
          _userIdController.text, _passwordController.text);
      if (res) {
        final FirebaseAuth auth = FirebaseAuth.instance;
      //  await setData(auth.currentUser.uid);
        ToastMsg.showToastMsg("Logged in");
      } 
      else {
        
        ToastMsg.showToastMsg("Smoothing went wrong");
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
  //
  // setData(uId) async {
  //   final fcm = await FirebaseMessaging.instance.getToken();
  //   await DrProfileService.updateFcmId(uId, fcm);
  // }
}
