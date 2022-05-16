import 'package:flutter/material.dart';
import 'package:laboratoire_app/widgets/AuthScreen.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/utilities/colors.dart';

class LoginSignupScreen extends StatefulWidget {
  LoginSignupScreen({Key key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  
  bool isConn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      drawer: CustomDrawer(isConn: isConn),
      body: Stack(
            clipBehavior: Clip.none,
        children: [
          CAppBarWidget(title: "Authentification", isConn: isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: AuthScreen(),
          )
        ]
      )
    );
  }

  
}


