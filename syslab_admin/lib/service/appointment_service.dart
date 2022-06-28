import 'dart:convert';
import 'dart:developer';
import 'package:syslab_admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/appointment_model.dart';

class AppointmentService {
  static const _viewUrl = "$apiUrl/get_all_appointment";
  static const _getByUserUrl = "$apiUrl/get_appointment_by_Uid";
  static const _searchByNameUrl = "$apiUrl/search_by_name";
  static const _searchByIdUrl = "$apiUrl/search_by_id";
  static const _updateStatusUrl = "$apiUrl/update_appointment_status";
  static const _updateReschUrl = "$apiUrl/update_appointment_resch";
  static const _updateDataUrl = "$apiUrl/update_appointment";
  static const _addUrl = "$apiUrl/add_appointment";

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
        "$_viewUrl?status=$res&type=$typeRes&firstDate=$firstDate&lastDate=$lastDate&limit=$limit"));

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

  static Future<List<AppointmentModel>> getAppointmentByName(
      String searchByName) async {
    final response = await http
        .get(Uri.parse("$_searchByNameUrl?db=appointments&name=$searchByName"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getAppointmentById(String id) async {
    print(id);

    final response = await http
        .get(Uri.parse("$_searchByIdUrl?db=appointments&idName=id&id=$id"));
    print(response.body);

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(AppointmentModel appointmentModel) async {
    print("${appointmentModel.toJsonUpdate()}");

    final res = await http.post(Uri.parse(_updateDataUrl),
        body: appointmentModel.toJsonUpdate());
    print(res.body);
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

  static updateDataResch(AppointmentModel appointmentModel) async {
    final res = await http.post(Uri.parse(_updateReschUrl),
        body: appointmentModel.toJsonUpdateResch());
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
}
