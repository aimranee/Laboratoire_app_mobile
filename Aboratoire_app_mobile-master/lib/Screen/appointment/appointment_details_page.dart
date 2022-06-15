import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/home.dart';
import 'package:laboratoire_app/Screen/prescription/prescription_list_by_id_page.dart';
import 'package:laboratoire_app/Service/appointment_service.dart';
import 'package:laboratoire_app/model/appointment_model.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/dialog_box.dart';
import 'package:laboratoire_app/utilities/toast_msg.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
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
    // final res = await DeleteData.deleteBookedAppointment(
    //   widget.appointmentDetails.id,
    //   widget.appointmentDetails.appointmentDate,
    // );
    // if (res == "success") {
      final appointmentModel=AppointmentModel(
          id: widget.appointmentDetails.id,
          appointmentStatus: "Canceled"
      );
      final isUpdated=await AppointmentService.updateStatus(appointmentModel);
      if(isUpdated=="success"){
        // final notificationModel = NotificationModel(
        //     title: "Canceled",
        //     body:
        //     "Appointment has been canceled for date ${widget.appointmentDetails.appointmentDate}. appointment id: ${widget.appointmentDetails.id}",
        //     uId: widget.appointmentDetails.uId,
        //     routeTo: "/Appointmentstatus",
        //     sendBy: "user",
        //     sendFrom: "${widget.appointmentDetails.pFirstName} ${widget.appointmentDetails.pLastName}",
        //     sendTo: "Admin");
        // final notificationModelForAdmin = NotificationModel(
        //     title: "Canceled Appointment",
        //     body:
        //     "${widget.appointmentDetails.pFirstName} ${widget.appointmentDetails.pLastName} has canceled appointment for date ${widget.appointmentDetails.appointmentDate}. appointment id: ${widget.appointmentDetails.id}",//body
        //     uId: widget.appointmentDetails.uId,
        //     sendBy: "${widget.appointmentDetails.pFirstName} ${widget.appointmentDetails.pLastName}"
        // );
        // await NotificationService.addData(notificationModel);
        // _handleSendNotification();
        // await NotificationService.addDataForAdmin(notificationModelForAdmin);
        ToastMsg.showToastMsg("Annulé avec succès");
        Get.off(()=>const HomeScreen());
      } else {
        ToastMsg.showToastMsg("Quelque chose a mal tourné");
      }

    // } else {
    //   ToastMsg.showToastMsg("Something went wrong");
    // }
    setState(() {
      _isBtnDisable = "false";
      _isLoading = false;
    });

  }

  // void _handleSendNotification() async {
  //   final res = await DrProfileService.getData();
  //   String  _adminFCMid = res[0].fdmId;
  //   //send local notification

  //   // await HandleLocalNotification.showNotification(
  //   //   "Canceled",
  //   //   "Appointment has been canceled for date ${widget.appointmentDetails.appointmentDate}", // body
  //   // );
  //   // await UpdateData.updateIsAnyNotification("usersList", widget.appointmentDetails.uId, true);

  //   //send notification to admin app for booking confirmation
  //   // await HandleFirebaseNotification.sendPushMessage(
  //   //     _adminFCMid, //admin fcm
  //   //     "Canceled Appointment", //title
  //   //     "${widget.appointmentDetails.uName} has canceled appointment for date ${widget.appointmentDetails.appointmentDate}. appointment id: ${widget.appointmentDetails.id}"//body
  //   // );
  //   await UpdateData.updateIsAnyNotification("profile", "profile", true);

  // }
  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Annuler", "Êtes-vous sûr de vouloir annuler le rendez-vous", _handleCancelBtn);
  }
}
