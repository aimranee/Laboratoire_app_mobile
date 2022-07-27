import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/admin_model.dart';

class AdminService {
  static const _userUrl = "$apiUrl/get_admin";
  static const _notifUrl = "$apiUrl/get_notif_status_admin";
  static const _updateNotifUrl = "$apiUrl/update_notif_status_admin";
  static const _updateUrl = "$apiUrl/update_admin";
  static const _update = "$apiUrl/update_admin_fcm";
  static const _getFCMidPatient = "$apiUrl/get_user_fcm";

  static List<AdminModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AdminModel>.from(data.map((item) => AdminModel.fromJson(item)));
  }

  static Future<List<AdminModel>> getData() async {
    
    final response = await http.get(Uri.parse(_userUrl));
    // log("test : "+response.body.toString());
    if (response.statusCode == 200) {
      List<AdminModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AdminModel>> getUserFcm(userId) async {
    
    final response = await http.get(Uri.parse("$_getFCMidPatient/$userId"));
    // log("test : "+response.body.toString());
    if (response.statusCode == 200) {
      List<AdminModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AdminModel>> fetchNotificationStatusAdmin() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userId = pref.getString("uId");
      final res = await http.get(Uri.parse("$_notifUrl/$userId"));
      if (res.statusCode == 200) {
        List<AdminModel> list = dataFromJson(res.body);
        // log ("message " +res.body.toString());
        return list;
      } else {
        return [];
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

  static updateData(AdminModel adminModel) async {
    final res =
        await http.put(Uri.parse(_updateUrl), body: adminModel.toUpdateJson());
    // log(">>>>>>>>>>>>>>>>>>>>>>${res.body}");
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static updateFcmId(String uId, String fcmId) async {
    final res = await http
        .put(Uri.parse(_update), body: {"fcmId": fcmId, "uId": uId});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }
}
