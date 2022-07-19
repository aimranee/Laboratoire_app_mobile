import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syslab_admin/model/appointment_model.dart';
import 'package:syslab_admin/screens/prescription/prescription_list_page.dart';
import 'package:syslab_admin/service/appointment_service.dart';
import 'package:syslab_admin/service/notification/firebase_notification.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';
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

class _EditAppointmentDetailsPageState extends State<EditAppointmentDetailsPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEnableBtn = true;
  bool _isLoading = false;
  int _groupValue = -1;
  double latitude = 0;
  double longitude = 0;
  String uId = "";

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _appointmentTypeController = TextEditingController();
  final TextEditingController _serviceTimeController = TextEditingController();
  final TextEditingController _appointmentIdController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _analysesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();

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
    _cinController.text = widget.appointmentDetails.cin;
    
    if (widget.appointmentDetails.appointmentStatus == "Rejected"||widget.appointmentDetails.appointmentStatus == "Canceled") {
      setState(() {
        _isEnableBtn = false;
      });
    }
    if (widget.appointmentDetails.location != "") {
        final locationPatient = widget.appointmentDetails.location.split(',');
        setState(() {
          latitude = double.parse(locationPatient[0]);
          longitude = double.parse(locationPatient[1]);
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
    _cinController.dispose();
    super.dispose();
  }
  _handlePrescriptionBtn(){
    Get.to(()=>PrescriptionListByIDPage(
            appointmentId: widget.appointmentDetails.id,
            userId: widget.appointmentDetails.uId,
            patientName: widget.appointmentDetails.uName,
            time: widget.appointmentDetails.appointmentTime,
            date: widget.appointmentDetails.appointmentDate,
            appointmentType: widget.appointmentDetails.appointmentType,
            price: widget.appointmentDetails.price
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.appointmentDetails.appointmentStatus  ==
          "Rejected" ||
        widget.appointmentDetails.appointmentStatus ==
          "Visited" ||
        widget.appointmentDetails.appointmentStatus =="Canceled"
        ? AppBar(
        title: const Text("Edit Details", style: kAppBarTitleStyle,),
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: (){
            DialogBoxes.confirmationBox(
                context, "Supprimer", "Voulez-vous vraiment supprimer le rendez-vous ?", (){
                _handleDeleteAppointment();
              });
            }, icon:const Icon(Icons.delete))
          ],
        ):IAppBars.commonAppBar(context, "Tous les rendez-vous"),
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
            "Visited" ||
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
                InputFields.readableInputField(_cinController, "CIN Patient", 1),
                InputFields.readableInputField(_dateController, "Appointment Date", 1),
                InputFields.readableInputField(_timeController,  "Appointment Time", 1),
                InputFields.readableInputField(_appointmentTypeController,  "Appointment Type", 1),
                InputFields.readableInputField(_analysesController,  "Analyses", 1),
                InputFields.readableInputField(_priceController,  "Prix", 1),
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
                      "Pardon! Vous ne pouvez pas modifier ce rendez-vous"),
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
                        children: const [
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
                        children: const [
                          // Expanded(
                          //     flex: 1,
                          //     child:
                          //         _roundedRejectBtn("Reject", "Rejected"))
                        ],
                      ),
                if (latitude != 0)
                  _locationPatient(),
                const SizedBox(height:30),
              ]),
        ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Mise à jour", "Voulez-vous vraiment mettre à jour", _handleUpdate);
  }

  _handleUpdate() async {

    if (_formKey.currentState.validate()) {
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
      DateTime now = DateTime.now();
      String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
      final appointmentModel= AppointmentModel(
          id: widget.appointmentDetails.id,
          description: _descController.text,
          updatedTimeStamp: createdTimeStamp
      );
      final res=await AppointmentService.updateData(appointmentModel);
      if (res == "success") {
        ToastMsg.showToastMsg("Mise à jour réussie");
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
    //       appointmentType: widget.appointmentDetails.appointmentType,

    //     ),
    //   ),
    // );
  // }

  _handleRejectAppointment() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

      DateTime now = DateTime.now();
      String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
      final appointmentModel=AppointmentModel(
          id: widget.appointmentDetails.id,
          appointmentStatus: "Rejected",
          updatedTimeStamp: createdTimeStamp
      );
      final isUpdated=await AppointmentService.updateStatus(appointmentModel);
      if(isUpdated=="success"){
         _sendNotification("Rejected");
        ToastMsg.showToastMsg("Mise à jour réussie");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      } else {
        ToastMsg.showToastMsg("Quelque chose s'est mal passé");
      }

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
    DateTime now = DateTime.now();
    String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final appointmentModel=AppointmentModel(
        id: widget.appointmentDetails.id,
        appointmentStatus: "Visited",
        updatedTimeStamp: createdTimeStamp
    );
    final isUpdated=await AppointmentService.updateStatus(appointmentModel);
    if(isUpdated=="success"){
      _sendNotification("Visited");
      ToastMsg.showToastMsg("Mise à jour réussie");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
    }

    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _handleAppointmentStatus(String appointmentId, String status) async {

    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });
    DateTime now = DateTime.now();
    String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final appointmentModel=AppointmentModel(
        id: appointmentId,
        appointmentStatus: status,
        updatedTimeStamp: createdTimeStamp
    );
    final res = await AppointmentService.updateStatus(appointmentModel);
    // log(uId + appointmentId + status);
    // log ("aimrane");
    if (res == "success") {
      _sendNotification(status);
      ToastMsg.showToastMsg("Mise à jour réussie");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
  }

  _sendNotification(String title) async {
    String body = "";
    switch (title) {
      case "Visited":
        {
          body = "Merci pour votre visite. Veuillez visiter à nouveau";
          break;
        }
      case "Confirmed":
        {
          body =
          "Votre rendez-vous a été confirmé pour la date : ${widget.appointmentDetails.appointmentDate} temps: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Pending":
        {
          body =
          "Votre rendez-vous est en attente depuis date: ${widget.appointmentDetails.appointmentDate} temps: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Rejected":
        {
          body =
          "Pardon! votre rendez-vous a été refusé pour date: ${widget.appointmentDetails.appointmentDate} temps: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      default:
        {
          body = "";
        }
    }

      final res = await AdminService.getUserFcm(widget.appointmentDetails.uId); //get fcm id of specific user
      FirebaseNotification.sendPushMessage(res[0].fcmId, title, body);

      await PatientService.updateIsAnyNotification("1", widget.appointmentDetails.uId);
  }
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
            title: const Text("Choisissez un statut"),
            content: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    _myRadioButton(
                      title: "Confirmed",
                      value: 0,
                      onChanged: (newValue)=> setState(() => _groupValue = newValue),
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

  _handleDeleteAppointment()async{
    setState(() {
      _isLoading=true;
      _isEnableBtn=false;
    });
    // log (" : "+widget.appointmentDetails.id);
    final res=await AppointmentService.deleteData(widget.appointmentDetails.id);
    if(res=="success"){
      ToastMsg.showToastMsg("Supprimé avec succès");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    }
    else{
      ToastMsg.showToastMsg("Something went wrong");

    }
    setState(() {
      _isLoading=false;
      _isEnableBtn=true;
    });
  }
  
  _locationPatient () {
    final Completer<GoogleMapController> _controller = Completer();

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 15.6
    );
    final List<Marker> _markers = [];
      _markers.add(
        Marker(
          markerId: const MarkerId('SomeId'),
          position: LatLng(latitude, longitude),
          infoWindow: const InfoWindow(
              title: 'Emplacement du patient'
          )
        )
      );
    return Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 25, top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * .39,
                width: MediaQuery.of(context).size.width * .8,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Card(
                    // color: Colors.black,
                    elevation: 10.0,
                    child: 
                    GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      markers: Set<Marker>.of(_markers),
                      onMapCreated: (GoogleMapController controller){
                        _controller.complete(controller);
                      }
                    )
                  )
                ),
            )
          ],
        ),
      );
  }

}
