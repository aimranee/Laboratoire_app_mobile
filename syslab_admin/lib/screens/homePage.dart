import 'dart:developer';

// import 'package:syslab_admin/service/Notification/handleLocalNotification.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:syslab_admin/service/Notification/handleFirebaseNotification.dart';
import 'package:syslab_admin/service/readData.dart';
import 'package:syslab_admin/utilities/clipPath.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _gridScrollController = ScrollController();

  final List _widgetsList = [
    {
      "iconName": "assets/icons/appoin.svg",
      "title": "Rendez-vous",
      "navigation": "/AppointmentListPage"
    },
    {
      "iconName": "assets/icons/teeth.svg",
      "title": "Analyses",
      "navigation": "/ServicesPage"
    },
    {
      "iconName": "assets/icons/group.svg",
      "title": "Users",
      "navigation": "/UsersListPage"
    },
    {
      "iconName": "assets/icons/bell.svg",
      "title": "Notification",
      "navigation": "/NotificationListPage"
    },
    {
      "iconName": "assets/icons/timing.svg",
      "title": "Timing",
      "navigation": "/EditOpeningClosingTime"
    },
    {
      "iconName": "assets/icons/sch.svg",
      "title": "Availability",
      "navigation": "/EditAvailabilityPage"
    },
    {
      "iconName": "assets/icons/type.svg",
      "title": "Types",
      "navigation": "/AppointmentTypesPage"
    },
    {
      "iconName": "assets/icons/booking.svg",
      "title": "Setting",
      "navigation": "/EditBookingTiming"
    },
    {
      "iconName": "assets/icons/doct.svg",
      "title": "Profile",
      "navigation": "/EditProfilePage"
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    // HandleFirebaseNotification.handleNotifications(
    //     context); //initialize firebase messaging
    // HandleLocalNotification.initializeFlutterNotification(
    //     context); //initialize local notification
    getMsg();
    super.initState();
  }

  getMsg() async {
    final res = await FirebaseMessaging.instance.getToken();
    // log(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: _bottomCircularBox()),
          Positioned.fill(
            child: _adminImageAndText(),
          ),
          Positioned(top: 20, right: 5, child: SignOutBtnWidget()),
          Positioned(
              top: 300,
              left: 10,
              right: 10,
              bottom: 10,
              child: _buildGridView())
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      //  physics: ScrollPhysics(),
      controller: _gridScrollController,
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(_widgetsList.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, _widgetsList[index]["navigation"]);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // _widgetsList[index]["title"] == "Notification"
                //      _buildNotificationIcon(_widgetsList[index]["iconName"]) :
                    SizedBox(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(_widgetsList[index]["iconName"],
                            semanticsLabel: 'Acme Logo'),
                      ),
                const SizedBox(height: 20),
                Text(
                  _widgetsList[index]["title"],
                  style: const TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _bottomCircularBox() {
    return Container(
      alignment: Alignment.center,
      child: ClipPath(
        clipper: ClipPathClass(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(gradient: gradientColor),
        ),
      ),
    );
  }

  Widget _adminImageAndText() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Image.asset(
          "assets/images/image1.png",
          height: 180,
          fit: BoxFit.fill,
        ),
        // const SizedBox(height: 15),
        // const Text(
        //   "Admin App",
        //   style: TextStyle(
        //       fontFamily: 'OpenSans-Bold', fontSize: 25.0, color: Colors.white),
        // )
      ],
    );
  }

  // Widget _buildNotificationIcon(widgetName) {
  //   return StreamBuilder(
  //       stream: ReadData.fetchNotificationDotStatus(),
  //       builder: (context, snapshot) {
  //         return !snapshot.hasData
  //              SizedBox(
  //                 height: 40,
  //                 width: 40,
  //                 child:
  //                     SvgPicture.asset(widgetName, semanticsLabel: 'Acme Logo'),
  //               )
  //             : Stack(
  //                 children: [
  //                   SizedBox(
  //                     height: 40,
  //                     width: 40,
  //                     child: SvgPicture.asset(widgetName,
  //                         semanticsLabel: 'Acme Logo'),
  //                   ),
  //                   snapshot.data["isAnyNotification"]
  //                        Positioned(
  //                           top: 0,
  //                           right: 0,
  //                           child: CircleAvatar(
  //                             radius: 5,
  //                             backgroundColor: Colors.red,
  //                           ))
  //                       : Positioned(top: 0, right: 0, child: Container())
  //                 ],
  //               );
  //       });
  // }
}
