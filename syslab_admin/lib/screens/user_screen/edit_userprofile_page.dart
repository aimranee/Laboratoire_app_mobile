import 'dart:developer';

import 'package:syslab_admin/model/patient_model.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';

class EditUserProfilePage extends StatefulWidget {
  final userDetails; //QueryDocumentSnapshot

  const EditUserProfilePage({Key key, this.userDetails}) : super(key: key);
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  bool _isLoading = false;
  String _selectedGender = "";
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _cratedDateController = TextEditingController();
  final TextEditingController _updatedDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      _emailController.text = widget.userDetails.email;
      _lastNameController.text = widget.userDetails.lastName;
      _firstNameController.text = widget.userDetails.firstName;
      _phoneNumberController.text = widget.userDetails.pNo;
      _cityController.text = widget.userDetails.city;
      _uIdController.text = widget.userDetails.uId;
      _ageController.text = widget.userDetails.age;
      // _cratedDateController.text = widget.userDetails.createdTimeStamp;
      // _updatedDateController.text = widget.userDetails.updateTimeStamp;
      _selectedGender = widget.userDetails.gender;
    });
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
    // _cratedDateController.dispose();
    // _updatedDateController.dispose();
    super.dispose();
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Update",
        "Are you sure you want to update profile details",
        _handleUpdate); //take a confirmation form the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          onPressed: _takeConfirmation, // _handleUpdate,
          title: "Update",
        ),
        appBar: IAppBars.commonAppBar(context, "Edit Profile"),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    _inputField(
                        "First Name", "Enter first name", _firstNameController),
                    _inputField(
                        "Last Name", "Enter last name", _lastNameController),
                    _inputField("City", "Enter city", _cityController),
                    _ageInputField("Age", _ageController),
                    _genderDropDown(),
                    _emailInputField(),
                    _phnNumInputField(),
                    _readOnlyInputField("User Id", _uIdController),
                    // _readOnlyInputField("Created at", _cratedDateController),
                    // _readOnlyInputField("Last updated", _updatedDateController),
                    _roundedCheckedBtn("Check Booked Appointment"),
                    _newAppointmentBtn("Book New Appointment")
                  ],
                ),
              ));
  }

  _handleUpdate() {
    if (_formKey.currentState.validate()) {
      if (_selectedGender == "" || _selectedGender == null) {
        ToastMsg.showToastMsg("Please select gender");
      } else {
        setState(() {
          _isEnableBtn = false;
          _isLoading = true;
        });
        _updateDetails();
      }
    }
  }

  _updateDetails() async {
    // final pattern = RegExp('\\s+'); //remove all space
    // final fullName = _firstNameController.text + _lastNameController.text;
    // String searchByName = fullName.toLowerCase().replaceAll(pattern, "");
    final patientModel = PatientModel(
        email: _emailController.text,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        age: _ageController.text,
        city: _cityController.text,
        uId: widget.userDetails.uId,
        // searchByName: searchByName,
        gender: _selectedGender,
        pNo: _phoneNumberController.text);
    log(">>>>>>>>>>>>>>>>>>>>>>${patientModel.toUpdateJson()}");
    final res = await PatientService.updateData(patientModel);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/UsersListPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

 
  Widget _roundedCheckedBtn(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: RoundedBtnWidget(
          title: title,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         ShowAppointmentByUidPage(userId: widget.userDetails.uId),
            //   ),
            // );
          }),
    );
  }

  Widget _newAppointmentBtn(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: RoundedBtnWidget(
          title: title,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         ChooseTypePage(userDetails: widget.userDetails),
            //   ),
            // );
          }),
    );
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
        iconEnabledColor: btnColor,
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
            log(value);
            _selectedGender = value;
          });
        },
      ),
    );
  }
}
