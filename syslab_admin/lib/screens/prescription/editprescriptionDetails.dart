
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:syslab_admin/model/prescription_model.dart';
import 'package:syslab_admin/screens/prescription/show_prescription_page.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/service/notification/firebase_notification.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/service/prescription_service.dart';
import 'package:syslab_admin/service/uploadImageService.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/imageWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController=ScrollController();
  List<String> _imageUrls=[];

  final List<Asset> _listImages = <Asset>[];
  //String _imageName = "";
  int _groupValue = -1;
  int _successUploaded = 1;
  bool _isUploading = false;
  bool _isEnableBtn = true;
  bool _isLoading = false;
final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _appointmentTypeController.text=widget.prescriptionDetails.appointmentName;
      _patientNameController.text=widget.prescriptionDetails.patientName;
      _drNameController.text=widget.prescriptionDetails.drName;
      _dateController.text=widget.prescriptionDetails.appointmentDate;
      _timeController.text=widget.prescriptionDetails.appointmentTime;
      _priceController.text=widget.prescriptionDetails.price;
      _messageController.text=widget.prescriptionDetails.prescription;
      if(widget.prescriptionDetails.fileUrl!="") {
        _imageUrls=widget.prescriptionDetails.fileUrl.toString().split(",");
      }

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
    _messageController.dispose();
    super.dispose();
  }
  _takeUpdateConfirmation(){
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update details", _handleUpdate);
  }
  _handleUpdate()async {
    if (_formKey.currentState.validate()) {

    setState(() {
      _isUploading = true;
      _isEnableBtn = false;
    });
    if (_listImages.isEmpty) {
      String imageUrl = "";
      if (_imageUrls.isNotEmpty) {
        for (var e in _imageUrls) {
          if (imageUrl == "") {
            imageUrl = e;
          } else {
            imageUrl = imageUrl + "," + e;
          }
        }
      }
      DateTime now = DateTime.now();
      String _createdTime = DateFormat('yyyy-MM-dd').format(now);
      PrescriptionModel prescriptionModel = PrescriptionModel(
          id: widget.prescriptionDetails.id,
          drName: _drNameController.text,
          patientName: _patientNameController.text,
          fileUrl: imageUrl,
          prescription: _messageController.text,
          updatedTimeStamp : _createdTime
      );
      final res = await PrescriptionService.updateData(prescriptionModel);
      if (res == "success") {
        ToastMsg.showToastMsg("Mise à jour réussie");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      }
      else {
        ToastMsg.showToastMsg("Something went wrong");
      }
    }
    else {
      await _startUploading();
    }


    setState(() {
      _isUploading = false;
      _isEnableBtn = true;
    });
  }
  }
  _startUploading() async {
    int index = _successUploaded - 1;
    setState(() {
      //_imageName=_listImages[index].name;
    });


    if (_successUploaded <= _listImages.length) {
      final res=await UploadImageService.uploadImages(_listImages[index]); //  represent the progress of uploading task
      if(res=="0"){
        ToastMsg.showToastMsg("Sorry, ${_listImages[index].name} is not in format only JPG, JPEG, PNG, & GIF files are allowed to upload");
        if (_successUploaded < _listImages.length) {
          //check more images for upload
          setState(() {
            _successUploaded = _successUploaded + 1;
          });
          _startUploading(); //if images is remain to upload then again run this task

        } else {

        }
      }

      else if(res=="1")
      {ToastMsg.showToastMsg("Image ${_listImages[index].name} size must be less the 1MB");
      if (_successUploaded < _listImages.length) {
        //check more images for upload
        setState(() {
          _successUploaded = _successUploaded + 1;
        });
        _startUploading(); //if images is remain to upload then again run this task

      } else {

      }
      }

      else if(res=="2")
      { ToastMsg.showToastMsg("Image ${_listImages[index].name} size must be less the 1MB");
      if (_successUploaded < _listImages.length) {
        //check more images for upload
        setState(() {
          _successUploaded = _successUploaded + 1;
        });
        _startUploading(); //if images is remain to upload then again run this task

      } else {
      }
      }

      else if(res=="3"|| res=="error")
      { ToastMsg.showToastMsg("Something went wrong");
      if (_successUploaded < _listImages.length) {
        //check more images for upload
        setState(() {
          _successUploaded = _successUploaded + 1;
        });
        _startUploading(); //if images is remain to upload then again run this task

      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/EditGalleryPage', ModalRoute.withName('/HomePage'));
      }
      }

      else if(res==""||res==null)
      {ToastMsg.showToastMsg("Something went wrong");
      if (_successUploaded < _listImages.length) {
        //check more images for upload
        setState(() {
          _successUploaded = _successUploaded + 1;
        });
        _startUploading(); //if images is remain to upload then again run this task

      } else {
      }
      }
      else{
        setState(() {
          _imageUrls.add(res);
        });

          if (_successUploaded < _listImages.length) {
            //check more images for upload
            setState(() {
              _successUploaded = _successUploaded + 1;
            });
            _startUploading(); //if images is remain to upload then again run this task

          } else {
            // print("***********${_imageUrls.length}");
            String imageUrl="";
            if(_imageUrls.isNotEmpty){
              for(var e in _imageUrls){
                if(imageUrl==""){
                  imageUrl =e;
                }else{
                  imageUrl =imageUrl+","+e;
                }
              }}

              PrescriptionModel prescriptionModel=PrescriptionModel(
                  id: widget.prescriptionDetails.id,
                  drName: _drNameController.text,
                  patientName: _patientNameController.text,
                  fileUrl: imageUrl,
                  prescription: _messageController.text
              );
              final res =await PrescriptionService.updateData(prescriptionModel);
              if(res=="success"){
                ToastMsg.showToastMsg("Mise à jour réussie");
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/AppointmentListPage', ModalRoute.withName('/HomePage'));
              }
              else {
                ToastMsg.showToastMsg("Something went wrong");
              }
          }
                }


    }
    setState(() {
      _isUploading = false;
      _isEnableBtn = true;
    });
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
      bottomNavigationBar: BottomNavTwoBarWidget(
        firstTitle: "Update",
        firstBtnOnPressed:_takeUpdateConfirmation,
        isenableBtn:_isEnableBtn,
        secondTitle: "Upload",
        secondBtnOnPressed:_loadAssets,
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
      body: _isUploading?LoadingIndicatorWidget(): Form(
        key: _formKey,
        child: ListView(
          children: [
            InputFields.readableInputField(_appointmentTypeController, "Service", 1),
            InputFields.commonInputField(_patientNameController, "Patient Name", (item) {
              return item.length > 0 ? null : "Enter patient name";
            }, TextInputType.text, 1),
            InputFields.commonInputField(_drNameController, "Dr Name", (item) {
              return item.length > 0 ? null : "Enter Dr name";
            }, TextInputType.text, 1),
            InputFields.readableInputField(_dateController, "Date", 1),
            InputFields.readableInputField(_timeController, "Temps", 1),
            InputFields.readableInputField(_priceController, "Prix", 1),
            InputFields.commonInputField(_messageController, "Message", (item) {
              return item.length > 0 ? null : "Enter message ";
            }, TextInputType.text, null),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  const Text("État des Resultats:     "),
                  if ( widget.prescriptionDetails.prescriptionStatus  ==
                      "Terminé")
                    _statusIndicator(Colors.green)
                  else if ( widget.prescriptionDetails.prescriptionStatus  ==
                      "Dans la réalisation")
                    _statusIndicator(Colors.yellowAccent)
                  else if (
                    widget.prescriptionDetails.prescriptionStatus  ==
                        "Suspendu")
                      _statusIndicator(Colors.red)
                    else
                      Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                        "${ widget.prescriptionDetails.prescriptionStatus }",
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
            _imageUrls.isEmpty?Container(): const Padding(
              padding: EdgeInsets.fromLTRB(20,8,20,8),
              child: Text("Les resultats jointe précédente",style: TextStyle(
                fontFamily: "OpenSans-SemiBold",
                fontSize: 14
              ),),
            ),
            _buildImageList(),

            _listImages.isEmpty? Container():const Padding(
              padding: EdgeInsets.fromLTRB(20,8,20,8),
              child: Text("New attached image",style: TextStyle(
                  fontFamily: "OpenSans-SemiBold",
                  fontSize: 14
              ),),
            ),
          _buildNewImageList(),
          ],
        ),
      ),
    );
  }
  Future<void> _loadAssets() async {
    // final res = await ImagePicker.loadAssets(
    //     _listImages, mounted, 10); //get images from phone gallery with 10 limit
    setState(() {
      // _listImages = res;
      // if (res.length > 0)
      //   _isEnableBtn = true;
      // else
      //   _isEnableBtn = false;
    });
  }

  _handleDeletePrescription()async{
    setState(() {
      _isUploading=true;
      _isEnableBtn=false;
    });
    final res=await PrescriptionService.deleteData(widget.prescriptionDetails.id);
    if(res=="success"){
      ToastMsg.showToastMsg("Supprimé avec succès");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    }
    else{
      ToastMsg.showToastMsg("Something went wrong");

    }
    setState(() {
      _isUploading=false;
      _isEnableBtn=true;
    });
  }
  _buildNewImageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: _listImages.length,
          itemBuilder: (context, index) {
            Asset asset = _listImages[index];
            return Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: GestureDetector(
                onLongPress: (){
                  DialogBoxes.confirmationBox(
                      context, "Delete", "Are you sure want to delete selected image", (){
                        setState(() {
                          _listImages.removeAt(index);
                        });
                  });

                },
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
              ),
            );
          }),
    );
  }

    _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
          controller: _scrollController,
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                onTap: (){
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowPrescriptionImagePage(
                            imageUrls: _imageUrls,
                            selectedImagesIndex: index,
                            title: "Prescription Image"),
                      ),
                     );
                },
                onLongPress: (){
                    DialogBoxes.confirmationBox(
                        context, "Delete", "Are you sure want to delete selected image", (){
                          setState(() {
                            _imageUrls.removeAt(index);
                          });
                    });
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child:ImageBoxContainWidget(imageUrl:_imageUrls[index] ,),
                ),
              ),
            );
      }),
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
                      title: "Dans la réalisation",
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
                      _handlePrescriptionStatus(widget.prescriptionDetails.id, "Dans la réalisation");
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
          body = "Merci pour votre visite. Votre document est pret!";
          break;
        }
      case "Dans la réalisation":
        {
          body =
          "Votre rendez-vous a été Dans la réalisation depuis date: ${widget.prescriptionDetails.updatedTimeStamp}";
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
