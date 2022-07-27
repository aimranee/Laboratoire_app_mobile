import 'package:flutter/material.dart';
import 'package:syslab_admin/model/availability_model.dart';
import 'package:syslab_admin/service/availablity_service.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';

class EditAvailabilityPage extends StatefulWidget {
  const EditAvailabilityPage({Key key}) : super(key: key);

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
          ? const LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: Text(
                        "Nous sommes disponibles sur",
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 16,
                        ),
                      )),
                  InputFields.commonInputField(_monController, "Lundi",
                      (item) {
                    return item.length > 0 ? null : "Entrez du texte ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_tueController, "Mardi",
                      (item) {
                    return item.length > 0 ? null : "Entrez du texte ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_wedController, "Mercredi",
                      (item) {
                    return item.length > 0 ? null : "Entrez du texte ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_thuController, "Jeudi",
                      (item) {
                    return item.length > 0 ? null : "Entrez du texte ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_friController, "Vendredi",
                      (item) {
                    return item.length > 0 ? null : "Entrez du texte ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_satController, "Samedi",
                      (item) {
                    return item.length > 0 ? null : "Entrez du texte ";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_sunController, "Dimanche",
                      (item) {
                    return item.length > 0 ? null : "Entrez du texte ";
                  }, TextInputType.text, 1),
                ],
              ),
            ),
    );
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
        ToastMsg.showToastMsg("Mise à jour réussie");
      } else if (res == "error") {
        ToastMsg.showToastMsg("Quelque chose s'est mal passé");
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
