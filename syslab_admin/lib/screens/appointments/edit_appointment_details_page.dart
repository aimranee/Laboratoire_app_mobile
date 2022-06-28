import 'dart:developer';

import 'package:syslab_admin/model/appointment_model.dart';
import 'package:syslab_admin/service/appointment_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';

class EditAppointmentDetailsPage extends StatefulWidget {
  final appointmentDetails;
  const EditAppointmentDetailsPage({Key key, this.appointmentDetails})
      : super(key: key);
  @override
  _EditAppointmentDetailsPageState createState() =>
      _EditAppointmentDetailsPageState();
}

class _EditAppointmentDetailsPageState
    extends State<EditAppointmentDetailsPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isEnableBtn = true;
  bool _isLoading = false;
  int _groupValue = -1;
  String _selectedGender="";


  // final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _latsNameController = TextEditingController();
  // final TextEditingController _ageController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  // final TextEditingController _phnController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _appointmentTypeController = TextEditingController();
  final TextEditingController _serviceTimeController = TextEditingController();
  final TextEditingController _appointmentIdController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _analysesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  // final TextEditingController _createdDateTimeController = TextEditingController();
  // final TextEditingController _lastUpdatedController = TextEditingController();
  final TextEditingController _uNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _uNameController.text = widget.appointmentDetails.uName;
    _dateController.text = widget.appointmentDetails.appointmentDate;
    _timeController.text = widget.appointmentDetails.appointmentTime;
    _appointmentTypeController.text = widget.appointmentDetails.appointmentType;
    _serviceTimeController.text = widget.appointmentDetails.serviceTimeMin.toString();
    _appointmentIdController.text = widget.appointmentDetails.id;
    _uIdController.text = widget.appointmentDetails.uId;
    _analysesController.text = widget.appointmentDetails.analyses;
    _priceController.text = widget.appointmentDetails.price;
    _descController.text = widget.appointmentDetails.description;

    if (widget.appointmentDetails.appointmentStatus == "Rejected"||widget.appointmentDetails.appointmentStatus == "Canceled") {
      setState(() {
        _isEnableBtn = false;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    _uNameController.dispose();
    _analysesController.dispose();
    _priceController.dispose();
    _timeController.dispose();
    _appointmentTypeController.dispose();
    _serviceTimeController.dispose();
    _appointmentIdController.dispose();
    _uIdController.dispose();
    _descController.dispose();
    super.dispose();
  }
  _handlePrescriptionBtn(){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => PrescriptionListByIDPage(
    //         appointmentId: widget.appointmentDetails.id,
    //         userId: widget.appointmentDetails.uId,
    //         patientName: widget.appointmentDetails.pFirstName+" "+ widget.appointmentDetails.pLastName,
    //         time: widget.appointmentDetails.appointmentTime,
    //         date: widget.appointmentDetails.appointmentDate,
    //         serviceName: widget.appointmentDetails.serviceName ,
    //       )
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Edit Details"),
        bottomNavigationBar: BottomNavBarWidget(
          title: widget.appointmentDetails.appointmentStatus ==
              "Visited"?"Prescription": "Update",
          onPressed:widget.appointmentDetails.appointmentStatus ==
              "Visited"?_handlePrescriptionBtn: _takeConfirmation,
          isEnableBtn:widget.appointmentDetails.appointmentStatus ==
              "Visited"?true: _isEnableBtn,
        ),
        floatingActionButton:  widget.appointmentDetails.appointmentStatus  ==
            "Rejected" ||
            widget.appointmentDetails.appointmentStatus ==
                "Visited"||
            widget.appointmentDetails.appointmentStatus =="Canceled"

            ? null: FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
              icon: const Icon(Icons.format_list_bulleted_sharp),
              onPressed: showDialogBox,
            ),
            backgroundColor:btnColor,
            onPressed: (){}
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Form(
          key: _formKey,
          child: ListView(

              children: [
                InputFields.commonInputField(_uNameController, "Patient Name", (item) {
                  return item.length > 0 ? null : "Enter last name";
                }, TextInputType.text, 1),
                InputFields.readableInputField(_dateController, "Appointment Date", 1),
                InputFields.readableInputField(_timeController,  "Appointment Time", 1),
                InputFields.readableInputField(_appointmentTypeController,  "Appointment Type", 1),
                InputFields.readableInputField(_analysesController,  "Analyses", 1),
                InputFields.readableInputField(_priceController,  "Prix", 1),
                // InputFields.readableInputField(_serviceTimeController,   "Service Time", 1),
                InputFields.readableInputField(_appointmentIdController,  "Appointment id", 1),
                InputFields.readableInputField(_uIdController, "User Id", 1),
                InputFields.commonInputField(_descController, "Description, About problem", (item) {
                  if (item.isEmpty) {
                    return null;
                  } else {
                    return item.length > 0
                        ? null
                        : "Enter Description";
                  }
                }, TextInputType.text, 5),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      const Text("Appointment Status:     "),
                      if ( widget.appointmentDetails.appointmentStatus  ==
                          "Confirmed")
                        _statusIndicator(Colors.green)
                      else if ( widget.appointmentDetails.appointmentStatus  ==
                          "Pending")
                        _statusIndicator(Colors.yellowAccent)
                      else if (
                        widget.appointmentDetails.appointmentStatus  ==
                            "Rejected")
                          _statusIndicator(Colors.red)
                        else if (
                          widget.appointmentDetails.appointmentStatus  ==
                              "Rescheduled")
                            _statusIndicator(Colors.orangeAccent)
                          else
                            Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                            "${ widget.appointmentDetails.appointmentStatus }",
                            style: const TextStyle(
                              fontFamily: 'OpenSans-SemiBold',
                              fontSize: 15,
                            )),
                      ),
                    ],
                  ),
                ),
                widget.appointmentDetails.appointmentStatus == "Rejected"||
                    widget.appointmentDetails.appointmentStatus ==
                        "Visited"||
                    widget.appointmentDetails.appointmentStatus =="Canceled"
                    ? const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                      "Sorry! You can not edit this appointment"),
                )
                    : Container(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Divider(),
                ),
                // widget.appointmentDetails.appointmentStatus ==
                //             "Rejected" ||
                //     widget.appointmentDetails.appointmentStatus ==
                //             "Done"
                //     ? Container()
                //     : _roundedDoneBtn("Done", "Done"),
                widget.appointmentDetails.appointmentStatus ==
                            "Rejected" ||
                    widget.appointmentDetails.appointmentStatus ==
                            "Done"
                    ? //if rejected then not show anything, now user have to make a new appointment
                    Container()
                    : Row(
                        //if not rejected
                        children: [
                          // Expanded(
                          //     flex: 1,
                          //     child: _roundedBtn("Confirmed", "Confirmed")),
                          // Expanded(
                          //     flex: 1,
                          //     child: _roundedBtn("Pending", "Pending")),
                        ],
                      ),
                widget.appointmentDetails.appointmentStatus  ==
                            "Rejected" ||
                    widget.appointmentDetails.appointmentStatus ==
                            "Done"
                    ? //if rejected then not show anything, now user have to make a new appointment
                    Container()
                    : Row(
                        //if not rejected
                        children: [
                          // Expanded(
                          //     flex: 1,
                          //     child:
                          //         _roundedRejectBtn("Reject", "Rejected"))
                        ],
                      ),
              ]),
        ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update", _handleUpdate);
  }

  _handleUpdate() async {

    if (_formKey.currentState.validate()) {
      log("hihihih");
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });

      // final pattern = RegExp('\\s+'); //remove all space
      // final fullName = _firstNameController.text + _latsNameController.text;
      // String searchByName = fullName.toLowerCase().replaceAll(pattern, "");

      final appointmentModel= AppointmentModel(
          id:  widget.appointmentDetails.id,
          description: _descController.text,
      );
      final res=await AppointmentService.updateData(appointmentModel);
      if (res == "success") {
        ToastMsg.showToastMsg("Successfully Updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      } else if (res == "error") {
        ToastMsg.showToastMsg("Something wents wrong");
      }
      setState(() {
        _isEnableBtn = true;
        _isLoading = false;
      });
    }

    // _images.length > 0 ? _uploadImg() : _uploadNameAndDesc("");
  }

  // _handleRescheduleBtn() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChooseTimeSlotsPage(
    //       serviceTimeMin: widget.appointmentDetails.serviceTimeMin,
    //       appointmentId: widget.appointmentDetails.id,
    //       appointmentDate: widget.appointmentDetails.appointmentDate,
    //       uId: widget.appointmentDetails.uId,
    //       uName: "${widget.appointmentDetails.uName
    //       }",
    //       serviceName: widget.appointmentDetails.serviceName,

    //     ),
    //   ),
    // );
  // }

  _handleRejectAppointment() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    // final res = await DeleteData.deleteBookedAppointment(
    //   widget.appointmentDetails.id,
    //   widget.appointmentDetails.appointmentDate,
    // );
    // if (res == "success") {
      final appointmentModel=AppointmentModel(
          id: widget.appointmentDetails.id,
          appointmentStatus: "Rejected"
      );
      final isUpdated=await AppointmentService.updateStatus(appointmentModel);
      if(isUpdated=="success"){
        // await  _sendNotification("Rejected");
        ToastMsg.showToastMsg("Successfully Updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      } else {
        ToastMsg.showToastMsg("Something went wrong");
      }

    // } else {
    //   ToastMsg.showToastMsg("Something went wrong");
    // }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _handleDoneAppointment() async {

    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    final appointmentModel=AppointmentModel(
        id: widget.appointmentDetails.id,
        appointmentStatus: "Visited"
    );
    final isUpdated=await AppointmentService.updateStatus(appointmentModel);
    if(isUpdated=="success"){
      // _sendNotification("Visited");
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }

    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _handleAppointmentStatus(String appointmentId, String status) async {
    //print(uId + appointmentId + status);
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });
    final appointmentModel=AppointmentModel(
        id: appointmentId,
        appointmentStatus: status
    );

    final res = await AppointmentService.updateStatus(appointmentModel);
    if (res == "success") {
      // await  _sendNotification(status);
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
  }

  // _sendNotification(String title) async {
  //   String body = "";
  //   switch (title) {
  //     case "Visited":
  //       {
  //         body = "Thank you for visiting. Please visit again";
  //         break;
  //       }
  //     case "Confirmed":
  //       {
  //         body =
  //         "Your appointment has been confirmed for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
  //         break;
  //       }
  //     case "Pending":
  //       {
  //         body =
  //         "Your appointment has been pending for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
  //         break;
  //       }
  //     case "Rejected":
  //       {
  //         body =
  //         "Sorry! your appointment has been rejected for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
  //         break;
  //       }
  //     default:
  //       {
  //         body = "";
  //       }
  //   }
  //   // final notificationModel = NotificationModel(
  //   //     title: title,
  //   //     body:body,
  //   //     uId: widget.appointmentDetails.uId,
  //   //     routeTo: "/Appointmentstatus",
  //   //     sendBy: "admin",
  //   //     sendFrom: "Admin",
  //   //     sendTo: widget.appointmentDetails.uName);
  //   // final msgAdded = await NotificationService.addData(notificationModel);
  //   // if (msgAdded == "success") {
  //   //   final res = await UserService.getUserById(widget.appointmentDetails.uId); //get fcm id of specific user

  //   //   HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
  //   //   await UpdateData.updateIsAnyNotification("usersList", widget.appointmentDetails.uId, true);
  //   // }
  // }
  showDialogBox() {

    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text("Choose a status"),
            content: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    _myRadioButton(
                        title: "Confirmed",
                        value: 0,
                        onChanged: (newValue)=> setState(() {
                          _groupValue = newValue;
                        })
                    ),
                    _myRadioButton(
                      title: "Visited",
                      value: 1,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Pending",
                      value: 2,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Reject",
                      value: 3,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    ),

                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: const Text("OK",style: TextStyle(
                      color: Colors.white
                  ),),
                  onPressed: () {
                    switch (_groupValue){
                      case 0: {
                        Navigator.of(context).pop();
                        _handleAppointmentStatus(
                            widget.appointmentDetails.id, "Confirmed");
                      }

                      break;
                      case 1:{ Navigator.of(context).pop();
                      _handleDoneAppointment();
                      }

                      break;
                      case 2:{ Navigator.of(context).pop();
                      _handleAppointmentStatus(
                          widget.appointmentDetails.id, "Pending");}

                      break;
                      case 3:{ Navigator.of(context).pop();
                        _handleRejectAppointment();}
                      
                      break;
                      default: log(
                          "Not Select");
                      break;
                    }


                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: const Text("Cancel",style: TextStyle(
                      color: Colors.white
                  ),),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }
  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: btnColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

}
