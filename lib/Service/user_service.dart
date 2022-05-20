import 'dart:convert';
import 'dart:developer';
import 'package:laboratoire_app/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:laboratoire_app/model/user_model.dart';

class UserService {
  static const _viewUrl = "$apiUrl/get_user";
  static const _addUrl = "$apiUrl/add_user";
  static const _update = "$apiUrl/update_user_fcm";
  static const _updateUrl = "$apiUrl/update_user";
  static List<UserModel> dataFromJson(String jsonString) {
    
    final data = json.decode(jsonString);
    // log(data.toString());
    return List<UserModel>.from(data.map((item) => UserModel.fromJson(item)));
  }

  static Future<List<UserModel>> getData() async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    
    final response = await http.get(Uri.parse("$_viewUrl?uid=$userId"));
    
    if (response.statusCode == 200) {
      
      List<UserModel> list = dataFromJson(response.body);
      log("message : "+list[0].uId);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(UserModel appointmentModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: appointmentModel.toJsonAdd());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static updateFcmId(String uId, String fcmId) async {
    final res = await http
        .post(Uri.parse(_update), body: {"fcmId": fcmId, "uid": uId});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static updateData(UserModel userModel) async {
    // log("hhhhhhhhhhhhhhh");
    
    final res = await http.post(Uri.parse(_updateUrl), body: userModel.toUpdateJson());
    log(">>>>>>>>>>>>>>>>>>>>>>${userModel.toUpdateJson()}");
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }
}
