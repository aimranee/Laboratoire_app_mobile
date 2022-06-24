import 'dart:convert';
import 'package:syslab_admin/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/userModel.dart';

class UserService {
  static const _viewUrl = "$apiUrl/get_all_user";
  static const _updateUrl = "$apiUrl/update_user";
  static const _searchByNameUrl = "$apiUrl/search_by_name";
  static const _searchByIdUrl = "$apiUrl/search_by_id";

  static List<UserModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<UserModel>.from(data.map((item) => UserModel.fromJson(item)));
  }

  static Future<List<UserModel>> getData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final response = await http.get(Uri.parse("$_viewUrl?uid=$userId"));
    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(UserModel userModel) async {
    final res =
        await http.post(Uri.parse(_updateUrl), body: userModel.toUpdateJson());
    print(">>>>>>>>>>>>>>>>>>>>>>${res.body}");
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static Future<List<UserModel>> getUserByName(String searchByName) async {
    final response = await http
        .get(Uri.parse("$_searchByNameUrl?db=userList&name=$searchByName"));

    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<UserModel>> getUserById(String id) async {
    final response = await http
        .get(Uri.parse("$_searchByIdUrl?db=userList&idName=uId&id=$id"));

    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
