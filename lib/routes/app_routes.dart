import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/Login_SignUp.dart';
import 'package:laboratoire_app/Screen/appointment/appointment.dart';
import 'package:laboratoire_app/Screen/appointment/appointmentStatus.dart';
import 'package:laboratoire_app/Screen/appointment/choosetimeslots.dart';
import 'package:laboratoire_app/Screen/appointment/confirmation.dart';
import 'package:laboratoire_app/Screen/appointment/registerpatient.dart';
import 'package:laboratoire_app/Screen/availiblity.dart';
import 'package:laboratoire_app/Screen/conectUs.dart';
import 'package:laboratoire_app/Screen/Userprofiel.dart';
import 'package:laboratoire_app/Screen/home.dart';
import 'package:laboratoire_app/Screen/moreService.dart';
import 'package:laboratoire_app/Screen/notificationPage.dart';
import 'package:laboratoire_app/Screen/prescription/prescriptionListPage.dart';
import 'package:laboratoire_app/Screen/reachus.dart';
import 'package:laboratoire_app/Screen/services.dart';

class AppRoutes {
  static String  homeScreen = '/HomePage';
  static String  appointmentPage = '/AppoinmentPage';
  static String  aboutUs = '/AboutusPage';
  static String  chooseTimeSlotPage = "/ChooseTimeSlotPage";
  static String  availabilityPage ='/AvailabilityPage';
  static String  contactUs =   '/ContactUsPage';
  static String  appointmentStatus = '/Appointmentstatus';
  static String  reachUS = '/ReachUsPage';
  static String  servicesPage = '/ServicesPage';
  static String  registerPatient = '/RegisterPatientPage';
  static String  confirmationPage = '/ConfirmationPage';
  static String  notificationPage = '/NotificationPage';
  static String  moreServiceScreen = '/MoreServiceScreen';
  static String  authTest = '/AuthTest';
  static String  editUserProfilePage = '/EditUserProfilePage';
  static String  documents = '/Documents';
  static String  authScreen = '/AuthScreen';
  static String  profile = '/Profile';
  
  static List<GetPage> pages = [
    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: appointmentPage,
      page: () => AppointmentPage(),
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
      name: reachUS,
      page: () => ReachUS(),
    ),
    GetPage(
      name: servicesPage,
      page: () => const ServicesPage(),
    ),
    GetPage(
      name: registerPatient,
      page: () => RegisterPatient(),
    ),
    GetPage(
      name: confirmationPage,
      page: () => ConfirmationPage(),
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
      page: () => LoginSignupScreen(),
    ),

    GetPage(
      name: profile,
      page: () => const UserProfilePage(),
    ),
    
  ];
}
