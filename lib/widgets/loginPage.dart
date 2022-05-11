import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laboratoire_app/utilities/colors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:laboratoire_app/Service/AuthService/authservice.dart';
import 'package:laboratoire_app/Service/drProfileService.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laboratoire_app/widgets/buttonsWidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laboratoire_app/utilities/toastMsg.dart';

class LoginPage extends StatefulWidget {
  bool back = false;
  LoginPage({ Key key , this.back}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRememberMe = false;
  bool _isLoading = false;
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
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _EmailField(Icons.mail_outline, "info@example.com"),
            _passwordField(MaterialCommunityIcons.lock_outline, "**********"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isRememberMe,
                      activeColor: Palette.textColor2,
                      onChanged: (value) {
                        setState(() {
                          isRememberMe = !isRememberMe;
                        });
                      },
                    ),
                    const Text("Remember me",
                        style: TextStyle(fontSize: 12, color: Palette.textColor1))
                  ],
                ),
                TextButton(
                  onPressed: () {
                    
                  },
                  child: const Text("Forgot Password?",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1)),
                ),
                
              ],
            ),
            _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoadingIndicatorWidget(),
                )
              : _loginBtn(),
          ],
        ),
      ),
    );
  }

    Widget _EmailField(
      IconData icon, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _userIdController,
        keyboardType: TextInputType.emailAddress,
        validator: (item) {
          Pattern pattern =
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?)*$";
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(item) || item == null) {
            return 'Enter a valid email address';
          } else {
            return null;
          }
          // return item.contains('@') ? null : "Enter correct email";
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }

  Widget _passwordField(
      IconData icon, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        keyboardType: TextInputType.text,
        validator: (item) {
          return item.isNotEmpty ? null : "Enter password";
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Palette.textColor1),
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

  _handleLogIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      final res = await AuthService.signIn(
          _userIdController.text, _passwordController.text);
      if (res) {
        final FirebaseAuth auth = FirebaseAuth.instance;
       await setData(auth.currentUser.uid);
        ToastMsg.showToastMsg("Logged in");
        widget.back ? Get.back() : Get.offAllNamed('/HomePage');
      } else {
        ToastMsg.showToastMsg("Smoothing went wrong");
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
  //
  setData(uId) async {
    final fcm = await FirebaseMessaging.instance.getToken();
    await DrProfileService.updateFcmId(uId, fcm);
  }
}