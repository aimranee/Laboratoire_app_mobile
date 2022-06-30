import 'dart:convert';
import 'dart:developer';
import 'package:syslab_admin/config.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/model/appointment_type_model.dart';

class AppointmentTypeService {
  static const _viewUrl = "$apiUrl/get_appointment_type";
  static const _addUrl = "$apiUrl/add_appointmentType";
  static const _deleteUrl = "$apiUrl/delete";
  static const _updateUrl = "$apiUrl/update_appointmentType";
  static const _getByTitleUrl = "$apiUrl/get_otct_by_type_name";

  static List<AppointmentTypeModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AppointmentTypeModel>.from(
        data.map((item) => AppointmentTypeModel.fromJson(item)));
  }

  static Future<List<AppointmentTypeModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    
    if (response.statusCode == 200) {
      List<AppointmentTypeModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentTypeModel>> getTimingData(String title) async {
    final response = await http.get(Uri.parse("$_getByTitleUrl?title=$title"));
    if (response.statusCode == 200) {
      List<AppointmentTypeModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(AppointmentTypeModel appointmentTypeModel) async {
    final res = await http.post(Uri.parse(_addUrl),
        body: appointmentTypeModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "db": "appointmentType"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(AppointmentTypeModel appointmentTypeModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: appointmentTypeModel.toUpdateJson());

    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
