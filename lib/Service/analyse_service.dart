import 'dart:convert';
import 'dart:developer';
import 'package:laboratoire_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:laboratoire_app/model/analyses_model.dart';

class ServiceService {
  static const _viewUrl = "$apiUrl/get_analyses";

  static List<ServiceModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<ServiceModel>.from(
        data.map((item) => ServiceModel.fromJson(item)));
  }

  static Future<List<ServiceModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<ServiceModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
