import 'dart:convert';
import 'dart:developer';
import 'package:syslab_admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/analyses_model.dart';

class AnalysesService {
  static const _viewUrl = "$apiUrl/get_analyses";
  static const _addUrl = "$apiUrl/add_analyses";
  static const _deleteUrl = "$apiUrl/delete_analyses";
  static const _updateUrl = "$apiUrl/update_analyses";
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

  static addData(AnalysesModel analysesModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: analysesModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static deleteData(String id) async {
    final res = await http
        .delete(Uri.parse(_deleteUrl), body: {"id": id});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static updateData(AnalysesModel analysesModel) async {
    log ("test");
    log("${analysesModel.toUpdateJson()}");
    final res = await http.put(Uri.parse(_updateUrl), 
                  body: analysesModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }
}
