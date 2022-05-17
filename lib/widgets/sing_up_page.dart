import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:laboratoire_app/Service/Firebase/add_data.dart';
import 'package:laboratoire_app/Service/user_service.dart';
import 'package:laboratoire_app/model/user_model.dart';
import 'package:laboratoire_app/utilities/colors.dart';
import 'package:laboratoire_app/utilities/toast_msg.dart';

class SignUpPage extends StatefulWidget {
  final uId;
  final pNo;
  const SignUpPage({ Key key , this.uId, this.pNo}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isMale = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Gender';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(MaterialCommunityIcons.account_outline, "User Name"),
          buildTextField(MaterialCommunityIcons.email_outline, "email"),
          buildTextField(MaterialCommunityIcons.lock_outline, "password"),
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
        ],
      ),
    );
  }

  // Future<bool> _onWillPop() async {
  //   AuthService.();
  //   return false;
  // }
  
  Widget buildTextField(
      IconData icon, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
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

void _handleUpload() async {
    setState(() {
    });

    var fcmId = await FirebaseMessaging.instance.getToken();
    final pattern = RegExp('\\s+'); //remove all space
    final fullName = _firstNameController.text + _lastNameController.text;
    String searchByName = fullName.toLowerCase().replaceAll(pattern, "");
    final userModel = UserModel(
        uId: widget.uId,
        searchByName: searchByName,
        city: _cityController.text,
        age: _ageController.text,
        gender: _selectedGender,
        email: _emailController.text,
        fcmId: fcmId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        pNo: widget.pNo);
    final insertStatus = await UserService.addData(userModel);
    if (insertStatus != "success") {
      await AddData.addRegisterDetails(widget.uId,searchByName,_cityController.text, _ageController.text,_selectedGender, _emailController.text,fcmId,_firstNameController.text, "", _lastNameController.text, widget.pNo);
     // await AddData.addRegisterDetails(widget.uId);
      ToastMsg.showToastMsg("Registered Logged In");
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
    });
  }

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Gender',
          'Male',
          'Female',
          'Other',
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
          "Select Gender",
        ),
        onChanged: (String value) {
          setState(() {
            //print(value);
            _selectedGender = value;
          });
        },
      ),
    );
  }

}