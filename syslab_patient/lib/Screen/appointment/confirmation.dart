import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient/Service/Noftification/handle_firebase_notification.dart';
import 'package:patient/Service/Noftification/handle_local_notification.dart';
import 'package:patient/Service/admin_profile_service.dart';
import 'package:patient/Service/appointment_service.dart';
import 'package:patient/Service/user_service.dart';
import 'package:patient/SetData/screen_arg.dart';
import 'package:patient/model/appointment_model.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/decoration.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/utilities/toast_msg.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({Key key}) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool _isLoading = false;
  String _adminFCMid;
  String _isBtnDisable = "false";
  String _uId = "";
  String _uName = "";

  @override
  void initState() {
     
    super.initState();
    _setAdminFcmId();
    _getAndSetUserData();
  }

  _getAndSetUserData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _uName = prefs.getString("firstName") + " " + prefs.getString("lastName");
      _uId = prefs.getString("uId");
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final PatientDetailsArg _patientDetailsArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      drawer : CustomDrawer(isConn: true),
        bottomNavigationBar: BottomNavigationStateWidget(
          title: "Confirmer le rendez-vous",
          onPressed: () {
            _updateBookedSlot(
              _patientDetailsArgs.pFirstName,
              _patientDetailsArgs.pLastName,
              _patientDetailsArgs.pPhn,
              _patientDetailsArgs.pEmail,
              _patientDetailsArgs.pCity,
              _patientDetailsArgs.desc,
              _patientDetailsArgs.analyses,
              _patientDetailsArgs.price,
              _patientDetailsArgs.appointmentType,
              _patientDetailsArgs.serviceTimeMIn,
              _patientDetailsArgs.selectedTime,
              _patientDetailsArgs.selectedDate,
              _patientDetailsArgs.location
            ); // Method handles all the booking system operation.
          },
          clickable: _isBtnDisable,
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            _isLoading ? Container() : CAppBarWidget(title: "Confirmation Réservation", isConn: true),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: IBoxDecoration.upperBoxDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                          child: _isLoading
                              ? const Center(
                                child: LoadingIndicatorWidget())
                              : Center(
                                  child: SizedBox(
                                      height: 500,
                                      width: double.infinity,
                                      child: _cardView(_patientDetailsArgs)),
                                )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));

    //    Container(
    //       color: bgColor,
    //       child: _isLoading
    //           ? Center(child: CircularProgressIndicator())
    //           : Center(
    //               child: Container(
    //                   height: 250,
    //                   width: double.infinity,
    //                   child: _cardView(patientDetailsArgs)),
    //             )),
    // );
  }

  Widget _cardView(args) {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appBarColor,
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
            Text("Nom du patient : ${args.pFirstName} ${args.pLastName}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Type de service : ${args.appointmentType}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Temps de service : ${args.serviceTimeMIn} Minute", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Date : ${args.selectedDate}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Temps : ${args.selectedTime}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Numéro de téléphone : ${args.pPhn}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Prix total : ${args.price} Dhs", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            const Text("Analyses : ", style: kCardSubTitleStyle),
            const SizedBox(height: 7),
            Text(args.analyses, style: kCardSubTitleStyle),
          ],
        ),
      ),
    );
  }

  void _updateBookedSlot(pFirstName, pLastName, pPhn, pEmail, pCity, desc, analyses, price, appointmentType, serviceTimeMin, setTime, selectedDate, location) async {
    setState(() {
      _isLoading = true;
      _isBtnDisable = "";
    });

    DateTime now = DateTime.now();
    String createdTime = DateFormat('yyyy-MM-dd hh:mm').format(now);

    final appointmentModel = AppointmentModel(
        description: desc,
        appointmentType: appointmentType,
        serviceTimeMin: serviceTimeMin,
        appointmentTime: setTime,
        appointmentDate: selectedDate,
        appointmentStatus: "Pending",
        uId: _uId,
        price: price.toString(),
        analyses: analyses,
        uName: _uName,
        location: location,
        createdTimeStamp: createdTime,
        updatedTimeStamp: createdTime,); //initialize all values
    final insertStatus = await AppointmentService.addData(appointmentModel);

    if (insertStatus != "error") {
      // //print(":::::::::::::::::::::;$insertStatus");
      //if appoint details added successfully added

      // if (updatedTimeSlotsStatus == "") {
        // final notificationModel = NotificationModel(
        //     title: "Successfully Booked",
        //     body:
        //         "Appointment has been booked on $selectedDate. Waiting for confirmation",
        //     uId: _uId,
        //     routeTo: "/Appointmentstatus",
        //     sendBy: "user",
        //     sendFrom: _uName,
        //     sendTo: "Admin");
        // final notificationModelForAdmin = NotificationModel(
        //     title: "New Appointment",
        //     body:
        //         "$pFirstName $pLastName booked an appointment on $selectedDate at $setTime",
        //     uId: _uId,
        //     sendBy: _uName);

        // final msgAdded = await NotificationService.addData(notificationModel);

        // if (msgAdded == "success") {
        //   await NotificationService.addDataForAdmin(notificationModelForAdmin);
          _handleSendNotification(
              pFirstName, pLastName, appointmentType, selectedDate, setTime);
              
          ToastMsg.showToastMsg("Réservé avec succès");
          Get.offAllNamed('/HomePage');
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     '/Appointmentstatus', ModalRoute.withName('/HomePage'));
        // } else if (msgAdded == "error") {
          // ToastMsg.showToastMsg("Quelque chose s'est mal passé. try again");

          // Navigator.pop(context);
        // }
      // } else {
      //   ToastMsg.showToastMsg("Quelque chose s'est mal passé. try again");
      //   Navigator.pop(context);
      // }
    } else {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé. Essayez à nouveau");
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
    final res = await AdminProfileService.getData(); //fetch admin fcm id for sending messages to admin
    if (res != null) {
      setState(() {
        _adminFCMid = res[0].fcmId;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleSendNotification(String firstName, String lastName,
      String appointmentType, String selectedDate, String setTime) async {
    //send local notification
    await HandleLocalNotification.showNotification(
      "Réservé avec succès", //title
      "Le rendez-vous a été pris le $selectedDate. En attente de confirmation", // body
    );
    await UserService.updateIsAnyNotification("1");

    //send notification to admin app for booking confirmation
    // log("++++++++++++admin$_adminFCMid");
    await HandleFirebaseNotification.sendPushMessage(
        _adminFCMid, //admin fcm
        "Nouveau rendez-vous", //title
        "$firstName $lastName pris rendez-vous le $selectedDate à $setTime" //body
        );

    await AdminProfileService.updateIsAnyNotification("1");
  }
}
