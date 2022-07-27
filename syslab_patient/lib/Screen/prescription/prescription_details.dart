import 'dart:ui';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:intl/intl.dart';
import 'package:patient/Screen/pdf_generator/generator_pdf.dart';
import 'package:patient/Screen/pdf_generator/pdf_save.dart';
import 'package:patient/Service/Noftification/handle_firebase_notification.dart';
import 'package:patient/Service/Noftification/handle_local_notification.dart';
import 'package:patient/Service/admin_profile_service.dart';
import 'package:patient/Service/prescription_service.dart';
import 'package:patient/Service/user_service.dart';
import 'package:patient/model/admin_result.dart';
import 'package:patient/model/patient_result.dart';
import 'package:patient/model/prescription_model.dart';
import 'package:patient/model/results.dart';
import 'package:patient/utilities/decoration.dart';
import 'package:patient/utilities/inputfields.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/utilities/toast_msg.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionDetailsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  // ignore: prefer_typing_uninitialized_variables
  final prescriptionDetails;
  // ignore: use_key_in_widget_constructors
  const PrescriptionDetailsPage({ this.title, this.prescriptionDetails });
  @override
  _PrescriptionDetailsPageState createState() => _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState extends State<PrescriptionDetailsPage> {
  final TextEditingController _appointmentTypeController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _drNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _resultsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _prescriptionStatus = TextEditingController();

  String price;
  String id;
  bool isPaied = false;  
  String username;
  String emailAdmin;

  @override
  
  void initState() {
     _getUserData();
     getDataAdmin();
    setState(() {
      id=widget.prescriptionDetails.id;
      _appointmentTypeController.text=widget.prescriptionDetails.appointmentName;
      _patientNameController.text=widget.prescriptionDetails.patientName;
      _drNameController.text=widget.prescriptionDetails.drName;
      _dateController.text=widget.prescriptionDetails.appointmentDate;
      _timeController.text=widget.prescriptionDetails.appointmentTime;
      _resultsController.text=widget.prescriptionDetails.results;
      _priceController.text=widget.prescriptionDetails.price;
      _prescriptionStatus.text=widget.prescriptionDetails.prescriptionStatus;
      if(widget.prescriptionDetails.isPaied == "1") {
        isPaied = true;
        price = widget.prescriptionDetails.price;
      }
    });
    super.initState();
  }
  @override
  void dispose() {
      
    _appointmentTypeController.dispose();
    _patientNameController.dispose();
    _drNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _resultsController.dispose();
    _priceController.dispose();
    _prescriptionStatus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer : CustomDrawer(isConn: true),
      body: Stack (
        children: <Widget>[
          CAppBarWidget(title:widget.title, isConn:true),
            Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration:IBoxDecoration.upperBoxDecoration(),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InputFields.readableInputField(_appointmentTypeController, "Type de rendez-vous", 1),
                  InputFields.readableInputField(_patientNameController, "Nom de patient", 1),
                  InputFields.readableInputField(_drNameController, "Nom d'infermier", 1),
                  InputFields.readableInputField(_dateController, "Date", 1),
                  InputFields.readableInputField(_priceController, "Prix",1),
          
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        const Text("État des Resultats:     "),
                        if ( _prescriptionStatus.text == "Terminé")
                          _statusIndicator(Colors.green)
                        else if ( _prescriptionStatus.text == "Traiter")
                          _statusIndicator(Colors.yellowAccent)
                        else if (_prescriptionStatus.text == "Suspendu")
                            _statusIndicator(Colors.red)
                        else
                          Container(),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              "${ _prescriptionStatus.text }",
                              style: const TextStyle(
                                fontFamily: 'OpenSans-SemiBold',
                                fontSize: 15,
                              )
                            ),
                          ),
                      ],
                    ),
                  ),
          
                  if ( _prescriptionStatus.text == "Terminé")
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 25.0, right: 25),
                    child: Text("Les resultats : ", style: kPageTitleStyle),
                  ),
                  const SizedBox(height: 25),
                  if ( _prescriptionStatus.text == "Terminé")
                  SizedBox(
                    height: MediaQuery.of(context).size.height*.26,
                    child : Stack(
                      clipBehavior: Clip.none,
                        children: [
                          if (!isPaied)
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child:_buildImageList()
                          ),
                          if (!isPaied)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.lock_outline,color: Colors.black, size: 70
                                ),
                                Text(
                                  "Les frais de dossier se sont pas effectués", 
                                  textAlign: TextAlign.center,
                                  style: kPageTitleStyle
                                )
                              ]
                            ),
                          ),
                          if (isPaied)
                          _buildImageList()
                        
                        ]
                      ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
  }

  _buildImageList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () async {
            if (isPaied){
              _uploadFile();
            }else{
              var req = BraintreeDropInRequest(
                tokenizationKey: 'sandbox_gpz3pxyq_dtn5b9gypbndfyc2',
                collectDeviceData: true,
                paypalRequest: BraintreePayPalRequest(
                  amount: widget.prescriptionDetails.price, displayName: username
                ),
                cardEnabled: true
              );
              BraintreeDropInResult res = await BraintreeDropIn.start(req);
              if (res != null) {
                _updateDetails();
                // log(res.paymentMethodNonce.description);
                // log(res.paymentMethodNonce.nonce);
                
              }
            }
            // controller.makePayment(amount: '33', currency: 'USD');
        },

        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:Image.asset('assets/images/original.jpg'),
            ),
          ]
        )
      ),
    );

  }
  _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

      if (pref.getString("token") != "null" && pref.getString("token") != "" && pref.getString("token") != null) {
        setState(() {
          username = pref.getString("firstName") + " " + pref.getString("lastName");
        });
      }
  }
  _updateDetails() async {

    DateTime now = DateTime.now();
    String createdTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final prescriptionModel = PrescriptionModel(
        id: id,
        isPaied: "1",
        updatedTimeStamp: createdTime,
      );
    final res = await PrescriptionService.updateIsPaied(prescriptionModel);
    if (res == "success") {
      setState((){
        isPaied = true;
      });
      _handleSendNotification();
      ToastMsg.showToastMsg("paiement avec succès");
    } else if (res == "error") {
      ToastMsg.showToastMsg("Quelque chose a mal tourné");
    }
  }

    void _handleSendNotification() async {
    final res = await AdminProfileService.getData();
    String  _adminFCMid = res[0].fcmId;
    // log (" : "+_adminFCMid);
    //send local notification

    await HandleLocalNotification.showNotification(
      "Paiement",
      "le paiement est établi pour la date ${widget.prescriptionDetails.appointmentDate}", // body
    );
    await UserService.updateIsAnyNotification("1");

    // send notification to admin app for booking confirmation
    await HandleFirebaseNotification.sendPushMessage(
        _adminFCMid, //admin fcm
        "Paiement avec succès", //title
        "${widget.prescriptionDetails.patientName} a payer le montant des résultats ${widget.prescriptionDetails.id} pour la date ${widget.prescriptionDetails.appointmentDate}."//body
    );
    await AdminProfileService.updateIsAnyNotification("1");

  }
  _uploadFile() async {
      final date = DateTime.now();
      // final dueDate = date.add(const Duration(days: 7));

      final results = Results(
        adminRes: AdminRes(
          name: 'Laboratoire SYSLAB',
          address: 'test admin',
          email: emailAdmin,
        ),
        patientRes: PatientRes(
          name: username,
          address: 'test test test',
        ),
        info: ResultsInfo(
          date: date,
          // dueDate: dueDate,
          description: widget.prescriptionDetails.results,
          number: '${DateTime.now().year}',
        ),
        items: [
          ResultsItem(
            description: 'test',
            date: DateTime.now(),
            // price: widget.prescriptionDetails.price,
          ),
        ],
      );
      final pdfFile = await PdfResultGenerator.generate(results);
      // log("success");
      PdfApi.openFile(pdfFile);
    }
    getDataAdmin() async {
      final res = await AdminProfileService.getData();
      setState(() {
        emailAdmin = res[0].email;

      });
    }
}

