import 'dart:developer';
import 'dart:ui';

import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/prescription/show_prescription_imae.dart';
import 'package:laboratoire_app/Service/prescription_service.dart';
import 'package:laboratoire_app/model/prescription_model.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/inputfields.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/utilities/toast_msg.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/image_widget.dart';
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
                  // InputFields.readableInputField(_timeController, "Time", 1),
                  InputFields.readableInputField(_priceController, "Price",1),
                  InputFields.readableInputField(_messageController, "Message",null),
                  
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
                                style: kAppbarTitleStyle,
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
                      setState((){
                        isPaied = true;
                      });
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

      if (pref.getString("fcm") != "") {
        setState(() {
          username = pref.getString("firstName") + " " + pref.getString("lastName");
        });
      }
  }
  _updateDetails() async {
    String r = "0";
      if (isPaied){
          r = "1";
      }

    final prescriptionModel = PrescriptionModel(
        id: id,
        isPaied: r,
      );
    final res = await PrescriptionService.updateIsPaied(prescriptionModel);
    if (res == "success") {
      ToastMsg.showToastMsg("paiement avec succès");
    } else if (res == "error") {
      ToastMsg.showToastMsg("Quelque chose a mal tourné");
    }
  }
}
