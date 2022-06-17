import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:laboratoire_app/config.dart';
import 'package:laboratoire_app/model/analyses_category_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AppDataController extends GetxController {

  static const _viewUrl = "$apiUrl/get_cat_analyse";
  List<AnalysesCatModel> subjectData = [];
  List<MultiSelectItem> dropDownData = [];

  static List<AnalysesCatModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AnalysesCatModel>.from(
        data.map((item) => AnalysesCatModel.fromJson(item)));
  }

  getSubjectData() async {

    final apiResponse = await http.get(Uri.parse(_viewUrl));
    
    if (apiResponse.statusCode == 200) {
      List<AnalysesCatModel> list = dataFromJson(apiResponse.body);
      
      List<AnalysesCatModel> tempSubjectData = [];
      
      for (var data in list) {
        tempSubjectData.add(
          AnalysesCatModel(
            analysesId: data.analysesId,
            analysesName: data.analysesName,
            analysesPrice: data.analysesPrice,
          ),
        );
      }

      subjectData.addAll(tempSubjectData);
      
      dropDownData = subjectData.map((subjectdata) {
        return MultiSelectItem(subjectdata, subjectdata.analysesName);
        
      }).toList();

      update();

    } else if (apiResponse.statusCode == 400) {
      log("Show Error model why error occurred..");
    } else {
      log("show some error model like something went worng..");
    }
  }
}
