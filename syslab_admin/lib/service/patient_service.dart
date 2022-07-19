import 'dart:convert';
import 'dart:developer';
import 'package:syslab_admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/patient_model.dart';

class PatientService {
  static const _viewUrl = "$apiUrl/get_all_user";
  static const _userUrl = "$apiUrl/get_user_fcm";
  static const _updateNotifUrl = "$apiUrl/update_notif_status_patient";
  static const _updateUrl = "$apiUrl/update_user";
  static const _searchByNameUrl = "$apiUrl/search_by_name";
  static const _searchByIdUrl = "$apiUrl/search_by_id";

  static List<PatientModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<PatientModel>.from(data.map((item) => PatientModel.fromJson(item)));
  }

  static Future<List<PatientModel>> getData(userId) async {
    log ("uid : "+userId);
    final response = await http.get(Uri.parse("$_userUrl/$userId"));
    log("test : "+response.body.toString());
    if (response.statusCode == 200) {
      List<PatientModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

   static Future<List<PatientModel>> getUsers() async {
    
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<PatientModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(PatientModel patientModel) async {
    final res = await http.put(Uri.parse(_updateUrl), body: patientModel.toUpdateJson());
    // log(">>>>>>>>>>>>>>>>>>>>>>${res.body}");
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  // static Future<List<PatientModel>> getUserByName(String searchByName) async {
  //   final response = await http
  //       .get(Uri.parse("$_searchByNameUrl?db=userList&name=$searchByName"));

  //   if (response.statusCode == 200) {
  //     List<PatientModel> list = dataFromJson(response.body);
  //     return list;
  //   } else {
  //     return []; //if any error occurs then it return a blank list
  //   }
  // }

  // static Future<List<PatientModel>> getUserById(String id) async {
  //   final response = await http
  //       .get(Uri.parse("$_searchByIdUrl?db=userList&idName=uId&id=$id"));

  //   if (response.statusCode == 200) {
  //     List<PatientModel> list = dataFromJson(response.body);
  //     return list;
  //   } else {
  //     return []; //if any error occurs then it return a blank list
  //   }
  // }

  static updateIsAnyNotification(isNotif, uId) async {
  // log(isNotif +" : "+ uId);
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
