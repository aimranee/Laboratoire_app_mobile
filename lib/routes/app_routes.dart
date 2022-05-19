import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/dr_profile_page.dart';
import 'package:laboratoire_app/Screen/login_signup.dart';
import 'package:laboratoire_app/Screen/appointment/appointment.dart';
import 'package:laboratoire_app/Screen/appointment/appointment_status.dart';
import 'package:laboratoire_app/Screen/appointment/choosetimeslots.dart';
import 'package:laboratoire_app/Screen/appointment/confirmation.dart';
import 'package:laboratoire_app/Screen/appointment/registerpatient.dart';
import 'package:laboratoire_app/Screen/availiblity.dart';
import 'package:laboratoire_app/Screen/conect_us.dart';
import 'package:laboratoire_app/Screen/home.dart';
import 'package:laboratoire_app/Screen/more_service.dart';
import 'package:laboratoire_app/Screen/notification_page.dart';
import 'package:laboratoire_app/Screen/prescription/prescription_list_page.dart';
import 'package:laboratoire_app/Screen/reachus.dart';
import 'package:laboratoire_app/Screen/services.dart';
import 'package:laboratoire_app/Screen/team_doctor.dart';
import 'package:laboratoire_app/Screen/user_profiel.dart';

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
  static String  team = '/Team';
  static String  doctorProfile = '/DoctorProfile';
  
  static List<GetPage> pages = [
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
      page: () => const ContactUs(),
    ),
    GetPage(
      name: appointmentStatus,
      page: () => const AppointmentStatus(),
    ),
    GetPage(
      name: reachUS,
      page: () => const ReachUS(),
    ),
    GetPage(
      name: servicesPage,
      page: () => const ServicesPage(),
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
      name: profile,
      page: () => const UserProfilePage(),
    ),
    
    GetPage(
      name: team,
      page: () => const TeamDoctPage(),
    ),

    GetPage(
      name: doctorProfile,
      page: () => DoctorProfilePage(),
    ),
    
  ];
}
