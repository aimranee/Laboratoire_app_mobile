import 'dart:convert';
import 'dart:developer';
import 'package:patient/config.dart';
import 'package:patient/model/prescription_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionService {
  static const _viewUrl = "$apiUrl/get_prescription";
  static const _viewUrlById = "$apiUrl/get_prescription_byid"; 
  static const _updateIsPaiedUrl = "$apiUrl/update_prescription_isPaied";

  static List<PrescriptionModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<PrescriptionModel>.from(data.map((item) => PrescriptionModel.fromJson(item)));
  }

  static Future<List<PrescriptionModel>> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString("uId");
    
    final response = await http.get(Uri.parse("$_viewUrl/$userId"));
    // log("message : "+response.body.toString());
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<PrescriptionModel>> getDataByApId({String appointmentId}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString("uId");
    
    final response = await http.post(Uri.parse(_viewUrlById),body: {"uId":userId,"appointmentId":appointmentId});
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateIsPaied(PrescriptionModel prescriptionModel) async {
    final res = await http.put(Uri.parse(_updateIsPaiedUrl),
        body: prescriptionModel.toJsonUpdateStatus());
        log ("res : "+res.body.toString());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }
}
