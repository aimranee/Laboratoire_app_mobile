import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/widgets/noDataWidget.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({Key key}) : super(key: key);

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<RemoteMessage> _messages = [];
  
  final ScrollController _scrollController = ScrollController();
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
      appBar: IAppBars.commonAppBar(context, "Notification"),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: 
              _messages.isEmpty
                  ? 
                  NoDataWidget()
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
                                    message.notification.body,
                                    style: const TextStyle(
                                      fontFamily: 'OpenSans-SemiBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    message.sentTime?.toString() ?? DateTime.now().toString(),
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
  updateData() async {
    await AdminService.updateIsAnyNotification("0");
  }
}
