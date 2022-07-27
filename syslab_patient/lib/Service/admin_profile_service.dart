import 'dart:convert';
import 'package:patient/config.dart';
import 'package:http/http.dart' as http;
import 'package:patient/model/admin_profiel_model.dart';

class AdminProfileService {
  static const _viewUrl = "$apiUrl/get_fcmId_admin";
  static const _updateNotifUrl = "$apiUrl/update_notif_status_admin";

  static List<AdminProfileModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AdminProfileModel>.from(data.map((item) => AdminProfileModel.fromJson(item)));
  }

  static Future<List<AdminProfileModel>> getData() async {
    
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<AdminProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
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
