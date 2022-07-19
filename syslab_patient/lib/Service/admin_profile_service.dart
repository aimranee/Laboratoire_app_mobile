import 'dart:convert';
import 'package:patient/config.dart';
import 'package:http/http.dart' as http;
import 'package:patient/model/admin_profiel_model.dart';

class AdminProfileService {
  static const _viewUrl = "$apiUrl/get_admin_profile";
  static const _viewUrlId = "$apiUrl/get_admin_profile_by_id";
  static const _updateUrl = "$apiUrl/update_admin_profile";
  static const _update = "$apiUrl/update_admin_fcm";
  static const _updateNotifUrl = "$apiUrl/update_notif_status_admin";

  static List<AdminProfileModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AdminProfileModel>.from(data.map((item) => AdminProfileModel.fromJson(item)));
  }

  static Future<List<AdminProfileModel>> getData() async {
    
    final response = await http.get(Uri.parse("$_viewUrl"));
    if (response.statusCode == 200) {
      List<AdminProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AdminProfileModel>> getDataById(userId) async {
    final response = await http.get(Uri.parse("$_viewUrlId?id=$userId"));
    if (response.statusCode == 200) {
      List<AdminProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(AdminProfileModel adminProfileModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: adminProfileModel.toUpdateJson());
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

  static updateIsAnyNotification(isNotif) async {

    final res = 
        await http.put(Uri.parse(_updateNotifUrl), body : {
          "isAnyNotification":isNotif,
        });

    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }

  }
}
