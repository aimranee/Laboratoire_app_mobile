import 'package:get/get.dart';
import 'package:laboratoire_app/Service/user_service.dart';
import 'package:laboratoire_app/SetData/screen_arg.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/inputfields.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';

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
  final TextEditingController ageController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  bool _isLoading = false;
  final _isBtnDisable = "false";
  @override
  void initState(){
    _setData();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    ageController.dispose();
    _cityController.dispose();
    _desController.dispose();
      
    super.dispose();
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
              
                Get.toNamed(
                  '/ConfirmationPage',
                  arguments: PatientDetailsArg(
                      _firstNameController.text,
                      _lastNameController.text,
                      _phoneNumberController.text,
                      _emailController.text,
                      _desController.text,
                      _chooseTimeScrArgs.appointmentType,
                      _chooseTimeScrArgs.serviceTimeMIn,
                      _chooseTimeScrArgs.selectedTime,
                      _chooseTimeScrArgs.selectedDate, 
                    ),
                );
            }
          },
          clickable: _isBtnDisable,
        ),
        body: _isLoading ? LoadingIndicatorWidget() : Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CAppBarWidget(title: "Register Patient", isConn: true),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
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
                          _InputField(_firstNameController, "firstName"),
                          _InputField(_lastNameController, "lastName"),
                          _InputField(_cityController, "city"),
                          _InputField(_phoneNumberController, "Phone numbre"),
                          _InputField(_emailController, "Email"),
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

  Widget _InputField(controller,String name,) {
    return InputFields.readableInputField(
        controller, name, 1);
  } 

  _setData() async {
    setState(() {
      _isLoading = true;
    });
    final user = await UserService.getData();

      _emailController.text = user[0].email;
      _lastNameController.text = user[0].lastName;
      _firstNameController.text = user[0].firstName;
      _firstNameController.text = user[0].firstName;
      _phoneNumberController.text = user[0].pNo;
      _cityController.text = user[0].city;

    setState(() {
      _isLoading = false;
    });
  }
}
