import 'dart:convert';
import 'package:laboratoire_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:laboratoire_app/model/drProfielModel.dart';

class DrProfileService {
  static const _viewUrl = "$apiUrl/get_drprofile";
  static const _updateUrl = "$apiUrl/update_drprofile";
  static const _update = "$apiUrl/update_admin_fcm";

  static List<DrProfileModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<DrProfileModel>.from(
        data.map((item) => DrProfileModel.fromJson(item)));
  }

  static Future<List<DrProfileModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(DrProfileModel drProfileModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: drProfileModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateFcmId(String uId, String fcmId) async {
    final res = await http
        .post(Uri.parse("$_update"), body: {"fcmId": fcmId, "uid": uId});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
