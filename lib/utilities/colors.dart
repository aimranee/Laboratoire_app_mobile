import 'package:flutter/material.dart';

final Color appBarColor=Color(0xFF01beb2);
final Color primaryColor=Color(0xFF01beb2);
final Color btnColor=Color(0xFF01beb2);
final Color iconsColor=Color(0xFF01beb2);
final appBarIconColor= Colors.white;
final gradientColor=LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    const Color(0xFF01beb2),
    const Color(0xFF04A99E),
  ],
);
final btnLinearColor=LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color(0xFF04A99E),
    const Color(0xFF04A99E),

    //const Color(0xFF01beb2),

  ],
);

class Palette {
 static const Color iconColor = Color(0xFFB6C7D1);
 static const Color activeColor = Color(0xFF09126C);
 static const Color textColor1 = Color(0XFFA7BCC7);
 static const Color textColor2 = Color(0XFF9BB3C0);
 static const Color facebookColor = Color(0xFF3B5999);
 static const Color googleColor = Color(0xFFDE4B39);
 static const Color backgroundColor = Color(0xFFECF3F9);
}