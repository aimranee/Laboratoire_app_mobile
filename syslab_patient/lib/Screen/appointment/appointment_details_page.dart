import 'dart:developer';

import 'package:get/get.dart';
import 'package:patient/Screen/prescription/prescription_list_by_id_page.dart';
import 'package:patient/Service/Noftification/handle_firebase_notification.dart';
import 'package:patient/Service/Noftification/handle_local_notification.dart';
import 'package:patient/Service/admin_profile_service.dart';
import 'package:patient/Service/appointment_service.dart';
import 'package:patient/model/appointment_model.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/dialog_box.dart';
import 'package:patient/utilities/toast_msg.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppointmentDetailsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final appointmentDetails;
  bool isConn;
  AppointmentDetailsPage({Key key, this.appointmentDetails, this.isConn}) : super(key: key);
  @override
  _AppointmentDetailsPageState createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _appointmentTypeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _serviceTimeController = TextEditingController();
  final TextEditingController _appointmentIdController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _createdDateTimeController = TextEditingController();
  final TextEditingController _lastUpdatedController = TextEditingController();
  String _isBtnDisable = "false";
  bool _isLoading=false;

  @override
  void initState() {
     
    super.initState();

    _dateController.text = widget.appointmentDetails.appointmentDate;
    _timeController.text = widget.appointmentDetails.appointmentTime;
    _appointmentTypeController.text = widget.appointmentDetails.appointmentType;
    _serviceTimeController.text = (widget.appointmentDetails.serviceTimeMin).toString();
    _appointmentIdController.text = widget.appointmentDetails.id;
    _uIdController.text = widget.appointmentDetails.uId; //firebase user id
    _descController.text = widget.appointmentDetails.description;
    _createdDateTimeController.text = widget.appointmentDetails.createdTimeStamp;
    _lastUpdatedController.text = widget.appointmentDetails.updatedTimeStamp;
    _statusController.text=widget.appointmentDetails.appointmentStatus;

    if(widget.appointmentDetails.appointmentStatus=="Rejected"||widget.appointmentDetails.appointmentStatus=="Canceled"){
      setState(() {
        _isBtnDisable="";
      });
    }
  }

  @override
  void dispose() {
      
    super.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _appointmentTypeController.dispose();
    _serviceTimeController.dispose();
    _appointmentIdController.dispose();
    _uIdController.dispose();
    _descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationStateWidget(
            title:widget.appointmentDetails.appointmentStatus=="Visited"?"Obtenir les resultats":"Annuler",
            onPressed: widget.appointmentDetails.appointmentStatus=="Visited"?_handlePrescription:_takeConfirmation,
            clickable: _isBtnDisable
        ),
        drawer : _isLoading ? Container() : CustomDrawer(isConn: widget.isConn),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CAppBarWidget(
              title:"Appointment Details",
              isConn : widget.isConn,
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child:_isLoading ? const LoadingIndicatorWidget(): SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 0, right: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _inputTextField("Statut du rendez-vous", _statusController, 1),
                        _inputTextField("Date du rendez-vous", _dateController, 1),
                        _inputTextField("Heure du rendez-vous", _timeController, 1),
                        // _inputTextField("Appointment Minute", _serviceTimeController, 1),
                        // _inputTextField("Appointment ID", _appointmentIdController, 1),
                        // _inputTextField("User ID", _uIdController, 1),
                        // _inputTextField("Created on", _createdDateTimeController, 1),
                        // _inputTextField("Last update on", _lastUpdatedController, 1),
                        _inputTextField("Description, A propos de votre problème", _descController, null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
  _handlePrescription(){
    Get.to(() => PrescriptionListByIDPage(
        appointmentId: widget.appointmentDetails.id)
    );
  }
  Widget _inputTextField(String labelText, controller, maxLine) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLine,
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          // prefixIcon:Icon(Icons.,),
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  void _handleCancelBtn() async{
    setState(() {
      _isBtnDisable = "";
      _isLoading = true;
    });

    final appointmentModel=AppointmentModel(
        id: widget.appointmentDetails.id,
        appointmentStatus: "Canceled"
    );
    final isUpdated=await AppointmentService.updateStatus(appointmentModel);
    log(isUpdated.toString());
    if(isUpdated=="success"){
        _handleSendNotification();
        ToastMsg.showToastMsg("Annulé avec succès");
        Get.offAllNamed('/HomePage');
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //       '/Appointmentstatus', ModalRoute.withName('/HomePage'));
      } else {
        ToastMsg.showToastMsg("Quelque chose a mal tourné");
      }

    setState(() {
      _isBtnDisable = "false";
      _isLoading = false;
    });

  }

  void _handleSendNotification() async {
    final res = await AdminProfileService.getData();
    String  _adminFCMid = res[0].fcmId;
    //send local notification

    await HandleLocalNotification.showNotification(
      "Annulé",
      "Le rendez-vous a été annulé pour la date ${widget.appointmentDetails.appointmentDate}", // body
    );
    await AdminProfileService.updateIsAnyNotification("1");

    // send notification to admin app for booking confirmation
    await HandleFirebaseNotification.sendPushMessage(
        _adminFCMid, //admin fcm
        "Rendez-vous annulé", //title
        "${widget.appointmentDetails.uName} a annulé le rendez-vous pour la date ${widget.appointmentDetails.appointmentDate}. rendez-vous id: ${widget.appointmentDetails.id}"//body
    );
    

  }
  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Annuler", "Êtes-vous sûr de vouloir annuler le rendez-vous", _handleCancelBtn);
  }
}
