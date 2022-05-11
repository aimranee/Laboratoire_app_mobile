import 'package:get/get.dart';
import 'package:laboratoire_app/Service/Firebase/readData.dart';
import 'package:laboratoire_app/Service/userService.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/dialogBox.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _uId = "";
  bool _isLoading = false;
  bool isConn = false;
  
  @override
  void initState() {
    
    // TODO: implement initState
    // initialize local and firebase notification
    // HandleLocalNotification.initializeFlutterNotification(
    //     context); //local notification
    // HandleFirebaseNotification.handleNotifications(
    //     context); //firebase notification
    _getAndSetUserData(); //get users details from database
    _checkTechnicalIssueStatus(); //check show technical issue dialog box
    super.initState();
  }

  _getAndSetUserData() async {
    
    //start loading indicator
    
    // final res=await FirebaseMessaging.instance.getToken();
    // print(res);
    
    final user =
        await UserService.getData();
        if (user != null) {
          setState(() {
            isConn = true;
          });
        }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: _isLoading
        ? LoadingIndicatorWidget()
        : BottomNavigationWidget(
          title: "Book an appointment", route: "/AppoinmentPage", isConn: isConn
        ),

      drawer: CustomDrawer(isConn: isConn),

      body: Stack(
            clipBehavior: Clip.none,
        children: [
          CAppBarWidget(title: "Laboratoire", isConn: isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
            child: _buildContent(),
                    /*FutureBuilder(
                        future: BannerImageService
                            .getData(), //fetch banner image urls
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data.length == 0
                                ? NoDataWidget()
                                : _buildContent(snapshot.data[0]);
                          } else if (snapshot.hasError) {
                            return IErrorWidget();
                          } else {
                            return LoadingIndicatorWidget();
                          }
                        }),*/
          ),)
        ]
      )
    );
  }

  Widget _table() {
    return Table(
      children: [

        TableRow(children: [
          _cardImg('assets/icon/doct.svg', 'Profile', "/Profile"),
          _cardImg('assets/icon/teeth.svg', 'Services', "/ServicesPage"),
        ]),

        TableRow(children: [
          _cardImg("assets/icon/appoin.svg", "Appointment", '/Appointmentstatus'),
          _cardImg('assets/icon/sch.svg', 'Availability', '/AvailabilityPage'),
        ]),

        TableRow(children: [
          _cardImg('assets/icon/reachus.svg', 'Reach Us', "/ReachUsPage"),
          _cardImg("assets/icon/call.svg", "Contact Us", "/ContactUsPage"),
        ]),
      ],
    );
  }

  Widget _cardImg(String path, String title, String routeName) {
    return GestureDetector(
      onTap: () {
        //  Check.addData();
        if (routeName != null) Get.toNamed(routeName, arguments : isConn);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .15,
        //width: MediaQuery.of(context).size.width * .1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Container(
              //     height: 50,
              //     width: 50,
              //     color: Colors.grey,
              //     child: //Center(child: Text("Your assets"))),
              //         //delete the just above code [child container ] and uncomment the below code and set your assets
              //      ),

              SizedBox(
                height: 30,
                width: 30,
                child: SvgPicture.asset(path, semanticsLabel: 'Acme Logo'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  title,
                  style: kTitleStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _notificationCardImg(String path, String title, String routeName) {
  //   return GestureDetector(
  //     onTap: () {
  //       //  Check.addData();
  //       if (routeName != null) {
  //         v
  //       }
  //     },
  //     child: Container(
  //       height: MediaQuery.of(context).size.height * .15,
  //       //width: MediaQuery.of(context).size.width * .1,
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         elevation: 5.0,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             // Container(
  //             //     height: 50,
  //             //     width: 50,
  //             //     color: Colors.grey,
  //             //     child: //Center(child: Text("Your assets"))),
  //             //         //delete the just above code [child container ] and uncomment the below code and set your assets
  //             //      ),
  //
  //             _buildNotificationIcon(path),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 8.0),
  //               child: Text(
  //                 title,
  //                 style: kTitleStyle,
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildNotificationIcon(path) {
  //   return StreamBuilder(
  //       stream: ReadData.fetchNotificationDotStatus(_uId),
  //       builder: (context, snapshot) {
  //         return !snapshot.hasData
  //             ? SizedBox(
  //                 height: 30,
  //                 width: 30,
  //                 child: SvgPicture.asset(path, semanticsLabel: 'Acme Logo'),
  //               )
  //             : Stack(
  //                 children: [
  //                   SizedBox(
  //                     height: 30,
  //                     width: 30,
  //                     child:
  //                         SvgPicture.asset(path, semanticsLabel: 'Acme Logo'),
  //                   ),
  //                   snapshot.data["isAnyNotification"]
  //                       ? Positioned(
  //                           top: 0,
  //                           right: 5,
  //                           child: CircleAvatar(
  //                             radius: 5,
  //                             backgroundColor: Colors.red,
  //                           ))
  //                       : Positioned(top: 0, right: 0, child: Container())
  //                 ],
  //               );
  //       });
  // }

  Widget _image(String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: ImageBoxFillWidget(imageUrl: imageUrl)),
    );
  }

  Widget _buildContent(/*bannerImages*/) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width,

            child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Container(
                    color: Colors.grey,
                    child: ImageBoxFillWidget(
                      // imageUrl: bannerImages.banner1,
                    ) //recommended 200*300 pixel
                    )),
          ),
          const SizedBox(height:30),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20, top: 8.0),
            child: Container(
              child: _table(),
            ),
          ),
        ],
      ),
    );
  }

  void _checkTechnicalIssueStatus() async {
    final res = await ReadData.fetchSettings(); //fetch settings details
    if (res != null && res["technicalIssue"]) {
      DialogBoxes.technicalIssueAlertBox(context, "Sorry!",
          "we are facing some technical issues. our team trying to solve problems. hope we will come back very soon ");
    }
  }
}
