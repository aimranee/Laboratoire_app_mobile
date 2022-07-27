import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/prescription_model.dart';

class PrescriptionService {
  static const _viewUrl = "$apiUrl/get_prescription";
  static const _viewUrlById = "$apiUrl/get_prescription_byid";
  static const _updateData = "$apiUrl/update_prescription";
  static const _addUrl = "$apiUrl/add_prescription";
  static const _deleteUrl="$apiUrl/delete_prescription";
  static const _updateStatusUrl = "$apiUrl/update_prescription_status";

  static List<PrescriptionModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<PrescriptionModel>.from(
        data.map((item) => PrescriptionModel.fromJson(item)));
  }

  static Future<List<PrescriptionModel>> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString("uId");
    final response = await http.post(Uri.parse(_viewUrl),body: {"uId":userId});
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<PrescriptionModel>> getDataByApId({String appointmentId,String uId}) async {
    // log(appointmentId);
    // log(uId);

    final response = await http.get(Uri.parse("$_viewUrlById/$uId/$appointmentId"));
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future updateData(PrescriptionModel prescriptionModel) async {

    final response = await http.put(Uri.parse(_updateData),
      body:prescriptionModel.toJsonUpdate());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static Future addData(PrescriptionModel prescriptionModel) async {

    final response = await http.post(Uri.parse(_addUrl),body:prescriptionModel.toJsonAdd());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }

  }
  
  static deleteData(String id)async{
    final res=await http.delete(Uri.parse(_deleteUrl),body:{
      "id":id
    });
    if(res.statusCode==200){
      return res.body;
    }
    else {
      return "error";
    }

  }

  static updateStatus(PrescriptionModel prescriptionModel) async {
    final res = await http.put(Uri.parse(_updateStatusUrl),
        body: prescriptionModel.toJsonUpdateStatus());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

}
