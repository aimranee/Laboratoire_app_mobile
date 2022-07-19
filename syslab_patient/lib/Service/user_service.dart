import 'dart:convert';
import 'dart:developer';
import 'package:patient/config.dart';
import 'package:http/http.dart' as http;
import 'package:patient/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const _viewUrl = "$apiUrl/get_user";
  static const _addUrl = "$apiUrl/add_user";
  static const _update = "$apiUrl/update_user_fcm";
  static const _updateUrl = "$apiUrl/update_user";
  static const _registreUrl = "$apiUrl/signup";
  static const _notifUrl = "$apiUrl/get_notif_status_patient";
  static const _updateNotifUrl = "$apiUrl/update_notif_status_patient";
  static List<UserModel> dataFromJson(String jsonString) {
    
    final data = json.decode(jsonString);
    // log(data.toString());
    return List<UserModel>.from(data.map((item) => UserModel.fromJson(item)));
  }
  
  static Future<List<UserModel>> getData(userId) async {
    
    final response = await http.get(Uri.parse("$_viewUrl/$userId"));
    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      // log ("message : "+list[0].firstName);
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

    final res = await http.put(Uri.parse(_update), body: {"fcmId": fcmId, "uId": uId});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }

  }

  static updateData(UserModel userModel) async {

    final res = await http.put(Uri.parse(_updateUrl), body: userModel.toUpdateJson());
    // log(">>>>>>>>>>>>>>>>>>>>>>${userModel.toUpdateJson()}");
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }

  }

    static Future<List<UserModel>> fetchNotificationStatusPatient() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String uId = pref.getString("uId");
      final res = await http.get(Uri.parse("$_notifUrl/$uId"));
      if (res.statusCode == 200) {
        List<UserModel> list = dataFromJson(res.body); 
        // log ("message " +res.body.toString());
        return list;
      } else {
        return [];
      }

  }

  static updateIsAnyNotification(isNotif) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uId = pref.getString("uId");
    log(isNotif +" : "+ uId);
    final res = 
        await http.put(Uri.parse(_updateNotifUrl), body : {
          "isAnyNotification":isNotif,
          "uId":uId
        });
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

}

