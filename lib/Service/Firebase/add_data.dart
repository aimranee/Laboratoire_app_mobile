// /*
// import 'package:cloud_firestore/cloud_firestore.dart';
// class AddData {

//   static Future<String> addRegisterDetails(uid) async {
//     var sendData = {"uId": uid, "isAnyNotification": false};
//     String res = "";
//     await FirebaseFirestore.instance
//         .collection('usersList')
//         .doc(uid)
//         .set(sendData)
//         .then((value) {
//       res = "success";
//     }).catchError((onError) {
//       //print(onError);
//       res = "error";
//     });
//     return res;
//   }

// }
// */


// import 'package:cloud_firestore/cloud_firestore.dart';
// class AddData {

//   static Future<String> addRegisterDetails(uid,_cityController , _ageController, _selectedGender,  _emailController,  fcmId, _firstNameController,image , _lastNameController , pNo) async {
//     var sendData = {"uId": uid,"city":_cityController,"age":_ageController,"gender":_selectedGender,"email":_emailController,"fcmId":fcmId,"firstName":_firstNameController,"imageUrl":image,"lastName":_lastNameController,"pNo": pNo,"isAnyNotification": false};
//     String res = "";
//     await FirebaseFirestore.instance
//         .collection('usersList')
//         .doc(uid)
//         .set(sendData)
//         .then((value) {
//       res = "success";
//     }).catchError((onError) {
//       // //print(onError);
//       res = "error";
//     });
//     return res;
//   }

// }
