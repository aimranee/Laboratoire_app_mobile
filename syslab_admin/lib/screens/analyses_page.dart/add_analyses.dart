

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syslab_admin/model/analyses_model.dart';
import 'package:syslab_admin/service/analyses_service.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';

class AddAnalysePage extends StatefulWidget {
  final catId;
  final catName;
  const AddAnalysePage({this.catName, this.catId, Key key}) : super(key: key);

  @override
  _AddAnalysePageState createState() => _AddAnalysePageState();
}

class _AddAnalysePageState extends State<AddAnalysePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameAnalyseController = TextEditingController();
  final TextEditingController _libBilanAnalyseController = TextEditingController();
  final TextEditingController _libAutomatAnalyseController = TextEditingController();
  final TextEditingController _valeurReferenceAnalyseController = TextEditingController();
  final TextEditingController _catNameController = TextEditingController();
  final TextEditingController _catIdController = TextEditingController();
  final TextEditingController _uniteAnalyseController = TextEditingController();
  final TextEditingController _priceAnalyseController = TextEditingController();
  final TextEditingController _descriptionAnalyseController = TextEditingController();
  final TextEditingController _minAnalyseController = TextEditingController();
  final TextEditingController _maxAnalyseController = TextEditingController();
  final TextEditingController _titreAnalyseController = TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _value;
  List categorieList;



  @override
  void initState() {
    _catNameController.text = widget.catName;
    _catIdController.text = widget.catId;
    // log (widget.catName.toString()+"  :  " + widget.catId.toString());
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _nameAnalyseController.dispose(); 
    _libBilanAnalyseController.dispose(); 
    _libAutomatAnalyseController.dispose(); 
    _valeurReferenceAnalyseController.dispose(); 
    _catNameController.dispose();
    _catIdController.dispose();
    _uniteAnalyseController.dispose(); 
    _priceAnalyseController.dispose(); 
    _descriptionAnalyseController.dispose(); 
    _minAnalyseController.dispose(); 
    _maxAnalyseController.dispose(); 
    _titreAnalyseController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add Service"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Ajouter",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicatorWidget())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                                        const SizedBox(height: 10),
                    _analyseInputField(_nameAnalyseController,"Nom d'analyse"), 
                    _analyseInputField(_titreAnalyseController,"Titre d'analyse"), 
                    _analyseInputField(_libBilanAnalyseController,"Bilan"), 
                    _analyseInputField(_libAutomatAnalyseController,"Automat"),
                    _analyseInputField(_valeurReferenceAnalyseController,"Reference"), 
                    InputFields.readableInputField(_catNameController,"Branche biologique",1), 
                    _analyseInputField(_uniteAnalyseController,"Unite"), 
                    _analyseInputField(_priceAnalyseController,"Prix"),
                    _analyseInputField(_minAnalyseController,"Min"), 
                    _analyseInputField(_maxAnalyseController,"Max"), 
                    _descInputField(),
                  ],
                ),
              ),
            ),
    );
  }

  _uploadData() async {
    setState(() {
        _isLoading = true;
        _isEnableBtn = false;
      });
    DateTime now = DateTime.now();
    String createdTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final analysesModel = AnalysesModel(
      name: _nameAnalyseController.text,
      libBilan: _libBilanAnalyseController.text,
      libAutomat: _libAutomatAnalyseController.text,
      valeurReference: _valeurReferenceAnalyseController.text,
      unite: _uniteAnalyseController.text,
      price: _priceAnalyseController.text,
      description: _descriptionAnalyseController.text,
      min: _minAnalyseController.text,
      max: _maxAnalyseController.text,
      categoryId: _catIdController.text,
      categoryName: _catNameController.text,
      titre: _titreAnalyseController.text,
      createdTimeStamp:createdTime,
      updatedTimeStamp:createdTime
    );
    final res = await AnalysesService.addData(
        analysesModel); //upload data with all required details
    if (res == "success") {
      ToastMsg.showToastMsg("Ajouter avec succès");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/CategoriesPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _analyseInputField(_controller, title) {
    return InputFields.commonInputField(_controller, title,
        (item) {
      return item.length > 0 ? null : "Enter service name";
    }, TextInputType.text, 1);
  }

  Widget _descInputField() {
    return InputFields.commonInputField(_descriptionAnalyseController, "Description",
        (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, 8);
  }
  _takeConfirmation() {
    if (_formKey.currentState.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Ajouter analyse",
          "Voulez-vous vraiment ajouter un nouveau analyse?",
          _uploadData); //take a confirmation from the user
    }
  }

}
