import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/Login_SignUp.dart';
import 'package:laboratoire_app/Service/userService.dart';
import 'package:laboratoire_app/SetData/screenArg.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/inputfields.dart';
import 'package:laboratoire_app/utilities/toastMsg.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPatient extends StatefulWidget {
  const RegisterPatient({Key key}) : super(key: key);

  @override
  _RegisterPatientState createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  String _selectedGender = 'Gender';

  final _isBtnDisable = "false";
  bool _isLoading = false;
  String _uId;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _desController.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  void _setData() async {
    setState(() {
      _isLoading = true;
    });
    final user =
        await UserService.getData();
        if (user != null) {
          //set all data
          setState(() {
            _uId = user[0].uId;
          });
          _firstNameController.text = user[0].firstName;
          _lastNameController.text = user[0].lastName;
          _phoneNumberController.text = user[0].pNo;
          _emailController.text = user[0].email;
          _ageController.text = user[0].age;
          _selectedGender = user[0].gender;
          _cityController.text = user[0].city;
          //stop loading indicator
        }
        setState(() {
            _isLoading = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    final ChooseTimeScrArg _chooseTimeScrArgs =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
        bottomNavigationBar: BottomNavigationStateWidget(
          title: "Next",
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (_selectedGender == "Gender") {
                ToastMsg.showToastMsg("Please select gender");
              } else {
                Get.toNamed(
                  '/ConfirmationPage',
                  arguments: PatientDetailsArg(
                      _firstNameController.text,
                      _lastNameController.text,
                      _phoneNumberController.text,
                      _emailController.text,
                      _ageController.text,
                      _selectedGender,
                      _cityController.text,
                      _desController.text,
                      _chooseTimeScrArgs.serviceName,
                      _chooseTimeScrArgs.serviceTimeMIn,
                      _chooseTimeScrArgs.selectedTime,
                      _chooseTimeScrArgs.selectedDate,
                      _chooseTimeScrArgs.isConn),
                );
              }
            }
          },
          clickable: _isBtnDisable,
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            _isLoading ? Container() : CAppBarWidget(title: "Register Patient", isConn: _chooseTimeScrArgs.isConn),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: _isLoading ? LoadingIndicatorWidget() : Container(
                height: MediaQuery.of(context).size.height,
                decoration: IBoxDecoration.upperBoxDecoration(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 15, right: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InputFields.textInputFormField(
                            context,
                            "First Name*",
                            TextInputType.text,
                            _firstNameController,
                            1,
                            (item) {
                              return item.length > 0
                                  ? null
                                  : "Enter your first name";
                            },
                          ),
                          InputFields.textInputFormField(
                            context,
                            "Last Name*",
                            TextInputType.text,
                            _lastNameController,
                            1,
                            (item) {
                              return item.length > 0 ? null : "Enter last name";
                            },
                          ),
                          InputFields.textInputFormField(
                            context,
                            "Phone Number*",
                            TextInputType.number,
                            _phoneNumberController,
                            1,
                            (item) {
                              return item.length == 10
                                  ? null
                                  : "Enter a valid Phone number (10 digit)";
                            },
                          ),
                          InputFields.textInputFormField(
                            context,
                            "Email",
                            TextInputType.emailAddress,
                            _emailController,
                            1,
                            (item) {
                              Pattern pattern =
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?)*$";
                              RegExp regex = RegExp(pattern);
                              if (item.length > 0) {
                                if (!regex.hasMatch(item) || item == null) {
                                  return 'Enter a valid email address';
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                          ),
                          InputFields.ageInputFormField(
                            context,
                            "Age*",
                            TextInputType.number,
                            _ageController,
                            false,
                            (item) {
                              if (item.length > 0 && item.length <= 3) {
                                return null;
                              } else if (item.length > 3) {
                                return "Enter valid age";
                              } else {
                                return "Enter age";
                              }
                            },
                          ),
                          Container(
                            width: double.infinity,
                            child: _genderDropDown(),
                          ),
                          InputFields.textInputFormField(
                            context,
                            "City*",
                            TextInputType.text,
                            _cityController,
                            1,
                            (item) {
                              return item.length > 0 ? null : "Enter city";
                            },
                          ),
                          InputFields.textInputFormField(
                            context,
                            "Description, About your Problem",
                            TextInputType.text,
                            _desController,
                            5,
                            (item) {
                              if (item.isEmpty) {
                                return null;
                              } else {
                                return item.length > 0
                                    ? null
                                    : "Enter Description";
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 15),
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
            // print(value);
            _selectedGender = value;
          });
        },
      ),
    );
  }
}
