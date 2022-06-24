import 'dart:convert';
import 'package:patient/config.dart';
import 'package:http/http.dart' as http;
import 'package:patient/model/dr_profiel_model.dart';

class DrProfileService {
  static const _viewUrl = "$apiUrl/get_drprofile";
  static const _viewUrlId = "$apiUrl/get_drprofile_by_id";
  static const _updateUrl = "$apiUrl/update_drprofile";
  static const _update = "$apiUrl/update_admin_fcm";

  static List<DrProfileModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<DrProfileModel>.from(data.map((item) => DrProfileModel.fromJson(item)));
  }

  static Future<List<DrProfileModel>> getData() async {
    
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<DrProfileModel>> getDataById(userId) async {
    final response = await http.get(Uri.parse("$_viewUrlId?id=$userId"));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(DrProfileModel drProfileModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: drProfileModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static updateFcmId(String fcmId, String fcm) async {
    final res = await http.post(Uri.parse(_update), body: {"fcmId": fcmId});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }
}
