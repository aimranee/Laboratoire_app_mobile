import 'package:intl/intl.dart';
import 'package:syslab_admin/model/prescription_model.dart';
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

class AddPrescriptionPage extends StatefulWidget {
  final String title;
  final String appointmentType;
  final String patientName;
  final String date;
  final String time;
  final String appointmentId;
  final String patientId;
  final String price;
  const AddPrescriptionPage({Key key, this.title,
  this.patientName,
  this.appointmentType,
  this.date,
  this.time,
  this.appointmentId,
  this.patientId,
  this.price}) : super(key: key);
  @override
  _AddPrescriptionPageState createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  final TextEditingController _appointmentTypeController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _drNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  bool _isUploading = false;
  bool _isEnableBtn = true;
  String _prescriptionStatus = "Suspendu";
  String _isPaiedStatus = "0";
  
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _appointmentTypeController.text=widget.appointmentType;
      _patientNameController.text=widget.patientName;
      _dateController.text=widget.date;
      _timeController.text=widget.time;
      _priceController.text=widget.price;
    });
    super.initState();
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
    _resultController.dispose();
    super.dispose();
  }
  _takeUpdateConfirmation(){
    DialogBoxes.confirmationBox(
        context, "Ajouter", "Voulez-vous vraiment ajouter un nouveau resultats ?", _handleUpdate);
  }
  _handleUpdate()async {
    if (_formKey.currentState.validate()) {

      setState(() {
        _isUploading = true;
        // _isEnableBtn = false;
      });
        if (_resultController.text.isNotEmpty) {
          _prescriptionStatus= "Terminé";
        }
        DateTime now = DateTime.now();
        String createdTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
        PrescriptionModel prescriptionModel = PrescriptionModel(
            appointmentId:widget.appointmentId,
            patientId:widget.patientId,
            appointmentTime:widget.time,
            appointmentDate:widget.date,
            appointmentName:widget.appointmentType,
            drName: _drNameController.text,
            isPaied: _isPaiedStatus,
            patientName: _patientNameController.text,
            results: _resultController.text,
            prescriptionStatus: _prescriptionStatus,
            price: widget.price,
            createdTimeStamp: createdTime,
            updatedTimeStamp: createdTime
        );
        
        final res = await PrescriptionService.addData(prescriptionModel);
        if (res == "success") {
          ToastMsg.showToastMsg("Ajouté avec succès");
             await _sendNotification();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/AppointmentListPage', ModalRoute.withName('/HomePage'));
        }
        else {
          ToastMsg.showToastMsg("Quelque chose s'est mal passé");
        }

      setState(() {
        _isUploading = false;
        _isEnableBtn = true;
      });
    }
  }
  _statusDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _prescriptionStatus,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Suspendu',
          'Traiter',
          'Terminé',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        // hint: const Text(
        //   "Select Gender",
        // ),
        onChanged: (String value) {
          setState(() {
            // log(value);
            _prescriptionStatus = value;
          });
        },
      ),
    );
  }

  _isPaiedDropDown() {
    String val;
    if (_isPaiedStatus == "0") {
      val == "Non Validé";
    }
    if (_isPaiedStatus == "1") {
      val == "Validé";
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
        hint: const Text(
          "Select le status de paiement",
        ),
        onChanged: (String value) {
          setState(() {
            if (value=="Non Validé") {
              _isPaiedStatus = "0";
            }
            if (value=="Validé") {
              _isPaiedStatus = "1";
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName,style: kAppBarTitleStyle,),
        backgroundColor: appBarColor,
      ),
      bottomNavigationBar: BottomNavBarWidget(
          title: "Ajouter",
          onPressed: _takeUpdateConfirmation,
          isEnableBtn:_isEnableBtn
      ),

      body: _isUploading
      ? const LoadingIndicatorWidget()
      : Form(
        key: _formKey,
        child: ListView(
          children: [
            InputFields.readableInputField(_appointmentTypeController, "Service", 1),
            InputFields.commonInputField(_patientNameController, "Patient Name", (item) {
              return item.length > 0 ? null : "Enter patient name";
            }, TextInputType.text, 1),
            InputFields.commonInputField(_drNameController, "Nom de l'infirmier", (item) {
              return item.length > 0 ? null : "Entrez le nom de l'infirmier";
            }, TextInputType.text, 1),
            InputFields.readableInputField(_dateController, "Date", 1),
            // const Padding(
            //         padding: EdgeInsets.only(top: 30.0, bottom: 0, left: 20, right: 240),
            //         child : Text (
            //           "Status de resultats",
            //           style: TextStyle(
            //           color: Colors.black54,
            //           fontSize: 13,
            //           ))),
            // _statusDropDown(),
            InputFields.readableInputField(_timeController, "Temps", 1),
            InputFields.readableInputField(_priceController, "Prix", 1),
            _isPaiedDropDown(),
            _descInputField(_resultController, "Results", 7),
          ],
        ),
      ),
    );
  }

  Widget _descInputField(controller, labelText, maxLine) {
    return InputFields.commonInputField(controller, labelText, true, TextInputType.multiline, maxLine);
  }

  _sendNotification()async {
    String title="Résultats ajoutés";
    String body="Une nouvelle résultat a été ajoutée avec le status $_prescriptionStatus s'il vous plaît vérifie le";
      final res = await PatientService.getData(widget.patientId); //get fcm id of specific user

      FirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await PatientService.updateIsAnyNotification("1", widget.patientId);
  }

}
