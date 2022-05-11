import 'dart:convert';
import 'package:laboratoire_app/config.dart';
import 'package:laboratoire_app/model/appointmentTypeModel.dart';
import 'package:http/http.dart' as http;

class AppointmentTypeService {
  static const _viewUrl = "$apiUrl/get_appointmentType";

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
