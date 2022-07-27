import 'package:get/get.dart';
import 'package:patient/Screen/splash_screen.dart';
import 'package:patient/Screen/appointment/my_location.dart';
import 'package:patient/Screen/categories.dart';
import 'package:patient/Screen/admin_profile_page.dart';
import 'package:patient/Screen/login_signup.dart';
import 'package:patient/Screen/appointment/appointment.dart';
import 'package:patient/Screen/appointment/appointment_status.dart';
import 'package:patient/Screen/appointment/choosetimeslots.dart';
import 'package:patient/Screen/appointment/confirmation.dart';
import 'package:patient/Screen/appointment/registerpatient.dart';
import 'package:patient/Screen/availiblity.dart';
import 'package:patient/Screen/conect_us.dart';
import 'package:patient/Screen/home.dart';
import 'package:patient/Screen/more_service.dart';
import 'package:patient/Screen/notification_page.dart';
import 'package:patient/Screen/prescription/prescription_list_page.dart';
import 'package:patient/Screen/analyses.dart';
import 'package:patient/Screen/user_profiel.dart';

class AppRoutes {
  static String  homeScreen = '/HomePage';
  static String  splashScreen = '/SplashScreen';
  static String  appointmentPage = '/AppoinmentPage';
  static String  aboutUs = '/AboutusPage';
  static String  chooseTimeSlotPage = "/ChooseTimeSlotPage";
  static String  availabilityPage ='/AvailabilityPage';
  static String  contactUs =   '/ContactUsPage';
  static String  appointmentStatus = '/Appointmentstatus';
  static String  reachUS = '/ReachUsPage';
  static String  analysesPage = '/AnalysesPage';
  static String  registerPatient = '/RegisterPatientPage';
  static String  confirmationPage = '/ConfirmationPage';
  static String  notificationPage = '/NotificationPage';
  static String  moreServiceScreen = '/MoreServiceScreen';
  static String  authTest = '/AuthTest';
  static String  editUserProfilePage = '/EditUserProfilePage';
  static String  documents = '/Documents';
  static String  authScreen = '/AuthScreen';
  static String  profile = '/Profile';
  static String  team = '/Team';
  static String  adminProfile = '/DoctorProfile';
  static String  categoryList = '/CategoryList';
  static String  myLocation = '/MyLocation';
  
  static List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: appointmentPage,
      page: () => const AppointmentPage(),
    ),
    GetPage(
      name: chooseTimeSlotPage,
      page: () => ChooseTimeSlotPage(),
    ),
    GetPage(
      name: availabilityPage,
      page: () => const AvailabilityPage(),
    ),
    GetPage(
      name: contactUs,
      page: () => ContactUs(),
    ),
    GetPage(
      name: appointmentStatus,
      page: () => const AppointmentStatus(),
    ),
    GetPage(
      name: analysesPage,
      page: () => AnalysesPage(),
    ),
    GetPage(
      name: registerPatient,
      page: () => const RegisterPatient(),
    ),
    GetPage(
      name: confirmationPage,
      page: () => const ConfirmationPage(),
    ),
    GetPage(
      name: notificationPage,
      page: () => const NotificationPage(),
    ),
    GetPage(
      name: moreServiceScreen,
      page: () => const MoreServiceScreen(),
    ),
    GetPage(
      name: documents,
      page: () => const PrescriptionListPage(),
    ),
    // GetPage(
    //   name: authTest,
    //   page: () => AuthService().handleAuth(),
    // ),
    GetPage(
      name: authScreen,
      page: () => const LoginSignupScreen(),
    ),

    GetPage(
      name: myLocation,
      page: () => MyLocation(),
    ),

    GetPage(
      name: profile,
      page: () => const UserProfilePage(),
    ),

    GetPage(
      name: adminProfile,
      page: () => AdminProfilePage(),
    ),

    GetPage(
      name: categoryList,
      page: () => const CategoryListPage(),
    ),
    
  ];
}
