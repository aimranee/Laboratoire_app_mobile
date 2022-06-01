import 'package:laboratoire_app/utilities/color.dart';
import 'package:get/get.dart';
import 'package:laboratoire_app/Service/analyses_select_services.dart';
import 'package:laboratoire_app/Service/user_service.dart';
import 'package:laboratoire_app/SetData/screen_arg.dart';
import 'package:laboratoire_app/model/analyses_category_model.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/inputfields.dart';
import 'package:laboratoire_app/utilities/toast_msg.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  final TextEditingController _desController = TextEditingController();

  bool _isLoading = false;
  final _isBtnDisable = "false";
  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getSubjectData();
    });
    _setData();
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
      
    super.dispose();
  }
  final AppDataController controller = Get.put(AppDataController());
  List subjectData = [];
  List subjectDataPrice = [];
  double summ = 0;
  String analyses;
  @override
  Widget build(BuildContext context) {
        
    final ChooseTimeScrArg _chooseTimeScrArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        bottomNavigationBar: BottomNavigationStateWidget(
          title: "Suivant",
          onPressed: () {
            
              if (_formKey.currentState.validate()) {
                if (analyses == "" || summ == 0) {
                  ToastMsg.showToastMsg("Veuillez sélectionner les analyses");
                } else {
                    Get.toNamed(
                    '/ConfirmationPage',
                    arguments: PatientDetailsArg(
                        _firstNameController.text,
                        _lastNameController.text,
                        _phoneNumberController.text,
                        _emailController.text,
                        _cityController.text,
                        _desController.text,
                        analyses,
                        summ,
                        _chooseTimeScrArgs.appointmentType,
                        _chooseTimeScrArgs.serviceTimeMIn,
                        _chooseTimeScrArgs.selectedTime,
                        _chooseTimeScrArgs.selectedDate),
                  );
                }
              }
          },
          clickable: _isBtnDisable,
        ),
        body: _isLoading ? const LoadingIndicatorWidget() : Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CAppBarWidget(title: "Enregistrer le patient", isConn: true),
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
                          _InputField(_firstNameController, "Prenom"),
                          _InputField(_lastNameController, "Nom"),
                          _InputField(_cityController, "Ville"),
                          _InputField(_phoneNumberController, "Numero de telephone"),
                          _InputField(_emailController, "Email"),
                          _getAnalyses(),
                          InputFields.textInputFormField(
                            context,
                            "Description, À propos de votre problème",
                            TextInputType.text,
                            _desController,
                            5,
                            (item) {
                              if (item.isEmpty) {
                                return null;
                              } else {
                                return item.length > 0
                                    ? null
                                    : "Entrez la description";
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

  // ignore: non_constant_identifier_names
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
