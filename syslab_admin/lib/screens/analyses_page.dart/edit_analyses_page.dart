import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:syslab_admin/model/analyses_model.dart';
import 'package:syslab_admin/service/analyses_service.dart';
import 'package:syslab_admin/service/category_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/font_style.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';

class EditAnalysesPage extends StatefulWidget {
  final analysesDetails;
  const EditAnalysesPage({Key key, this.analysesDetails}) : super(key: key);

  @override
  _EditAnalysesPageState createState() => _EditAnalysesPageState();
}

class _EditAnalysesPageState extends State<EditAnalysesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameAnalyseController = TextEditingController();
  final TextEditingController _libBilanAnalyseController = TextEditingController();
  final TextEditingController _libAutomatAnalyseController = TextEditingController();
  final TextEditingController _valeurReferenceAnalyseController = TextEditingController();
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
  String categoryName = "select branche biologique";
  String categoryId = "";

  @override
  void initState() {
    // TODO: implement initState
    getCategories();
    //initialize all textController values
    _nameAnalyseController.text = widget.analysesDetails.name;
    _libBilanAnalyseController.text = widget.analysesDetails.libBilan;
    _libAutomatAnalyseController.text = widget.analysesDetails.libAutomat;
    _valeurReferenceAnalyseController.text = widget.analysesDetails.valeurReference;
    _uniteAnalyseController.text = widget.analysesDetails.unite;
    _priceAnalyseController.text = widget.analysesDetails.price;
    _descriptionAnalyseController.text = widget.analysesDetails.description; 
    _minAnalyseController.text = widget.analysesDetails.min;
    _maxAnalyseController.text = widget.analysesDetails.max;
    _titreAnalyseController.text = widget.analysesDetails.titre;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameAnalyseController.dispose(); 
    _libBilanAnalyseController.dispose(); 
    _libAutomatAnalyseController.dispose(); 
    _valeurReferenceAnalyseController.dispose(); 
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
      appBar: AppBar(
        title: Text("Modifier ${_nameAnalyseController.text}" ,style: kAppBarTitleStyle,),
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: (){
            DialogBoxes.confirmationBox(
                context, "Supprimer", "Voulez-vous vraiment supprimer le categorie ${_nameAnalyseController.text} ?", (){
              _handleDeleteAnalyses();
            });
          }, icon:const Icon(Icons.delete))
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Update",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
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
                    const SizedBox(height: 10),
                    _analyseInputField(_nameAnalyseController,"Nom d'analyse"), 
                    _analyseInputField(_titreAnalyseController,"Titre d'analyse"), 
                    _analyseInputField(_libBilanAnalyseController,"Bilan"), 
                    _analyseInputField(_libAutomatAnalyseController,"Automat"),

                   const Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 0, left: 0, right: 240),
                    child : Text (
                      "Branche biologique",
                      style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      ))),

                    _selectField(categorieList),
                    _analyseInputField(_valeurReferenceAnalyseController,"Reference"), 
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

  _takeConfirmation() {
    if (_formKey.currentState.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Update",
          "Are you sure want to update",
          _updateDetails); //take confirmation form user
    }
  }

  _handleDeleteAnalyses() async {
    setState(() {
        _isLoading = true;
        _isEnableBtn = false;
      });
    final res = await AnalysesService.deleteData(widget.analysesDetails.id);
    if (res == "success") {
      ToastMsg.showToastMsg("Supprimé avec succès");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/AnalysesPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  _updateDetails() async {
    setState(() {
        _isLoading = true;
        _isEnableBtn = false;
      });
    DateTime now = DateTime.now();
    String createdTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final analysesModel = AnalysesModel(
      id: widget.analysesDetails.id,
      name: _nameAnalyseController.text,
      libBilan: _libBilanAnalyseController.text,
      libAutomat: _libAutomatAnalyseController.text,
      valeurReference: _valeurReferenceAnalyseController.text,
      unite: _uniteAnalyseController.text,
      price: _priceAnalyseController.text,
      description: _descriptionAnalyseController.text,
      min: _minAnalyseController.text,
      max: _maxAnalyseController.text,
      categoryId: categoryId,
      categoryName: categoryName,
      titre: _titreAnalyseController.text,
      updatedTimeStamp:createdTime
    );
    final res = await AnalysesService.updateData(analysesModel);
    
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
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

  Widget _selectField(listCategories){
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: _value,
                  iconSize: 30,
                  icon: (null),
                  style: const TextStyle(color: Colors.black),
                  // style: const TextStyle(color: Colors.white),
                  iconEnabledColor: btnColor,
                  hint: Text(categoryName),
                  onChanged: (newValue) {
                    String catId = newValue.split(',')[0];
                    String catName = newValue.split(',')[1];
                    setState(() {
                      _value = newValue;
                      categoryName = catName;
                      categoryId = catId;
                      log(newValue);
                    });
                  },
                  items: categorieList?.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.name),
                          value: "${item.id.toString()},${item.name}",
                        );
                      })?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  getCategories() async {
    final res = await CategoryService.getData();
    setState(() {
        categorieList = res;
        categoryName = widget.analysesDetails.categoryName;
        categoryId = widget.analysesDetails.categoryId;
      });
  }
}
