
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadData {

  static fetchSettingsStream() {
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'settings').doc("settings").snapshots();
    //doc(settingName).snapshots();

    return firebaseInstance;
  }
  static fetchSettings() {
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'settings').doc("settings").get();

    return firebaseInstance;
  }


}