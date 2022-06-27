import 'package:flutter/material.dart';
import 'package:syslab_admin/model/availability_model.dart';
import 'package:syslab_admin/service/availablity_service.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';

class EditAvailabilityPage extends StatefulWidget {
  @override
  _EditAvailabilityPageState createState() => _EditAvailabilityPageState();
}

class _EditAvailabilityPageState extends State<EditAvailabilityPage> {
  final TextEditingController _monController = TextEditingController();
  final TextEditingController _tueController = TextEditingController();
  final TextEditingController _wedController = TextEditingController();
  final TextEditingController _thuController = TextEditingController();
  final TextEditingController _friController = TextEditingController();
  final TextEditingController _satController = TextEditingController();
  final TextEditingController _sunController = TextEditingController();
  String id = "";

  bool _isLoading = false;
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    fetchAvailability();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _monController.dispose();
    _tueController.dispose();
    _thuController.dispose();
    _wedController.dispose();
    _friController.dispose();
    _satController.dispose();
    _sunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Edit Availability"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Update",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: Text(
                        "We are available on",
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 16,
                        ),
                      )),
                  InputFields.commonInputField(_monController, "Monday",
                      (item) {
                    return item.length > 0 ? null : "Enter text ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_tueController, "Tuesday",
                      (item) {
                    return item.length > 0 ? null : "Enter text ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_wedController, "Wednesday",
                      (item) {
                    return item.length > 0 ? null : "Enter text ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_thuController, "Thursday",
                      (item) {
                    return item.length > 0 ? null : "Enter text ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_friController, "Friday",
                      (item) {
                    return item.length > 0 ? null : "Enter text ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_satController, "Saturday",
                      (item) {
                    return item.length > 0 ? null : "Enter text ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_sunController, "Sunday",
                      (item) {
                    return item.length > 0 ? null : "Enter text ";
                  }, TextInputType.text, 1),
                ],
              ),
            ),
    );
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update", _handleUpdate);
  }

  _handleUpdate() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
      final availabilityModel = AvailabilityModel(
          id: id,
          mon: _monController.text,
          tue: _tueController.text,
          wed: _wedController.text,
          thu: _thuController.text,
          fri: _friController.text,
          sat: _satController.text,
          sun: _sunController.text);
      final res = await AvailabilityService.updateData(availabilityModel);
      if (res == "success") {
        ToastMsg.showToastMsg("Successfully Updated");
      } else if (res == "error") {
        ToastMsg.showToastMsg("Something wents wrong");
      }
      setState(() {
        _isEnableBtn = true;
        _isLoading = false;
      });

      // _images.length > 0 ? _uploadImg() : _uploadNameAndDesc("");
    }
  }

  void fetchAvailability() async {
    setState(() {
      _isLoading = true;
    });
    final res = await AvailabilityService.getAvailability();
    setState(() {
      _monController.text = res[0].mon;
      _tueController.text = res[0].tue;
      _wedController.text = res[0].wed;
      _thuController.text = res[0].thu;
      _friController.text = res[0].fri;
      _satController.text = res[0].sat;
      _sunController.text = res[0].sun;
      id = res[0].id;
    });
    setState(() {
      _isLoading = false;
    });
  }
}
