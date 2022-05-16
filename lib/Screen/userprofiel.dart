import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/Login_SignUp.dart';
import 'package:laboratoire_app/model/userModel.dart';
import 'package:laboratoire_app/service/userService.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/dialogBox.dart';
import 'package:laboratoire_app/utilities/inputfields.dart';
import 'package:laboratoire_app/widgets/AuthScreen.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key key}) : super(key: key);
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isLoading = false;
  String _selectedGender = "";
  String _isEnableBtn = "false";
  bool isConn = Get.arguments;
  String _uId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _setData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _uIdController.dispose();
    super.dispose();
  }

  _takeConfirmation() {
    !isConn ? Container() : 
    DialogBoxes.confirmationBox(
        context,
        "Update",
        "Are you sure you want to update profile details",
        _handleUpdate
    ); //take a confirmation form the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading
        ? LoadingIndicatorWidget() : 
        BottomNavigationStateWidget(
        title: "Update",
        onPressed: _takeConfirmation,
        clickable: _isEnableBtn,
      ),
      drawer : CustomDrawer(isConn: isConn),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title: "Profile", isConn: isConn), //common app bar
          Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child:
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: IBoxDecoration.upperBoxDecoration(),
                  child: ! isConn ? AuthScreen() : _buildContent())),
        ],
      ),
    );
  }

  _handleUpdate() {
    if (_formKey.currentState.validate()) {
      if (_selectedGender == "" || _selectedGender == null) {
        ToastMsg.showToastMsg("Please select gender");
      } else {
        setState(() {
          _isEnableBtn = "";
          _isLoading = true;
        });
        _updateDetails();
      }
    }
  }

  _updateDetails() async {
    final pattern = RegExp('\\s+'); //remove all space
    final fullName = _firstNameController.text + _lastNameController.text;
    String searchByName = fullName.toLowerCase().replaceAll(pattern, "");
    final userModel = UserModel(
        email: _emailController.text,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        age: _ageController.text,
        city: _cityController.text,
        uId: _uIdController.text,
        searchByName: searchByName,
        gender: _selectedGender,
        pNo: _phoneNumberController.text);
    // print(">>>>>>>>>>>>>>>>>>>>>>${userModel.toUpdateJson()}");
    final res = await UserService.updateData(userModel);
    if (res == "success") {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("firstName", _firstNameController.text);
      prefs.setString("lastName", _lastNameController.text);

      ToastMsg.showToastMsg("Successfully Updated");
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = "false";
      _isLoading = false;
    });
  }

  Widget _readOnlyInputField(String labelText, controller) {
    return InputFields.readableInputField(controller, labelText, 1);
  }

  Widget _ageInputField(String labelText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      if (item.length > 0 && item.length <= 3) {
        return null;
      } else if (item.length > 3) {
        return "Enter valid age";
      } else {
        return "Enter age";
      }
    }, TextInputType.number, 1);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
  }

  Widget _emailInputField() {
    return InputFields.commonInputField(_emailController, "Email", (item) {
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
    }, TextInputType.emailAddress, 1);
  }

  Widget _phnNumInputField() {
    return InputFields.readableInputField(
        _phoneNumberController, "Mobile Number", 1);
  } 

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: appBarColor,
        items: <String>[
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
          "Gender",
        ),
        onChanged: (String value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }

  _buildContent() {
    return _isLoading
        ? LoadingIndicatorWidget()
        : Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                _inputField("First Name", "Enter first name", _firstNameController),
                _inputField("Last Name", "Enter last name", _lastNameController),
                _inputField("City", "Enter city", _cityController),
                _ageInputField("Age", _ageController),
                _genderDropDown(),
                _emailInputField(),
                _phnNumInputField(),
                _readOnlyInputField("User Id", _uIdController),
              ],
            ),
          );
  }

  void _setData() async {
    
    // setState(() {
    //   _isLoading = true;
    // });

    final user = await UserService.getData();
    
    if (user != null){
      
      _emailController.text = user[0].email;
      _lastNameController.text = user[0].lastName;
      _firstNameController.text = user[0].firstName;
      _firstNameController.text = user[0].firstName;
      _phoneNumberController.text = user[0].pNo;
      _cityController.text = user[0].city;
      _uIdController.text = user[0].uId;
      _ageController.text = user[0].age;
      _selectedGender = user[0].gender;
      setState(() {
        isConn = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
