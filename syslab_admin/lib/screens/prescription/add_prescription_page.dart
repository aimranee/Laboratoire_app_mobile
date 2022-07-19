
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syslab_admin/model/prescription_model.dart';
import 'package:syslab_admin/screens/prescription/show_prescription_page.dart';
import 'package:syslab_admin/service/notification/firebase_notification.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/service/prescription_service.dart';
import 'package:syslab_admin/service/uploadImageService.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';
import 'package:syslab_admin/utilities/imagePicker.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/imageWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController=ScrollController();
  final List<String> _imageUrls=[];
  List<Asset> _listImages = <Asset>[];
  //String _imageName = "";
  int _successUploaded = 1;
  bool _isUploading = false;
  bool _isEnableBtn = true;
  final String _prescriptionStatus = "Suspendu";
  
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _appointmentTypeController.text=widget.appointmentType;
      _patientNameController.text=widget.patientName;
      _drNameController.text="Dr Name";
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
    _messageController.dispose();
    super.dispose();
  }
  _takeUpdateConfirmation(){
    DialogBoxes.confirmationBox(
        context, "Mise à jour", "Voulez-vous vraiment mettre à jour les détails ?", _handleUpdate);
  }
  _handleUpdate()async {
    if (_formKey.currentState.validate()) {

      setState(() {
        _isUploading = true;
        // _isEnableBtn = false;
      });
      if (_listImages.isEmpty) {
        String imageUrl = "";
        // if (_imageUrls.isNotEmpty) {
        //   for (var e in _imageUrls) {
        //     if (imageUrl == "") {
        //       imageUrl = e;
        //     } else {
        //       imageUrl = imageUrl + "," + e;
        //     }
        //   }
        // }
        DateTime now = DateTime.now();
        String createdTime = DateFormat('yyyy-MM-dd').format(now);
        PrescriptionModel prescriptionModel = PrescriptionModel(
            appointmentId:widget.appointmentId,
            patientId:widget.patientId,
            appointmentTime:widget.time,
            appointmentDate:widget.date,
            appointmentName:widget.appointmentType,
            drName: _drNameController.text,
            patientName: _patientNameController.text,
            fileUrl: imageUrl,
            prescription: _messageController.text,
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
      {ToastMsg.showToastMsg("Image ${_listImages[index].name} size must be less the 2MB");
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
      { ToastMsg.showToastMsg("Image ${_listImages[index].name} size must be less the 2MB");
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
          DateTime now = DateTime.now();
          String _createdTime = DateFormat('yyyy-MM-dd').format(now);
          PrescriptionModel prescriptionModel=PrescriptionModel(
              appointmentId:widget.appointmentId,
              patientId:widget.patientId,
              appointmentTime:widget.time,
              appointmentDate:widget.date,
              appointmentName:widget.appointmentType,
              drName: _drNameController.text,
              patientName: _patientNameController.text,
              fileUrl: imageUrl,
              prescription: _messageController.text,
              createdTimeStamp : _createdTime,
              updatedTimeStamp : _createdTime
          );
          
          final res =await PrescriptionService.addData(prescriptionModel);
          if(res=="success"){
            ToastMsg.showToastMsg("Successfully Added");
            await  _sendNotification();
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
        // actions: [
        //   IconButton(onPressed: (){}, icon:Icon(Icons.delete))
        // ],
      ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: _loadAssets
            ),
            backgroundColor:btnColor,
            onPressed: (){}
        ),
      bottomNavigationBar: BottomNavBarWidget(
          title: "Ajouter",
          onPressed:_takeUpdateConfirmation,
          isEnableBtn:_isEnableBtn
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
            _imageUrls.isEmpty?Container(): const Padding(
              padding: EdgeInsets.fromLTRB(20,8,20,8),
              child: Text("Previous attached image",style: TextStyle(
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
    final res = await ImagePicker.loadAssets(
        _listImages, mounted, 10); //get images from phone gallery with 10 limit
    setState(() {
      _listImages = res;
      // if (res.length > 0)
        // _isEnableBtn = true;
      // else
      //   _isEnableBtn = false;
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
                    Get.to(() => ShowPrescriptionImagePage(
                          imageUrls: _imageUrls,
                          selectedImagesIndex: index,
                          title: "Prescription Image"),
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

    

  _sendNotification()async {
    String title="Résultats ajoutés";
    String body="Une nouvelle résultat a été ajoutée  ${widget.appointmentId} s'il vous plaît vérifie le";
      final res = await PatientService.getData(widget.patientId); //get fcm id of specific user

      FirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await PatientService.updateIsAnyNotification("1", widget.patientId);
    
  }

}
