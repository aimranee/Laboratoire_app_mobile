// import 'package:syslab_admin/screens/appointmentScreen/appointmentListPage.dart';
// import 'package:syslab_admin/screens/appointmentScreen/editAppointmetDetailsPage.dart';
// import 'package:syslab_admin/screens/appointmentTypeScreen/addAppointmentTypes.dart';
// import 'package:syslab_admin/screens/appointmentTypeScreen/appointmentTypesPage.dart';
// import 'package:syslab_admin/screens/editAvailabilityPage.dart';
// import 'package:syslab_admin/screens/settingScreen/editSettingPage.dart';
// import 'package:syslab_admin/screens/userScreen/registerPatientPage.dart';
// import 'package:syslab_admin/screens/userScreen/userLsitPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// import 'package:syslab_admin/notificationScreen/notificationDetailsPage.dart';
// import 'package:syslab_admin/notificationScreen/notificationListPage.dart';
// import 'package:syslab_admin/notificationScreen/sendNotificationPage.dart';
// import 'package:syslab_admin/notificationScreen/sendNotificationToAllUserPage.dart';
// import 'package:syslab_admin/notificationScreen/usersListForNotificationPage.dart';
// import 'package:syslab_admin/screens/editBannerImagesPage.dart';
// import 'package:syslab_admin/screens/editOpeningClosingTimePage.dart';
// import 'package:syslab_admin/screens/editProfilePage.dart';
import 'package:syslab_admin/screens/homePage.dart';
// import 'package:syslab_admin/screens/searchScreen/searchAppointmentByIDPage.dart';
// import 'package:syslab_admin/screens/searchScreen/searchAppointmentByNamePage.dart';
// import 'package:syslab_admin/screens/searchScreen/searchUserByIdPage.dart';
// import 'package:syslab_admin/screens/searchScreen/searchUserByNamePage.dart';
// import 'package:syslab_admin/screens/serviceScreen/addServicePage.dart';
// import 'package:syslab_admin/screens/serviceScreen/servicePage.dart';
// import 'package:syslab_admin/screens/settingScreen/addDateToCloseBookingPage.dart';
import 'package:syslab_admin/service/authService/authService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // if (USE_FIRESTORE_EMULATOR) {
  //   FirebaseFirestore.instance.settings = Settings(
  //       host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  // }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primaryColor: primaryColor,
          // Define the default font family.
          // fontFamily: 'Georgia',
          ),
      // home: _defaultHome,
      // initialRoute: '/',
      routes: {
        '/': (context) => // EditAvailabilityPage(),

            AuthService().handleAuth(),
        // '/AddServicePage': (context) => AddServicePage(),
        // '/EditAppointmentDetailsPage': (context) => const EditAppointmentDetailsPage(),
        // '/AppointmentListPage': (context) => AppointmentListPage(),
        // '/ServicesPage': (context) => ServicesPage(),
        // '/EditProfilePage': (context) => EditProfilePage(),
        // '/EditOpeningClosingTime': (context) => EditOpeningClosingTime(),
        // '/EditAvailabilityPage': (context) => EditAvailabilityPage(),
        // '/AppointmentTypesPage': (context) => AppointmentTypesPage(),
        // '/AddAppointmentTypesPage': (context) => const AddAppointmentTypesPage(),
        // '/EditBookingTiming': (context) => EditSettingPage(),
        // '/UsersListPage': (context) => UsersListPage(),
        '/HomePage': (context) => HomePage(),
        // '/SearchAppointmentByIdPage': (context) => SearchAppointmentByIdPage(),
        // '/SearchAppointmentByNamePage': (context) => SearchAppointmentByNamePage(),
        // '/AddDateToCloseBookingPage': (context) => AddDateToCloseBookingPage(),
        // '/SearchUserByNamePage': (context) => SearchUserByNamePage(),
        // '/SearchUserByIdPage': (context) => SearchUserByIdPage(),
        // '/NewBlogPostPage': (context) => NewBlogPostPage(),
        // '/BlogPostPage': (context) => BlogPostPage(),
        // '/RegisterPatientPage': (context) => RegisterPatient(),
      },
    );
  }
}
