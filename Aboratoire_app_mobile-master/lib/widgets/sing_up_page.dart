import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:laboratoire_app/Service/dr_profile_service.dart';
import 'package:laboratoire_app/Service/user_service.dart';
import 'package:laboratoire_app/model/user_model.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/toast_msg.dart';
import 'package:laboratoire_app/widgets/buttons_widget.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key key }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isMale = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  
  String _selectedGender = 'Gender';
  String _selectedBloodType = 'Groupe Sanguin';
  String _selectedfamilySituation = "Family Situation";
  final bool _hasRamid = false;
  final bool _hasCnss = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: 
      Form(
        key: _formKey,
        child :Column(
        children: [
          buildTextField(MaterialCommunityIcons.account_outline, "First Name", _firstNameController),
          buildTextField(MaterialCommunityIcons.account_outline, "Last Name", _lastNameController),
          buildEmailField(MaterialCommunityIcons.email_outline, "Email"),
          _passwordField(MaterialCommunityIcons.lock_outline, "Password"),
          // buildTextField(MaterialCommunityIcons.lock_outline, "confirmer password", _passwordConfirmedController),
          buildTextField(MaterialCommunityIcons.email_outline, "Phone Numbre", _phoneNumberController),
          buildTextField(MaterialCommunityIcons.email_outline, "CIN", _cinController),
          buildTextField(MaterialCommunityIcons.email_outline, "Age", _ageController),
          buildTextField(MaterialCommunityIcons.email_outline, "Ville", _cityController),
          _familySituationDropDown(),
          _bloodTypeDropDown(),

          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Palette.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Colors.transparent
                                    : Palette.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Colors.white : Palette.iconColor,
                        ),
                      ),
                      const Text(
                        "Male",
                        style: TextStyle(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Colors.transparent
                                : Palette.textColor2,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Palette.textColor1
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Palette.iconColor : Colors.white,
                        ),
                      ),
                      const Text(
                        "Female",
                        style: TextStyle(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  text: "By pressing 'Submit' you agree to our ",
                  style: TextStyle(color: Palette.textColor2),
                  children: [
                    TextSpan(
                      //recognizer: ,
                      text: "term & conditions",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ]),
            ),
          ),
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LoadingIndicatorWidget(),
                )
              : _loginBtn(),
        ],
      ),
    )
    );
  }
  
  Widget buildTextField(icon, hintText, controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
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
  Widget buildEmailField(IconData icon, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _emailController,
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
      onPressed: _handleSignUp,
      title: "Sign up",
    );
  }
  _handleSignUp() async {
    
    if (_formKey.currentState.validate()) {
      
      setState(() {
        _isLoading = true;
      });
      final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      if (res != null) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        await setData(auth.currentUser.uid);
        _handleUpload();
        
        // final FirebaseAuth auth = FirebaseAuth.instance;
        
        ToastMsg.showToastMsg("Registed");
        Get.offAllNamed('/HomePage');
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
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("fcm", fcm);
  }


_handleUpload() async {
    setState(() {
      _isLoading = true;
    });

    String R = "0";
    String C = "0";
      if (_hasRamid == true){
          R = "1"; 
      }
      if (_hasCnss == true){
          C = "1";
      }
      isMale ? setState(() {
        _selectedGender = 'Male';
      }):setState(() {
        _selectedGender = 'Female';
      });
    var uId = FirebaseAuth.instance.currentUser.uid;
    var fcmId = await FirebaseMessaging.instance.getToken();
    final userModel = UserModel(
        email: _emailController.text,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        cin: _cinController.text,
        age: _ageController.text,
        city: _cityController.text,
        gender: _selectedGender,
        familySituation: _selectedfamilySituation,
        bloodType: _selectedBloodType,
        hasRamid: R,
        hasCnss: C,
        uId: uId,
        fcmId: fcmId,
        pNo: _phoneNumberController.text,

      );

    final insertStatus = await UserService.register(userModel);
    log("insertStatus : "+insertStatus);
    if (insertStatus != "success") {
      ToastMsg.showToastMsg("Registered Logged In");
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isLoading = false;
    });
  }
    _familySituationDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedfamilySituation,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Family Situation',
          'Célibataire',
          'Marié',
          'Divorcé',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: const Text(
          "Select Family Situation",
        ),
        onChanged: (String value) {
          setState(() {
            _selectedfamilySituation = value;
          });
        },
      ),
    );
  }

    _bloodTypeDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedBloodType,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Groupe Sanguin',
          'A+',
          'A-',
          'B+',
          'B-',
          'AB',
          'O',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: const Text(
          "Sélectionnez le groupe sanguin",
        ),
        onChanged: (String value) {
          setState(() {
            _selectedBloodType = value;
          });
        },
      ),
    );
  }

}