import 'dart:convert';
import 'package:laboratoire_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:laboratoire_app/model/analyses_model.dart';

class AnalysesService {
  static const _viewUrl = "$apiUrl/get_analyses";
  static const _viewUrlId = "$apiUrl/get_analyses_byId";

  static List<AnalysesModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AnalysesModel>.from(
        data.map((item) => AnalysesModel.fromJson(item)));
  }

  static Future<List<AnalysesModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<AnalysesModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AnalysesModel>> getDataId(id) async {
    final response = await http.get(Uri.parse("$_viewUrlId/$id"));
    if (response.statusCode == 200) {
      List<AnalysesModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AnalysesModel>> getDataIdName(id) async {
    final response = await http.get(Uri.parse(_viewUrlId+"?category_id=$id"));
    if (response.statusCode == 200) {
      List<AnalysesModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
