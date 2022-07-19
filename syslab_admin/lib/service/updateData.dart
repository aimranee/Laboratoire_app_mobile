import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateData{
  static Future <String>updateSettings(sendData) async {

    final res =await FirebaseFirestore.instance.collection('settings')
        .doc("settings").update(sendData).then((value) {return "success";}).catchError((onError){return"error";});
    return res;
  }

}