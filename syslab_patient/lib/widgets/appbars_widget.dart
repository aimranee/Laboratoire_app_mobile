// import 'package:patient/Service/Firebase/readData.dart';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:patient/Service/user_service.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/style.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CAppBarWidget extends StatefulWidget {

  final String title;
  bool isConn;
  
  CAppBarWidget({Key key, this.title, this.isConn}) : super(key: key);

  @override
  State<CAppBarWidget> createState() => _CAppBarWidgetState();
}

class _CAppBarWidgetState extends State<CAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: appBarIconColor //change your color here
          ),
      title: Text(
        widget.title,
        style: kAppbarTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: appBarColor,
      actions: 
      <Widget>[ 
        if(widget.isConn)
          FutureBuilder(
            future: UserService.fetchNotificationStatusPatient(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container()
                  : IconButton(
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          snapshot.data[0].isAnyNotification=="1"
                              ? Positioned(
                                  top: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 5,
                                  ),
                                )
                              : Positioned(top: 0, right: 0, child: Container())
                        ],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/NotificationPage",
                        );
                      }
                      //

                      );
            })
        else
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