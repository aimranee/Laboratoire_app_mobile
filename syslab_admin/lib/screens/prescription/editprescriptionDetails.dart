
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:syslab_admin/model/prescription_model.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/service/notification/firebase_notification.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/service/prescription_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';
import 'package:syslab_admin/utilities/font_style.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class PrescriptionDetailsPage extends StatefulWidget {
  final String title;
  final prescriptionDetails;
   const PrescriptionDetailsPage({Key key, this.title,this.prescriptionDetails}) : super(key: key);
  @override
  _PrescriptionDetailsPageState createState() => _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState extends State<PrescriptionDetailsPage> {
  final TextEditingController _appointmentTypeController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _drNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _resultsController = TextEditingController();

  int _groupValue = -1;
  bool _isLoading = false;
  bool _isEnableBtn = true;
  String _isPaiedStatus = "0";
  String isPaiedString = "Non Validé";
  String _prescriptionStatus = "";

final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _appointmentTypeController.text=widget.prescriptionDetails.appointmentName;
      _patientNameController.text=widget.prescriptionDetails.patientName;
      _drNameController.text=widget.prescriptionDetails.drName;
      _isPaiedStatus = widget.prescriptionDetails.isPaied;
      _dateController.text=widget.prescriptionDetails.appointmentDate;
      _timeController.text=widget.prescriptionDetails.appointmentTime;
      _priceController.text=widget.prescriptionDetails.price;
      _resultsController.text=widget.prescriptionDetails.results;
      _prescriptionStatus =widget.prescriptionDetails.prescriptionStatus;

    });
    super.initState();
    // log("${_imageUrls.length}");
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _appointmentTypeController.dispose();
    _patientNameController.dispose();
    _drNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  _takeUpdateConfirmation(){
    DialogBoxes.confirmationBox(
        context, "Mise à jour", "Voulez-vous vraiment mettre à jour les détails ?", _handleUpdate);
  }

  _handleUpdate()async {
    if (_formKey.currentState.validate()) {

      setState(() {
        _isLoading = true;
        _isEnableBtn = false;
      });
      if (_resultsController.text.isNotEmpty){
        _prescriptionStatus = "Terminé";
      }

      DateTime now = DateTime.now();
      String _createdTime = DateFormat('yyyy-MM-dd').format(now);
      PrescriptionModel prescriptionModel = PrescriptionModel(
          id: widget.prescriptionDetails.id,
          drName: _drNameController.text,
          isPaied: _isPaiedStatus,
          results: _resultsController.text,
          prescriptionStatus: _prescriptionStatus,
          updatedTimeStamp : _createdTime
      );
      // log(">>>>>>>>>>>>>>>>>>>>>>${prescriptionModel.toJsonUpdate()}");
      final res = await PrescriptionService.updateData(prescriptionModel);
      if (res == "success") {
        ToastMsg.showToastMsg("Mise à jour réussie");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      }
      else {
        ToastMsg.showToastMsg("Quelque chose s'est mal passé");
      }

      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: kAppBarTitleStyle,),
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: (){
            DialogBoxes.confirmationBox(
                context, "Supprimer", "Voulez-vous vraiment supprimer la prescription ?", (){
              _handleDeletePrescription();
            });
          }, icon:const Icon(Icons.delete))
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Mise à jour",
        onPressed:_takeUpdateConfirmation,
        isEnableBtn:_isEnableBtn,
      ),
      
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
              icon: const Icon(Icons.format_list_bulleted_sharp),
              onPressed: showDialogBox,
            ),
            backgroundColor:btnColor,
            onPressed: (){}
        ),
      body: _isLoading?const LoadingIndicatorWidget(): Form(
        key: _formKey,
        child: ListView(
          children: [
            InputFields.readableInputField(_appointmentTypeController, "Type de service", 1),
            InputFields.readableInputField(_patientNameController, "Nom du patient", 1),
            InputFields.commonInputField(_drNameController, "Nom de l'infermier", (item) {
              return item.length > 0 ? null : "Nom de l'infermier";
            }, TextInputType.text, 1),
            InputFields.readableInputField(_dateController, "Date", 1),
            InputFields.readableInputField(_timeController, "Temps", 1),
            InputFields.readableInputField(_priceController, "Prix", 1),
            const Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 0, left: 20, right: 240),
                    child : Text (
                      "Status de resultats",
                      style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      ))),
            _isPaiedDropDown(),    
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  const Text("État des Resultats:     "),
                  if ( _prescriptionStatus  ==  "Terminé")
                    _statusIndicator(Colors.green)
                  else if ( _prescriptionStatus  ==  "Traiter")
                    _statusIndicator(Colors.yellowAccent)
                  else if (
                    _prescriptionStatus  ==  "Suspendu")
                      _statusIndicator(Colors.red)
                    else
                      Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                        _prescriptionStatus,
                        style: const TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 15,
                        )),
                  ),
                ],
              ),
            ),
                // widget.prescriptionDetails.prescriptionStatus == "Terminé"
                //     ? const Padding(
                //   padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                //   child: Text(
                //       "Pardon! Vous ne pouvez pas modifier ce resultats"),
                // )
                // : Container(),
                // const Padding(
                //   padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                //   child: Divider(),
                // ),
            _resultsController.text.isEmpty
            ? Container()
            : const Padding(
              padding: EdgeInsets.fromLTRB(20,8,20,8),
              child: Text("Les resultats jointe précédente",style: TextStyle(
                fontFamily: "OpenSans-SemiBold",
                fontSize: 14
              ),),
            ),
            InputFields.commonInputField(_resultsController, "results", true, TextInputType.text, 6),
          ],
        ),
      ),
    );
  }

  _handleDeletePrescription()async{
    setState(() {
      _isLoading=true;
      _isEnableBtn=false;
    });
    final res=await PrescriptionService.deleteData(widget.prescriptionDetails.id);
    if(res=="success"){
      ToastMsg.showToastMsg("Supprimé avec succès");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    }
    else{
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");

    }
    setState(() {
      _isLoading=false;
      _isEnableBtn=true;
    });
  }

  _isPaiedDropDown() {
    String val;
    if (_isPaiedStatus == "0") {
      val == "Non Validé";
      isPaiedString = "Non Validé";
    }
    if (_isPaiedStatus == "1") {
      val == "Validé";
      isPaiedString = "Validé";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: val,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Non Validé',
          'Validé',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(isPaiedString),
        onChanged: (String value) {
          setState(() {
            if (value=="Non Validé") {
              _isPaiedStatus = "0";
              isPaiedString = "Non Validé";
            }
            if (value=="Validé") {
              _isPaiedStatus = "1";
              isPaiedString = "Validé";
            }
          });
        },
      ),
    );
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
                      title: "Suspendu",
                      value: 0,
                      onChanged: (newValue)=> setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Traiter",
                      value: 1,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Terminé",
                      value: 2,
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
                        _handlePrescriptionStatus(
                            widget.prescriptionDetails.id, "Suspendu");
                      }

                      break;
                      case 1:{ Navigator.of(context).pop();
                      _handlePrescriptionStatus(widget.prescriptionDetails.id, "Traiter");
                      }

                      break;
                      case 2:{ Navigator.of(context).pop();
                      _handlePrescriptionStatus(
                          widget.prescriptionDetails.id, "Terminé");}
                      
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
                  child: const Text("Annuler",style: TextStyle(
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

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
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

  _handlePrescriptionStatus(String prescriptionId, String status) async {

    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });
    DateTime now = DateTime.now();
    String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
    // log ("status  : "+status);
    final prescriptionModel=PrescriptionModel(
        id: prescriptionId,
        prescriptionStatus: status,
        updatedTimeStamp: createdTimeStamp
    );
    final res = await PrescriptionService.updateStatus(prescriptionModel);
    // log(prescriptionId + status);
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

  _sendNotification(String title) async {
    String body = "";
    switch (title) {
      case "Terminé":
        {
          body = "Merci pour votre visite. Votre resultats est pret!";
          break;
        }
      case "Traiter":
        {
          body =
          "Votre rendez-vous a été Traiter depuis date: ${widget.prescriptionDetails.updatedTimeStamp}";
          break;
        }
      case "Suspendu":
        {
          body =
          "Votre rendez-vous est en attente depuis date: ${widget.prescriptionDetails.updatedTimeStamp}";
          break;
        }
      default:
        {
          body = "";
        }
    }

      final res = await AdminService.getUserFcm(widget.prescriptionDetails.patientId); //get fcm id of specific user
      FirebaseNotification.sendPushMessage(res[0].fcmId, title, body);

      await PatientService.updateIsAnyNotification("1", widget.prescriptionDetails.patientId);
  }
}
