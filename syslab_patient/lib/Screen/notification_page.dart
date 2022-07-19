import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:patient/Service/user_service.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/decoration.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:patient/widgets/no_data_widget.dart';
// import 'package:patient/Service/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<RemoteMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  @override
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      setState((){
        _messages = [..._messages, message];
      });
    });
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationWidget(
          route: "/AppoinmentPage", title: "Demander Rendez-vous"),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: const Text(
              "Notification",
              style: kAppbarTitleStyle,
            ),
            centerTitle: true,
            backgroundColor: appBarColor,
          ),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: IBoxDecoration.upperBoxDecoration(),
              child: 
              _messages.isEmpty
                  ? 
                  const NoDataWidget()
                  : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      RemoteMessage message =_messages[index];
                    return GestureDetector(
                      onTap: () {
                        // if (notificationDetails[index].routeTo != "/NotificationPage" &&
                        //     notificationDetails[index].routeTo != "") {
                        //   Navigator.pushNamed(
                        //       context, notificationDetails[index].routeTo);
                        // }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              title: Text(
                                message.notification?.title??'N/D',
                                style: const TextStyle(
                                  fontFamily: 'OpenSans-Bold',
                                  fontSize: 14.0,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${message.notification.body}",
                                    style: const TextStyle(
                                      fontFamily: 'OpenSans-SemiBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${message.sentTime?.toString() ?? DateTime.now().toString()}",
                                    style: const TextStyle(
                                      fontFamily: 'OpenSans-Regular',
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    );
                  })
            ),
          ),
        ],
      ),
    );
  }

  void updateData() async {
    await UserService.updateIsAnyNotification("0");
  }
}
