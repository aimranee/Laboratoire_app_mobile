import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/config.dart';
import 'package:syslab_admin/model/category_model.dart';


class CategoryService {
  static const _viewUrl = "$apiUrl/get_categories";
  static const _viewByIdUrl = "$apiUrl/get_categories_by_id";
  static const _updateUrl = "$apiUrl/update_categories";
  static const _deleteUrl = "$apiUrl/delete_categories";
  static const _addUrl = "$apiUrl/add_categories";

  static List<CategoryModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<CategoryModel>.from(
        data.map((item) => CategoryModel.fromJson(item)));
  }

  static Future<List<CategoryModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    // log(response.body.toString());
    if (response.statusCode == 200) {
      List<CategoryModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<CategoryModel>> getDataById(id) async {
    final response = await http.get(Uri.parse("$_viewByIdUrl/$id"));
    // log(response.body.toString());
    if (response.statusCode == 200) {
      List<CategoryModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(CategoryModel categoryModel) async {
    // log("${categoryModel.toUpdateJson()}");
    final res = await http.put(Uri.parse(_updateUrl),
        body: categoryModel.toUpdateJson());
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

  static addData(CategoryModel categoryModel) async {
    
    final res =
        await http.post(Uri.parse(_addUrl), body: categoryModel.toAddJson());
    if (res.statusCode == 200) {
      
      return res.body;
    } else {
      
      return "error";
    }
  }

}
