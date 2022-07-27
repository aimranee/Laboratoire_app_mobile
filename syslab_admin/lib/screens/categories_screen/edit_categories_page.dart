import 'package:intl/intl.dart';
import 'package:syslab_admin/model/category_model.dart';
import 'package:syslab_admin/service/category_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/font_style.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';

class EditcategoriesPage extends StatefulWidget {
  final categoryDetails;
  const EditcategoriesPage({Key key, this.categoryDetails}) : super(key: key);

  @override
  _EditcategoriesPageState createState() => _EditcategoriesPageState();
}

class _EditcategoriesPageState extends State<EditcategoriesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDesController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void initState() {
    //initialize all textController values
    _categoryNameController.text = widget.categoryDetails.name;
    _categoryDesController.text = widget.categoryDetails.description;
    _categoryIdController.text = widget.categoryDetails.id;
    super.initState();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryDesController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier ${_categoryNameController.text}" ,style: kAppBarTitleStyle,),
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: (){
            DialogBoxes.confirmationBox(
                context, "Supprimer", "Voulez-vous vraiment supprimer le categorie ${_categoryNameController.text} ?", (){
              _handleDeletecategory();
            });
          }, icon:const Icon(Icons.delete))
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Mise à jour",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? const LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    _categoryNameInputField(),
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
          "Mise à jour",
          "êtes-vous sûr de vouloir mettre à jour",
          _updateDetails); //take confirmation form user
    }
  }

  _handleDeletecategory() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await CategoryService.deleteData(widget.categoryDetails.id);
    if (res == "success") {
      ToastMsg.showToastMsg("Supprimé avec succès");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/CategoriesPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  _updateDetails() async {
    DateTime now = DateTime.now();
    String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final categoryModel = CategoryModel(
        id: _categoryIdController.text,
        name: _categoryNameController.text,
        description: _categoryDesController.text,
        updatedTimeStamp: createdTimeStamp);
    final res = await CategoryService.updateData(categoryModel);
    if (res == "success") {
      ToastMsg.showToastMsg("Mise à jour réussie");
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

  Widget _categoryNameInputField() {
    return InputFields.commonInputField(_categoryNameController, "Nom de branche biologique",
        (item) {
      return item.length > 0 ? null : "Entrez le nom de branche biologique";
    }, TextInputType.text, 1);
  }

  Widget _descInputField() {
    return InputFields.commonInputField(_categoryDesController, "Description",
        (item) {
      return item.length > 0 ? null : "Entrez la description";
    }, TextInputType.multiline, 8);
  }
}
