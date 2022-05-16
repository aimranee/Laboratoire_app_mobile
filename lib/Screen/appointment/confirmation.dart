import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/Login_SignUp.dart';
import 'package:laboratoire_app/Service/Firebase/updateData.dart';
import 'package:laboratoire_app/Service/Noftification/handleFirebaseNotification.dart';
import 'package:laboratoire_app/Service/Noftification/handleLocalNotification.dart';
import 'package:laboratoire_app/Service/appointmentService.dart';

import 'package:laboratoire_app/Service/drProfileService.dart';
import 'package:laboratoire_app/Service/notificationService.dart';
import 'package:laboratoire_app/SetData/screenArg.dart';
import 'package:laboratoire_app/model/appointmentModel.dart';
import 'package:laboratoire_app/model/notificationModel.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/utilities/toastMsg.dart';
import 'package:laboratoire_app/widgets/AuthScreen.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationPage extends StatefulWidget {
  ConfirmationPage({Key key}) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool _isLoading = false;
  String _isBtnDisable = "false";
  String _uId = "";
  String _uName = "";

  @override
  void initState() {
    // TODO: implement initState
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
      _uId = prefs.getString("uid");
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
          title: "Confirm Appointment",
          onPressed: () {
            //  Service.myfb(); //if you want to add something in all documents of one collection then you can invoke this method. this is for only the developing part.
            _updateBookedSlot(
              _patientDetailsArgs.pFirstName,
              _patientDetailsArgs.pLastName,
              _patientDetailsArgs.pPhn,
              _patientDetailsArgs.pEmail,
              _patientDetailsArgs.age,
              _patientDetailsArgs.gender,
              _patientDetailsArgs.pCity,
              _patientDetailsArgs.desc,
              _patientDetailsArgs.serviceName,
              _patientDetailsArgs.serviceTimeMIn,
              _patientDetailsArgs.selectedTime,
              _patientDetailsArgs.selectedDate, 
            ); // Method handles all the booking system operation.
          },
          clickable: _isBtnDisable,
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            _isLoading ? Container() : CAppBarWidget(title: "Booking Confirmation", isConn: _patientDetailsArgs.isConn),
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
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10, right: 10),
                          child: _isLoading
                              ? Center(child: LoadingIndicatorWidget())
                              : Center(
                                  child: Container(
                                      height: 250,
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
                color: appBarColor,
              ),
              child: const Center(
                child: Text(
                  "Please Confirm All Details",
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
              "Patient Name - ${args.pFirstName} ${args.pLastName}", style: kCardSubTitleStyle,
            ),
            const SizedBox(height: 10),
            Text("Service Name - ${args.serviceName}", style: kCardSubTitleStyle),
            const SizedBox(height: 10),
            Text("Service Time - ${args.serviceTimeMIn} Minute", style: kCardSubTitleStyle),
            const SizedBox(height: 10),
            Text("Date - ${args.selectedDate}", style: kCardSubTitleStyle),
            const SizedBox(height: 10),
            Text("Time - ${args.selectedTime}", style: kCardSubTitleStyle),
            const SizedBox(height: 10),
            Text("Mobile Number - ${args.pPhn}", style: kCardSubTitleStyle)
          ],
        ),
      ),
    );
  }

  void _updateBookedSlot(pFirstName, pLastName, pPhn, pEmail, age, gender,
      pCity, desc, serviceName, serviceTimeMin, setTime, selectedDate) async {
    setState(() {
      _isLoading = true;
      _isBtnDisable = "";
    });
    final pattern = RegExp('\\s+'); //remove all space
    final patientName = pFirstName + pLastName;
    String searchByName = patientName
        .toLowerCase()
        .replaceAll(pattern, ""); //lowercase all letter and remove all space

    final appointmentModel = AppointmentModel(
        pFirstName: pFirstName,
        pLastName: pLastName,
        pPhn: pPhn,
        pEmail: pEmail,
        age: age,
        gender: gender,
        pCity: pCity,
        description: desc,
        serviceName: serviceName,
        serviceTimeMin: serviceTimeMin,
        appointmentTime: setTime,
        appointmentDate: selectedDate,
        appointmentStatus: "Pending",
        searchByName: searchByName,
        uId: _uId,
        uName: _uName); //initialize all values
    final insertStatus = await AppointmentService.addData(appointmentModel);

    if (insertStatus != "error") {
      // print(":::::::::::::::::::::;$insertStatus");
      final updatedTimeSlotsStatus = await UpdateData.updateTimeSlot(
          serviceTimeMin, setTime, selectedDate, insertStatus);
      //if appoint details added successfully added

      if (updatedTimeSlotsStatus == "") {
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
          ToastMsg.showToastMsg("Successfully Booked");
        //   _handleSendNotification(
        //       pFirstName, pLastName, serviceName, selectedDate, setTime);
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     '/Appointmentstatus', ModalRoute.withName('/'));
          Get.offAllNamed('/HomePage');
        // } else if (msgAdded == "error") {
          // ToastMsg.showToastMsg("Something went wrong. try again");

          // Navigator.pop(context);
        // }
      } else {
        ToastMsg.showToastMsg("Something went wrong. try again");
        Navigator.pop(context);
      }
    } else {
      ToastMsg.showToastMsg("Something went wrong. try again");
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
    final res = await DrProfileService.getData(); //fetch admin fcm id for sending messages to admin
    if (res != null) {
      // setState(() {
      //   _adminFCMid = res[0].fdmId;
      // });
    }
    setState(() {
      _isLoading = false;
    });
  }

  // void _handleSendNotification(String firstName, String lastName,
  //     String serviceName, String selectedDate, String setTime) async {
  //   //send local notification

  //   await HandleLocalNotification.showNotification(
  //     "Successfully Booked", //title
  //     "Appointment has been booked on $selectedDate. Waiting for confirmation", // body
  //   );
  //   await UpdateData.updateIsAnyNotification("usersList", _uId, true);

  //   //send notification to admin app for booking confirmation
  //   print("++++++++++++admin$_adminFCMid");
  //   await HandleFirebaseNotification.sendPushMessage(
  //       _adminFCMid, //admin fcm
  //       "New Appointment", //title
  //       "$firstName $lastName booked an appointment on $selectedDate at $setTime" //body
  //       );

  //   await UpdateData.updateIsAnyNotification("profile", "profile", true);
  // }
}
