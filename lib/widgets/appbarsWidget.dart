// import 'package:laboratoire_app/Service/Firebase/readData.dart';
import 'package:get/get.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/style.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CAppBarWidget extends StatelessWidget {

  final String title;
  bool isConn;
  
  CAppBarWidget({Key key, this.title, this.isConn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: appBarIconColor //change your color here
          ),
      title: Text(
        title,
        style: kAppbarTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: appBarColor,
      actions: 
      <Widget>[ 
        isConn ? IconButton(
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                Positioned(top: 0, right: 0, child: Container())
              ],
            ),
            onPressed: () {

            }
        ):
        TextButton(
        onPressed: () {
          Get.toNamed("/AuthScreen",arguments: false);
        },
        child: const Text("Seconnecter", style: TextStyle(color: Colors.white,),),
        
      ),
            
      ],
    );
  }
}
// StreamBuilder(
//     // stream: ReadData.fetchNotificationDotStatus(uId),
//     builder: (context, snapshot) {
//       return !snapshot.hasData
//           ? Container()
//           : IconButton(
//               icon: Stack(
//                 children: [
//                   const Icon(
//                     Icons.notifications,
//                     color: Colors.white,
//                   ),
//                   snapshot.data["isAnyNotification"]
//                       ? const Positioned(
//                           top: 0,
//                           right: 0,
//                           child: CircleAvatar(
//                             backgroundColor: Colors.red,
//                             radius: 5,
//                           ),
//                         )
//                       : Positioned(
//                           top: 0, right: 0, child: Container())
//                 ],
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(
//                   context,
//                   "/NotificationPage",
//                 );
//               }
//               //

//               );
//     })

