import 'dart:developer';

import 'package:get/get.dart';
import 'package:syslab_admin/model/analyses_category_model.dart';
import 'package:syslab_admin/screens/user_screen/confiramtionPage.dart';
import 'package:syslab_admin/service/analyses_select_services.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:syslab_admin/screens/userScreen/confiramtionPage.dart';

class RegisterPatient extends StatefulWidget {
  final userDetails;
  final appointmentType;
  final serviceTimeMin;
  final setTime;
  final selectedDate;
  const RegisterPatient(
      {Key key,
      this.userDetails,
      this.serviceTimeMin,
      this.selectedDate,
      this.appointmentType,
      this.setTime})
      : super(key: key);

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
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  String _selectedGender = 'Gender';

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _emailController.text = widget.userDetails.email;
      _lastNameController.text = widget.userDetails.lastName;
      _firstNameController.text = widget.userDetails.firstName;
      _phoneNumberController.text = (widget.userDetails.pNo).toString().substring(3);
      _cityController.text = widget.userDetails.city;
      _cinController.text = widget.userDetails.cin;
      _selectedGender = widget.userDetails.gender;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getSubjectData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _desController.dispose();
    _cinController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  final AppDataController controller = Get.put(AppDataController());
  
  List subjectData = [];
  List subjectDataPrice = [];
  double summ = 0;
  String analyses;
  final String location = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Register Patient"),
      bottomNavigationBar: BottomNavBarWidget(
        isEnableBtn: true,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (_selectedGender == "Gender") {
              ToastMsg.showToastMsg("Please select gender");
            } else if (analyses == "" || summ == 0) {
                  ToastMsg.showToastMsg("Veuillez sélectionner les analyses");
            } else {
              if (widget.appointmentType=="A domicile"){
                Get.to(
                  //() => MyLocation(
                  () => ConfirmationPage(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    phoneNumber: _phoneNumberController.text,
                    email: _emailController.text,
                    selectedGender: _selectedGender,
                    city: _cityController.text,
                    des: _desController.text,
                    cin: _cinController.text,
                    appointmentType: widget.appointmentType,
                    serviceTimeMin: widget.serviceTimeMin,
                    setTime: widget.setTime,
                    selectedDate: widget.selectedDate,
                    uId: widget.userDetails.uId,
                    uName: widget.userDetails.firstName+" "+widget.userDetails.lastName,
                    analyses: analyses,
                    price: summ,
                    location: location,
                    userFcmId: widget.userDetails.fcmId
                  )
                );
              }else{
                Get.to(
                  () => ConfirmationPage(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    phoneNumber: _phoneNumberController.text,
                    email: _emailController.text,
                    selectedGender: _selectedGender,
                    city: _cityController.text,
                    des: _desController.text,
                    appointmentType: widget.appointmentType,
                    serviceTimeMin: widget.serviceTimeMin,
                    setTime: widget.setTime,
                    selectedDate: widget.selectedDate,
                    uId: widget.userDetails.uId,
                    uName: widget.userDetails.firstName+" "+widget.userDetails.lastName,
                    analyses: analyses,
                    price: summ,
                    location: location,
                    cin: _cinController.text,
                    userFcmId: widget.userDetails.fcmId
                  ),
                );
              }
            }
          }
        },
        title: "Suivant",
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 8.0, left: 15, right: 15),
          child: ListView(
            children: <Widget>[
              InputFields.commonInputField(_firstNameController, "First Name",
                  (item) {
                return item.length > 0 ? null : "Enter first name";
              }, TextInputType.text, 1),
              InputFields.commonInputField(_lastNameController, "Last Name",
                  (item) {
                return item.length > 0 ? null : "Enter last name";
              }, TextInputType.text, 1),
              InputFields.commonInputField(
                  _phoneNumberController, "Mobile Number", (item) {
                return item.length == 10
                    ? null
                    : "Enter a 10 digit mobile number";
              }, TextInputType.phone, 1),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 15, right: 15),
                child: _genderDropDown(),
              ),
              InputFields.commonInputField(_emailController, "Email", (item) {
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
              }, TextInputType.emailAddress, 1),
              InputFields.commonInputField(_cityController, "City", (item) {
                return item.length > 0 ? null : "Enter a city name";
              }, TextInputType.text, 1),
              InputFields.commonInputField(_cinController, "CIN", (item) {
                return item.length > 0 ? null : "Enter a CIN";
              }, TextInputType.text, 1),
              _getAnalyses(),
              InputFields.commonInputField(
                  _desController, "Description, About problem", (item) {
                if (item.isEmpty) {
                  return null;
                } else {
                  return item.length > 0 ? null : "Enter Description";
                }
              }, TextInputType.text, 5),
            ],
          ),
        ),
      ),
    );
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
            log(value);
            _selectedGender = value;
          });
        },
      ),
    );
  }

  Widget _getAnalyses(){
    return GetBuilder<AppDataController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: MultiSelectDialogField(
          items: controller.dropDownData,
          title: const Text(
            "Sélectionnez Analyses",
            style: TextStyle(color: Colors.black),
          ),
          selectedColor: Colors.black,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: bgColor,
              width: 2,
            ),
          ),
          buttonIcon: const Icon(
            Icons.keyboard_arrow_down_outlined, color: iconsColor,
            size: 20,
          ),
          buttonText: const Text(
            "Sélectionnez les analyses",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          onConfirm: (results) {
            subjectData = [];
            subjectDataPrice = [];
            for (var i = 0; i < results.length; i++) {
              AnalysesCatModel data = results[i];
              subjectData.add(data.analysesName);
              subjectDataPrice.add(data.analysesPrice);
            }

            for (var i = 0; i < subjectDataPrice.length; i++) {
              summ += subjectDataPrice[i];
              analyses = subjectData.join(", ");
            }
          },
        ),
      );
    });
  }
}
