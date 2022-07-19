import 'dart:developer';
import 'dart:ui';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient/Screen/prescription/show_prescription_imae.dart';
import 'package:patient/Service/Noftification/handle_firebase_notification.dart';
import 'package:patient/Service/Noftification/handle_local_notification.dart';
import 'package:patient/Service/admin_profile_service.dart';
import 'package:patient/Service/prescription_service.dart';
import 'package:patient/Service/user_service.dart';
import 'package:patient/model/prescription_model.dart';
import 'package:patient/utilities/decoration.dart';
import 'package:patient/utilities/inputfields.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/utilities/toast_msg.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/image_widget.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ScrollController _scrollController=ScrollController();
  List _fileUrls=[];
  String price;
  String id;
  bool isPaied = false;  
  String username;

  @override
  void initState() {
     _getUserData();
    setState(() {
      id = widget.prescriptionDetails.id;
      _appointmentTypeController.text=widget.prescriptionDetails.appointmentName;
      _patientNameController.text=widget.prescriptionDetails.patientName;
      _drNameController.text=widget.prescriptionDetails.drName;
      _dateController.text=widget.prescriptionDetails.appointmentDate;
      _timeController.text=widget.prescriptionDetails.appointmentTime;
      _messageController.text=widget.prescriptionDetails.prescription;
      _priceController.text=widget.prescriptionDetails.price;
      if(widget.prescriptionDetails.isPaied == "1") {
        isPaied = true;
        price = widget.prescriptionDetails.price;
      }
      if(widget.prescriptionDetails.fileUrl!="") {
        _fileUrls=widget.prescriptionDetails.fileUrl.toString().split(",");
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
    _messageController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer : CustomDrawer(isConn: true),
      body: SingleChildScrollView(
        child: Column (
          children: <Widget>[
            CAppBarWidget(title:widget.title, isConn:true),
            Container(
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
                  InputFields.readableInputField(_priceController, "Price",1),
                  InputFields.readableInputField(_messageController, "Message",null),

                  Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  const Text("État des Resultats:     "),
                  if ( widget.prescriptionDetails.prescriptionStatus  ==
                      "Terminé")
                    _statusIndicator(Colors.green)
                  else if ( widget.prescriptionDetails.prescriptionStatus  ==
                      "Dans la réalisation")
                    _statusIndicator(Colors.yellowAccent)
                  else if (
                    widget.prescriptionDetails.prescriptionStatus  ==
                        "Suspendu")
                      _statusIndicator(Colors.red)
                    else
                      Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                        "${ widget.prescriptionDetails.prescriptionStatus }",
                        style: const TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 15,
                        )),
                  ),
                ],
              ),
            ),

                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 25.0, right: 25),
                    child: Text("Les resultats : ", style: kPageTitleStyle),
                  ),
                  const SizedBox(height: 25),
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
          ],
        ),
      ),
    );
  }
  
  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
  }

  _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
          controller: _scrollController,
          itemCount: _fileUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                onTap: () async {
                    if (isPaied){
                      Get.to(() => ShowPrescriptionFilePage(
                          fileUrls: _fileUrls,
                          selectedFilesIndex: index,
                          title: "Télécharger les resultats"),
                      );
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
                      log(res.paymentMethodNonce.description);
                      log(res.paymentMethodNonce.nonce);
                      
                    }
                  }
                    // controller.makePayment(amount: '33', currency: 'USD');
                },

                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:ImageBoxContainWidget(imageUrl:_fileUrls[index] ,),
                    ),
                  ]
                )
              ),
            );
      }),
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
    log (" : "+_adminFCMid);
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
}
