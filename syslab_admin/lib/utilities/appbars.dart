

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';

class IAppBars {
  
  static Widget commonAppBar(context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: appBarIconColor, //change your color here
      ),
      title: Text(
        title,
        style: kAppBarTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: appBarColor,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FutureBuilder(
                future: AdminService.fetchNotificationStatusAdmin(),
                builder: (context, snapshot) {
                  // log("test : "+snapshot.data.toString());
                  if (snapshot.hasData) {
                        return IconButton(
                          icon: Stack(
                            children: [
                              const Icon(
                                Icons.notifications,
                                color: appBarIconColor,
                              ),
                              snapshot.data[0].isAnyNotification != "0"?
                                  const Positioned(
                                    top: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 5,
                                    ),
                                  ) :
                                  Positioned(
                                      top: 0, right: 0, child: Container())
                            ],
                          ),
                          onPressed: () {
                            Get.toNamed(
                              "/NotificationListPage",
                            );
                          }
                          //

                          );
                  
                } else {
                  return const Icon(
                          Icons.notifications,
                          color: appBarIconColor,
                        );
                }
            }
            ))
      ],
    );
  }
}
