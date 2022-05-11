import 'package:laboratoire_app/Screen/prescription/showPrescriptionImae.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/inputfields.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/imageWidget.dart';
import 'package:flutter/material.dart';

class PrescriptionDetailsPage extends StatefulWidget {
  final title;
  final prescriptionDetails;
  const PrescriptionDetailsPage({ this.title, this.prescriptionDetails});
  @override
  _PrescriptionDetailsPageState createState() => _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState extends State<PrescriptionDetailsPage> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _drNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController=ScrollController();
  List _imageUrls=[];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _serviceNameController.text=widget.prescriptionDetails.appointmentName;
      _patientNameController.text=widget.prescriptionDetails.patientName;
      _drNameController.text=widget.prescriptionDetails.drName;
      _dateController.text=widget.prescriptionDetails.appointmentDate;
      _timeController.text=widget.prescriptionDetails.appointmentTime;
      _messageController.text=widget.prescriptionDetails.prescription;
      if(widget.prescriptionDetails.imageUrl!="") {
        _imageUrls=widget.prescriptionDetails.imageUrl.toString().split(",");
      }

    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _serviceNameController.dispose();
    _patientNameController.dispose();
    _drNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title:widget.title),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration:IBoxDecoration.upperBoxDecoration(),
              child: ListView(
                  children: [
                    InputFields.readableInputField(_serviceNameController, "Service", 1),
                    InputFields.readableInputField(_patientNameController, "Name", 1),
                    InputFields.readableInputField(_drNameController, "Dr Name", 1),
                    InputFields.readableInputField(_dateController, "Date", 1),
                    InputFields.readableInputField(_timeController, "Time", 1),
                   InputFields.readableInputField(_messageController, "Message",null),
                    _buildImageList()
                  ],
              ),
            )
          ),
        ],
      ),
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
                            title: "Download Prescription"),
                      ),
                     );
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
}
