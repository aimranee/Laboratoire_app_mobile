import 'package:get/get.dart';
import 'package:patient/Service/appointment_service.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/widgets/auth_screen.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/error_widget.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:patient/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:patient/Screen/appointment/appointment_details_page.dart';

class AppointmentStatus extends StatefulWidget {
  const AppointmentStatus({Key key}) : super(key: key);

  @override
  _AppointmentStatusState createState() => _AppointmentStatusState();
}

class _AppointmentStatusState extends State<AppointmentStatus> {
    final bool _isLoading = false;
    bool isConn = Get.arguments;

  @override
  void initState() {
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer : _isLoading ? Container() : CustomDrawer(isConn: isConn),
          bottomNavigationBar: _isLoading
        ? Container() 
        : BottomNavigationWidget(title: "Prendre un rendez-vous", route: '/AppoinmentPage', isConn: isConn),
          appBar: AppBar(
            title: const Text("Rendez-vous", style: kAppbarTitleStyle),
            centerTitle: true,
            backgroundColor: appBarColor,
            actions: [_appBarActionWidget(isConn)],
            bottom: const TabBar(
              indicatorWeight: 3,
              indicatorColor: Colors.white,
              labelPadding: EdgeInsets.all(8),
              tabs: [
                Text(
                  "Prochainement",
                  style: kAppbarTitleStyle,
                ),
                Text(
                  "Passé",
                  style: kAppbarTitleStyle,
                ),
              ],
            ),
          ),
          body: Container(
            child: !isConn ? const AuthScreen() : TabBarView(
              children: [_upcomingAppointmentList(), _pastAppointmentList()],
            ),
          )),
    );
  }

  Widget _upcomingAppointmentList() {
    // <1> Use FutureBuilder
    return FutureBuilder(
        // <2> Pass `Future<QuerySnapshot>` to future
        future: AppointmentService.getData("Pending,Confirmed"), ////fetch appointment details according to uid
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0
                ? const NoBookingWidget()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return _card(snapshot.data, index);
                        }));
          } else if (snapshot.hasError) {
            return const IErrorWidget();
          } else {
            return const LoadingIndicatorWidget();
          }
        });
  }

  Widget _pastAppointmentList() {
    // <1> Use FutureBuilder
    return FutureBuilder(
        // <2> Pass `Future<QuerySnapshot>` to future
        future: AppointmentService.getData("Visited,Rejected,Canceled"), //fetch appointment details according to uid
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0
                ? const NoDataWidget()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return _card(snapshot.data, index);
                        }));
          } else if (snapshot.hasError) {
            return const IErrorWidget();
          } else {
            return const LoadingIndicatorWidget();
          }
        });
  }

  Widget _card(appointmentDetails, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AppointmentDetailsPage(isConn:true, appointmentDetails: appointmentDetails[index]));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _appointmentDate(
                appointmentDetails[index].appointmentDate,
              ),
              // VerticalDivider(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          const Text("Nom de patient: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 12,
                              )),
                          Text(
                              appointmentDetails[index].uName,
                              style: const TextStyle(
                                fontFamily: 'OpenSans-SemiBold',
                                fontSize: 15,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Temp: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 12,
                              )),
                          Text(appointmentDetails[index].appointmentTime,
                              style: const TextStyle(
                                fontFamily: 'OpenSans-SemiBold',
                                fontSize: 15,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  height: 1, color: Colors.grey[300])),
                          Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: appointmentDetails[index]
                                          .appointmentStatus ==
                                      "Pending"
                                  ? _statusIndicator(Colors.yellowAccent)
                                  : appointmentDetails[index]
                                                  .appointmentStatus ==
                                              "Rejected"
                                          ? _statusIndicator(Colors.red)
                                          : appointmentDetails[index]
                                                      .appointmentStatus ==
                                                  "Confirmed"
                                              ? _statusIndicator(Colors.green)
                                              : null),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                            child: Text(
                              appointmentDetails[index].appointmentStatus,
                              style: const TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Text("Type de rendez-vous",
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 12,
                          )),
                      Text(appointmentDetails[index].appointmentType,
                          style: const TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appointmentDate(date) {
    var appointmentDate = date.split("-");
    String appointmentMonth;
    switch (appointmentDate[0]) {
      case "1":
        appointmentMonth = "JAN";
        break;
      case "2":
        appointmentMonth = "FEV";
        break;
      case "3":
        appointmentMonth = "MARS";
        break;
      case "4":
        appointmentMonth = "AVRIL";
        break;
      case "5":
        appointmentMonth = "MAY";
        break;
      case "6":
        appointmentMonth = "JUN";
        break;
      case "7":
        appointmentMonth = "JUILLET";
        break;
      case "8":
        appointmentMonth = "AOUT";
        break;
      case "9":
        appointmentMonth = "SEP";
        break;
      case "10":
        appointmentMonth = "OCT";
        break;
      case "11":
        appointmentMonth = "NOV";
        break;
      case "12":
        appointmentMonth = "DEC";
        break;
    }

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(appointmentMonth,
            style: const TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              fontSize: 15,
            )),
        Text(appointmentDate[1],
            style: const TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              color: btnColor,
              fontSize: 35,
            )),
        Text(appointmentDate[2],
            style: const TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              fontSize: 15,
            )),
      ],
    );
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }

  Widget _appBarActionWidget(isConn) {
   
      return _isLoading ? Container() : isConn ? IconButton(
        onPressed: ()=>{}, 
        icon: const Icon(Icons.notifications, color: appBarIconColor))
        : TextButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/AuthScreen",
          );
        },
        child: const Text("Seconnecter", style: TextStyle(color: Colors.white,),),
        
      );
    //   StreamBuilder(
    //     stream: ReadData.fetchNotificationDotStatus(
    //         FirebaseAuth.instance.currentUser.uid),
    //     builder: (context, snapshot) {
    //       return !snapshot.hasData
    //           ? Container()
    //           : IconButton(
    //               icon: Stack(
    //                 children: [
    //                   Icon(Icons.notifications, color: appBarIconColor),
    //                   snapshot.data["isAnyNotification"]
    //                       ? const Positioned(
    //                           top: 0,
    //                           right: 0,
    //                           child: CircleAvatar(
    //                             backgroundColor: Colors.red,
    //                             radius: 5,
    //                           ),
    //                         )
    //                       : Positioned(top: 0, right: 0, child: Container())
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
    //     }
    // );
    
  }
}
