import 'package:intl/intl.dart';
import 'package:syslab_admin/model/category_model.dart';
import 'package:syslab_admin/service/category_service.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';

class AddCategoriesPage extends StatefulWidget {
  const AddCategoriesPage({Key key}) : super(key: key);

  @override
  _AddCategoriesPageState createState() => _AddCategoriesPageState();
}

class _AddCategoriesPageState extends State<AddCategoriesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descInputController = TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _descInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Ajouter catégorie"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Ajouter",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? Center(child: LoadingIndicatorWidget())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    _categoryNameInputField(),
                    _descInputField()
                  ],
                ),
              ),
            ),
    );
  }

  Widget _categoryNameInputField() {
    return InputFields.commonInputField(_nameController, "Nom de catégorie", (item) {
      return item.length > 0 ? null : "Saisissez le nom de la catégorie";
    }, TextInputType.text, 1);
  }

  Widget _descInputField() {
    return InputFields.commonInputField(_descInputController, "Description",
        (item) {
      return item.length > 0 ? null : "Entrez la description";
    }, TextInputType.multiline, 8);
  }

  _takeConfirmation() {
    if (_formKey.currentState.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Ajouter une catégorie",
          "Êtes-vous sûr de vouloir ajouter une nouvelle catégorie",
          _uploadData); //take a confirmation from the user
    }
  }

  _uploadData() async {
    DateTime now = DateTime.now();
    String createdTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final categoryModel = CategoryModel(
        name: _nameController.text,
        description: _descInputController.text,
        createdTimeStamp: createdTime,
        updatedTimeStamp: createdTime);
    final res = await CategoryService.addData(categoryModel);//upload data with all required details
    
    if (res == "success") {
      ToastMsg.showToastMsg("Ajouter avec succès");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/CategoriesPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg('Quelque chose s\'est mal passé');
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

}
