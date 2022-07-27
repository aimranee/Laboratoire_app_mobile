import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/Service/appointment_type_service.dart';
import 'package:syslab_admin/model/appointment_type_model.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditAppointmentTypes extends StatefulWidget {
  final appointmentTypesDetails;
  final disableStartTime;
  final disableEndTime;

  const EditAppointmentTypes(
      {Key key,
      this.appointmentTypesDetails,
      this.disableStartTime,
      this.disableEndTime})
      : super(key: key);
  @override
  _EditAppointmentTypesState createState() => _EditAppointmentTypesState();
}

class _EditAppointmentTypesState extends State<EditAppointmentTypes> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // List<Asset> _images = <Asset>[];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeTakesController = TextEditingController();
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();
  int disableStartTimeHour;
  int disableEndTimeHour;
  int disableStartTimeMin;
  int disableEndTimeMin;

  bool _isEnableBtn = true;
  bool _isLoading = false;
  String uId;
  String _imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    //initialize all text field value
    _titleController.text = widget.appointmentTypesDetails.title;
    _timeTakesController.text =
        widget.appointmentTypesDetails.forTimeMin.toString();
    _imageUrl = widget.appointmentTypesDetails.imageUrl;
    _openingTimeController.text = widget.appointmentTypesDetails.openingTime;
    _closingTimeController.text = widget.appointmentTypesDetails.closingTime;

    setState(() {
      disableStartTimeHour =
          int.parse((widget.disableStartTime).substring(0, 2));
      disableEndTimeHour = int.parse((widget.disableEndTime).substring(0, 2));
      disableStartTimeMin =
          int.parse((widget.disableStartTime).substring(3, 5));
      disableEndTimeMin = int.parse((widget.disableEndTime).substring(3, 5));
    });    
    super.initState();
  }

  
  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _timeTakesController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.appointmentTypesDetails.title),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
        title: "Mise à jour",
      ),
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // if (_imageUrl == "")
                    //   if (_images.length == 0)
                    //     ECircularCameraIconWidget(
                    //       onTap: _handleImagePicker,
                    //     )
                    //   else
                    //     ECircularImageWidget(
                    //       images: _images,
                    //       onPressed: _removeImage,
                    //       imageUrl: _imageUrl,
                    //     )
                    // else
                    //   ECircularImageWidget(
                    //     images: _images,
                    //     onPressed: _removeImage,
                    //     imageUrl: _imageUrl,
                    //   ),
                    InputFields.readableInputField(_titleController, "Type de rendez-vous", 1),
                    // _subTitleInputField(),
                    _timeTakesInputField(),
                    _timingInputField("Horaire d'ouverture", _openingTimeController),
                    _timingInputField("Heure de fermeture", _closingTimeController),
                  ],
                ),
              ),
            ),
    );
  }

  // void _handleImagePicker() async {
  //   final res = await ImagePicker.loadAssets(_images, mounted, 1);
  //   // print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

  //   setState(() {
  //     _images = res;
  //   });
  // }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Mise à jour",
        "Voulez-vous vraiment mettre à jour",
        _handleUpdate); //take confirmation form user
  }

  _handleUpdate() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
      _updateDetails("");
      // if (_imageUrl == "" &&
      //     _images.length ==
      //         0) // if user not select any image and initial we have no any image
      //   _updateDetails(""); //update data without image
      // else if (_imageUrl != "") //if initial we have image
      //   _updateDetails(_imageUrl); //update data with image
      // else if (_imageUrl == "" &&
      //     _images.length >
      //         0) //if user select the image then first upload the image then update data in database
        // _handleUploadImage(); //upload image in to database

      // _images.length > 0 ? _uploadImg() : _uploadNameAndDesc("");
    }
  }

  // void _removeImage() {
  //   setState(() {
  //     _images.clear();
  //     _imageUrl = "";
  //   });
  // }

  _updateDetails(imageDownloadUrl) async {

    final appointmentTypeModel = AppointmentTypeModel(
        forTimeMin: int.parse(_timeTakesController.text),
        title: _titleController.text,
        imageUrl: imageDownloadUrl,
        id: widget.appointmentTypesDetails.id,
        openingTime: _openingTimeController.text,
        closingTime: _closingTimeController.text,
        );
    final res = await AppointmentTypeService.updateData(appointmentTypeModel);

    if (res == "success") {
      ToastMsg.showToastMsg("Mise à jour réussie");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentTypesPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  // void _handleUploadImage() async {
  //   final res = await UploadImageService.uploadImages(_images[0]);
  //   if (res == "0")
  //     ToastMsg.showToastMsg(
  //         "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
  //   else if (res == "1")
  //     ToastMsg.showToastMsg("Image size must be less the 1MB");
  //   else if (res == "2")
  //     ToastMsg.showToastMsg(
  //         "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
  //   else if (res == "3" || res == "error")
  //     ToastMsg.showToastMsg("Quelque chose s'est mal passé");
  //   else if (res == "" || res == null)
  //     ToastMsg.showToastMsg("Quelque chose s'est mal passé");
  //   else
  //     await _updateDetails(res);

  //   setState(() {
  //     _isEnableBtn = true;
  //     _isLoading = false;
  //   });
  // }

  // Widget _subTitleInputField() {
  //   return InputFields.commonInputField(
  //       _subTitleController, "Appointment Subtitle", (item) {
  //     return item.length > 0 ? null : "Enter Appointment Subtitle";
  //   }, TextInputType.text, 1);
  // }

  Widget _timeTakesInputField() {
    return InputFields.commonInputField(
        _timeTakesController, "How Much Time will take (in minute)", (item) {
      if (item.length == 0) {
        return "Entrez l'heure";
      } else if (item.length > 0 && item == "0") {
        return "Entrez une heure valide";
      } else {
        return null;
      }
    }, TextInputType.number, 1);
  }

  Widget _timingInputField(title, controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        onTap: _timePicker,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            labelText: title,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  void _timePicker() async {
    TimeRange result = await showTimeRangePicker(
      disabledTime: TimeRange(
          startTime:
              TimeOfDay(hour: disableEndTimeHour, minute: disableEndTimeMin),
          endTime: TimeOfDay(
              hour: disableStartTimeHour, minute: disableStartTimeMin)),
      start: TimeOfDay(
          hour: int.parse(_openingTimeController.text.substring(0, 2)),
          minute: int.parse(_openingTimeController.text.substring(3, 5))),
      end: TimeOfDay(
          hour: int.parse(_closingTimeController.text.substring(0, 2)),
          minute: int.parse(_closingTimeController.text.substring(3, 5))),
      strokeColor: primaryColor,
      handlerColor: primaryColor,
      selectedColor: primaryColor,
      context: context,
    );

    if (result != null) {
      setState(() {
        if (result.toString().substring(17, 22) ==
            result.toString().substring(37, 42)) {
          ToastMsg.showToastMsg("Veuillez sélectionner des heures différentes");
        } else {
          _openingTimeController.text = result.toString().substring(17, 22);
          _closingTimeController.text = result.toString().substring(37, 42);
        }
      });
    }
  }
  
}
