
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/screens/login_page.dart';
import 'package:syslab_admin/service/notification/firebase_notification.dart';
import 'package:syslab_admin/service/notification/local_notification.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/clip_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _gridScrollController = ScrollController();
  bool _isLoading = false;
  var uId = "";
  final List _widgetsList = [
    {
      "iconName": "assets/icons/appoin.svg",
      "title": "Rendez-vous",
      "navigation": "/AppointmentListPage"
    },
    {
      "iconName": "assets/icons/teeth.svg",
      "title": "Analyses",
      "navigation": "/CategoriesPage"
    },
    {
      "iconName": "assets/icons/group.svg",
      "title": "Utilisateurs",
      "navigation": "/UsersListPage"
    },
    {
      "iconName": "assets/icons/bell.svg",
      "title": "Notification",
      "navigation": "/NotificationListPage"
    },
    {
      "iconName": "assets/icons/timing.svg",
      "title": "Horaire",
      "navigation": "/AppointmentTypesPage"
    },
    {
      "iconName": "assets/icons/sch.svg",
      "title": "Disponibilité",
      "navigation": "/EditAvailabilityPage"
    },
    {
      "iconName": "assets/icons/doct.svg",
      "title": "Contats",
      "navigation": "/EditContactPage"
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    FirebaseNotification.handleNotifications(
        context); //initialize firebase messaging
    LocalNotification.initializeFlutterNotification(
        context); //initialize local notification
    handleAuth();
    super.initState();
  }

  handleAuth() async {
    //start loading indicator
    setState(() {
      _isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString("token").toString();
    if (token != "" && token != "null") {
      setState((){
        uId = pref.getString("uId");
      });
      // log(uId.toString());
      final user = await AdminService.getData();
      pref.setString("firstName", user[0].firstName);
      pref.setString("lastName", user[0].lastName);
      
      setState(() {
        _isLoading = false;
      });
      

    }else{
      setState(() {
        _isLoading = false;
      });
      Get.to(() => const LoginPage());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
      ? const LoadingIndicatorWidget()
      : Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: _bottomCircularBox()),
          Positioned.fill(
            child: _adminImageAndText(),
          ),
          const Positioned(top: 20, right: 5, child: SignOutBtnWidget()),
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
            Get.toNamed(_widgetsList[index]["navigation"]);
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
                _widgetsList[index]["title"] == "Notification"?
                     _buildNotificationIcon(_widgetsList[index]["iconName"]) :
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
          decoration: const BoxDecoration(gradient: gradientColor),
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
      ],
    );
  }

  Widget _buildNotificationIcon(widgetName) {
    
    return FutureBuilder(
        future: AdminService.fetchNotificationStatusAdmin(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data[0].isAnyNotification == "0" 
              ? SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset(widgetName, semanticsLabel: 'Acme Logo'),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset(widgetName,
                          semanticsLabel: 'Acme Logo'),
                    ),
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.red,
                      )
                    )
                  ],
                );
          }else {
            return Positioned(top: 0, right: 0, child: Container());
          }
        });
  }
}
