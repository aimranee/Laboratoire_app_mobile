import 'package:intl/intl.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/service/appointment_service.dart';
import 'package:syslab_admin/model/appointment_model.dart';
import 'package:syslab_admin/service/notification/firebase_notification.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/font_style.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ConfirmationPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String location;
  final String analyses;
  final double price;
  final String city;
  final String cin;
  final String des;
  final String appointmentType;
  final int serviceTimeMin;
  final String setTime;
  final String selectedDate;
  final String uId;
  final String userFcmId;
  const ConfirmationPage(
      {Key key,
      this.serviceTimeMin,
      this.setTime,
      this.selectedDate,
      this.appointmentType,
      this.phoneNumber,
      this.lastName,
      this.email,
      this.cin,
      this.firstName,
      this.city,
      this.location,
      this.analyses,
      this.price,
      this.des,
      this.uId,
      this.userFcmId})
      : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  String _adminFCMid = "";
  bool _isLoading = false;
  String _isBtnDisable = "false";
  String _uId = "";
  String _uName = "";
  String _userFCMid = "";

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _uId = widget.uId;
      _uName = widget.firstName + " " + widget.lastName;
      _userFCMid = widget.userFcmId;
    });
    _setAdminFcmId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Confirmation"),
      bottomNavigationBar: BottomNavBarWidget(
        isEnableBtn: _isBtnDisable=="false"?true:false,
        title: "Confirmer le rendez-vous",
        onPressed: () {
          _updateBookedSlot(); // Method handles all the booking system operation.
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                child: _isLoading
                    ? const Center(child: LoadingIndicatorWidget())
                    : Center(
                        child: SizedBox(
                            height: 450,
                            width: double.infinity,
                            child: _cardView()),
                      )),
          ],
        ),
      ),
    );
  }

  Widget _cardView() {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: btnColor,
              ),
              child: const Center(
                child: Text(
                  "Veuillez confirmer tous les détails",
                  style: TextStyle(
                    fontFamily: 'OpenSans-SemiBold',
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const Divider(),
            Text(
              "Nom du patient : ${widget.firstName} ${widget.lastName}",
              style: kCardSubTitleStyle,
            ),
            const SizedBox(height: 17),
            Text("Type de service : ${widget.appointmentType}",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Temps de service : ${widget.serviceTimeMin} Minute",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Date : ${widget.selectedDate}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Temps : ${widget.setTime}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("CIN patient : ${widget.cin}",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Prix total : ${widget.price} Dhs", 
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Numéro de téléphone : ${widget.phoneNumber}",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            const Text("Analyses : ", style: kCardSubTitleStyle),
            const SizedBox(height: 7),
            Text(widget.analyses, style: kCardSubTitleStyle),
          ],
        ),
      ),
    );
  }

  void _updateBookedSlot() async {

    setState(() {
      _isLoading = true;
      _isBtnDisable = "";
    });
    DateTime now = DateTime.now();
    String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final appointmentModel = AppointmentModel(
        uName: _uName,
        cin: widget.cin,
        analyses: widget.analyses,
        price: widget.price.toString(),
        description: widget.des,
        appointmentType: widget.appointmentType,
        serviceTimeMin: widget.serviceTimeMin,
        appointmentTime: widget.setTime,
        appointmentDate: widget.selectedDate,
        appointmentStatus: "Pending",
        uId: _uId,
        location: widget.location,
        createdTimeStamp:createdTimeStamp,
        updatedTimeStamp:createdTimeStamp,
    ); //initialize all values
    final insertStatus = await AppointmentService.addData(appointmentModel);

    if (insertStatus == "success") {
      // log(":::::::::::::::::::::;$insertStatus");
      
          ToastMsg.showToastMsg("Réservé avec succès");
          _handleSendNotification(widget.firstName, widget.lastName,
              widget.appointmentType, widget.selectedDate, widget.setTime);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/UsersListPage', ModalRoute.withName('/HomePage'));

    } else {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé. try again");
      Navigator.pop(context);
    }

    setState(() {
      _isLoading = false;
      _isBtnDisable = "false";
    });
  }

  void _setAdminFcmId() async {
    //loading if data till data fetched
    setState(() {
      _isLoading = true;
    });
    //fetch admin fcm id for sending messages to admin
    final fcmId = await FirebaseMessaging.instance.getToken();
    setState(() {
      _adminFCMid = fcmId;
    });
    setState(() {
      _isLoading = false;
    });
  }

  void _handleSendNotification(String firstName, String lastName,
      String appointmentType, String selectedDate, String setTime) async {
    //send notification to user
    await FirebaseNotification.sendPushMessage(
      _userFCMid, //admin fcm
      "Réservé avec succès", //title
      "Le rendez-vous a été pris le $selectedDate. En attente de confirmation", // body
    );
    await PatientService.updateIsAnyNotification("1", _uId);

    //send notification to admin app for booking confirmation
    // log("++++++++++++admin$_adminFCMid");
    await FirebaseNotification.sendPushMessage(
        _adminFCMid, //admin fcm
        "Nouveau rendez-vous", //title
        "$firstName $lastName pris rendez-vous le $selectedDate à $setTime" //body
        );

    await AdminService.updateIsAnyNotification("1");
  }

}
