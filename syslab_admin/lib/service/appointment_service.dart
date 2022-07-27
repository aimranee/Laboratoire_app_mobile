import 'dart:convert';
import 'dart:developer';
import 'package:syslab_admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/appointment_model.dart';

class AppointmentService {
  static const _viewUrl = "$apiUrl/get_all_appointment";
  static const _getByUserUrl = "$apiUrl/get_appointment_by_Uid";
  static const _searchAppointmentByCINUrl = "$apiUrl/search_appointment_by_CIN";
  static const _updateStatusUrl = "$apiUrl/update_appointment_status";
  static const _updateReschUrl = "$apiUrl/update_appointment_resch";
  static const _updateDataUrl = "$apiUrl/update_appointment";
  static const _addUrl = "$apiUrl/add_appointment";
  static const _deleteUrl = "$apiUrl/delete_appointments";

  static List<AppointmentModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AppointmentModel>.from(
        data.map((item) => AppointmentModel.fromJson(item)));
  }

  static addData(AppointmentModel appointmentModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: appointmentModel.toJsonAdd());
    if (res.statusCode == 200) {

      return res.body;
    } else {
      return "error";
    }
  }

  static Future<List<AppointmentModel>> getData(
      List selectedStatus,
      List selectedType,
      String firstDate,
      String lastDate,
      int getLimit) async {
    final limit = getLimit.toString();
    final res = convertArrayToString(selectedStatus);
    final typeRes = convertArrayToString(selectedType);
    final response = await http.get(Uri.parse(
        "$_viewUrl/$res/$typeRes/$firstDate/$lastDate/$limit"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getAppointmentByUser(String userId) async {
    final response = await http.get(Uri.parse("$_getByUserUrl/$userId"));
    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getAppointmentByCIN(
      String searchByCIN) async {
    final response = await http
        .get(Uri.parse("$_searchAppointmentByCINUrl/$searchByCIN"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(AppointmentModel appointmentModel) async {
    log("${appointmentModel.toJsonUpdate()}");

    final res = await http.post(Uri.parse(_updateDataUrl),
        body: appointmentModel.toJsonUpdate());
    log(res.body);
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static updateStatus(AppointmentModel appointmentModel) async {
    final res = await http.put(Uri.parse(_updateStatusUrl),
        body: appointmentModel.toJsonUpdateStatus());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "error";
    }
  }

  static String convertArrayToString(List selectedStatus) {
    String res = "";

    for (int i = 0; i < selectedStatus.length; i++) {
      if (i == selectedStatus.length - 1) {
        res = res + selectedStatus[i];
      } else {
        res = res + selectedStatus[i] + ",";
      }
    }
    return res;
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
}
