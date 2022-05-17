// import 'package:laboratoire_app/Service/AuthService/authservice.dart';
// import 'package:laboratoire_app/Service/Firebase/addData.dart';
// import 'package:laboratoire_app/utilities/color.dart';
// import 'package:laboratoire_app/utilities/inputfields.dart';
// import 'package:laboratoire_app/utilities/style.dart';
// import 'package:laboratoire_app/utilities/toastMsg.dart';
// import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
// import 'package:laboratoire_app/widgets/loadingIndicator.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:laboratoire_app/Service/userService.dart';
// import 'package:laboratoire_app/model/userModel.dart';

// class RegisterUserPage extends StatefulWidget {
//   final uId;
//   final pNo; //QueryDocumentSnapshot

//   const RegisterUserPage({Key key, this.uId, this.pNo}) : super(key: key);
//   @override
//   _RegisterUserPageState createState() => _RegisterUserPageState();
// }

// class _RegisterUserPageState extends State<RegisterUserPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   String _selectedGender = 'Gender';

//   var _isBtnEnable = "true";
//   bool _isLoading = false;

//   @override
//   void dispose() {
//       
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _ageController.dispose();
//     _cityController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: appBarColor,
//             title: Text("Register", style: kAppbarTitleStyle),
//             centerTitle: true,
//             actions: [
//               IconButton(
//                   icon: const Icon(Icons.logout),
//                   onPressed: () {
//                     AuthService.signOut();
//                   })
//             ],
//           ),
//           bottomNavigationBar: BottomNavigationStateWidget(
//             title: "Next",
//             onPressed: () {
//               if (_formKey.currentState.validate()) {
//                 if (_selectedGender == "Gender") {
//                   Fluttertoast.showToast(
//                       msg: "Please select gender",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       timeInSecForIosWeb: 1,
//                       backgroundColor: Colors.black,
//                       textColor: Colors.white,
//                       fontSize: 14.0);
//                 } else {
//                   _handleUpload();
//                 }
//               }
//             },
//             clickable: _isBtnEnable,
//           ),
//           body: _isLoading
//               ? LoadingIndicatorWidget()
//               : Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         top: 8.0, bottom: 8.0, left: 15, right: 15),
//                     child: ListView(
//                       children: <Widget>[
//                         InputFields.textInputFormField(
//                           context,
//                           "First Name*",
//                           TextInputType.text,
//                           _firstNameController,
//                           1,
//                           (item) {
//                             return item.length > 0
//                                 ? null
//                                 : "Enter your first name";
//                           },
//                         ),
//                         InputFields.textInputFormField(
//                           context,
//                           "Last Name*",
//                           TextInputType.text,
//                           _lastNameController,
//                           1,
//                           (item) {
//                             return item.length > 0 ? null : "Enter last name";
//                           },
//                         ),
//                         InputFields.textInputFormField(
//                           context,
//                           "Email",
//                           TextInputType.emailAddress,
//                           _emailController,
//                           1,
//                           (item) {
//                             Pattern pattern =
//                                 r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//                                 r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//                                 r"{0,253}[a-zA-Z0-9])?)*$";
//                             RegExp regex = RegExp(pattern);
//                             if (item.length > 0) {
//                               if (!regex.hasMatch(item) || item == null) {
//                                 return 'Enter a valid email address';
//                               } else {
//                                 return null;
//                               }
//                             } else {
//                               return null;
//                             }
//                           },
//                         ),
//                         InputFields.ageInputFormField(
//                           context,
//                           "Age*",
//                           TextInputType.number,
//                           _ageController,
//                           false,
//                           (item) {
//                             if (item.length > 0 && item.length <= 3) {
//                               return null;
//                             } else if (item.length > 3) {
//                               return "Enter valid age";
//                             } else {
//                               return "Enter age";
//                             }
//                           },
//                         ),
//                         _genderDropDown(),
//                         InputFields.textInputFormField(
//                           context,
//                           "City*",
//                           TextInputType.text,
//                           _cityController,
//                           1,
//                           (item) {
//                             return item.length > 0 ? null : "Enter city";
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 )),
//     );
//   }

//   Future<bool> _onWillPop() async {
//     AuthService.signOut();
//     return false;
//   }

//   void _handleUpload() async {
//     setState(() {
//       _isBtnEnable = "";
//       _isLoading = true;
//     });

//     var fcmId = await FirebaseMessaging.instance.getToken();
//     final pattern = RegExp('\\s+'); //remove all space
//     final fullName = _firstNameController.text + _lastNameController.text;
//     String searchByName = fullName.toLowerCase().replaceAll(pattern, "");
//     final userModel = UserModel(
//         uId: widget.uId,
//         searchByName: searchByName,
//         city: _cityController.text,
//         age: _ageController.text,
//         gender: _selectedGender,
//         email: _emailController.text,
//         fcmId: fcmId,
//         firstName: _firstNameController.text,
//         lastName: _lastNameController.text,
//         pNo: widget.pNo);
//     final insertStatus = await UserService.addData(userModel);
//     if (insertStatus != "success") {
//       await AddData.addRegisterDetails(widget.uId,searchByName,_cityController.text, _ageController.text,_selectedGender, _emailController.text,fcmId,_firstNameController.text, "", _lastNameController.text, widget.pNo);
//      // await AddData.addRegisterDetails(widget.uId);
//       ToastMsg.showToastMsg("Registered Logged In");
//     } else {
//       ToastMsg.showToastMsg("Something went wrong");
//     }
//     setState(() {
//       _isBtnEnable = "true";
//       _isLoading = false;
//     });
//   }

//   _genderDropDown() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 0),
//       child: DropdownButton<String>(
//         focusColor: Colors.white,
//         value: _selectedGender,
//         //elevation: 5,
//         style: TextStyle(color: Colors.white),
//         iconEnabledColor: btnColor,
//         items: <String>[
//           'Gender',
//           'Male',
//           'Female',
//           'Other',
//         ].map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(
//               value,
//               style: TextStyle(color: Colors.black),
//             ),
//           );
//         }).toList(),
//         hint: const Text(
//           "Select Gender",
//         ),
//         onChanged: (String value) {
//           setState(() {
//             //print(value);
//             _selectedGender = value;
//           });
//         },
//       ),
//     );
//   }
// }
