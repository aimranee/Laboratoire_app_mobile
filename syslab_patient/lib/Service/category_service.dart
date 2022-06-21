import 'dart:convert';
import 'dart:developer';
import 'package:patient/model/category_model.dart';
import 'package:patient/config.dart';
import 'package:http/http.dart' as http;


class CategoryService {
  static const _viewUrl = "$apiUrl/get_categories";

  static List<CategoryModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<CategoryModel>.from(
        data.map((item) => CategoryModel.fromJson(item)));
  }

  static Future<List<CategoryModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    log(response.body.toString());
    if (response.statusCode == 200) {
      List<CategoryModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
