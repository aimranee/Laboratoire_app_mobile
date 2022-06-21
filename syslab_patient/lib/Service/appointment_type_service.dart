import 'dart:convert';
import 'package:patient/config.dart';
import 'package:patient/model/appointment_type_model.dart';
import 'package:http/http.dart' as http;

class AppointmentTypeService {
  static const _viewUrl = "$apiUrl/get_appointment_type";

  static List<AppointmentTypeModel> availabilityFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AppointmentTypeModel>.from(
        data.map((item) => AppointmentTypeModel.fromJson(item)));
  }

  static Future<List<AppointmentTypeModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<AppointmentTypeModel> list = availabilityFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
