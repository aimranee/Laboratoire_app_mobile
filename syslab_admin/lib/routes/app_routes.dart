import 'package:get/get.dart';
import 'package:syslab_admin/screens/analyses_page.dart/add_analyses.dart';
import 'package:syslab_admin/screens/appointment_type/appointment_type.dart';
import 'package:syslab_admin/screens/appointments/appointment_list_page.dart';
import 'package:syslab_admin/screens/analyses_page.dart/analyses_page.dart';
import 'package:syslab_admin/screens/categories_screen/add_categories_page.dart';
import 'package:syslab_admin/screens/categories_screen/categories_page.dart';
import 'package:syslab_admin/screens/edit_availability_page.dart';
import 'package:syslab_admin/screens/edit_contact_page.dart';
import 'package:syslab_admin/screens/home_page.dart';
import 'package:syslab_admin/screens/notification_page.dart';
import 'package:syslab_admin/screens/search_screeen/search_appointment_by_cin.dart';
import 'package:syslab_admin/screens/search_screeen/search_patient_by_cin.dart';
import 'package:syslab_admin/screens/splash_screen.dart';
import 'package:syslab_admin/screens/user_screen/user_list_page.dart';

class AppRoutes {
  static String  homePage = '/HomePage';
  static String  splashScreen = '/SplashScreen';
  static String  authTest = '/AuthTest';
  static String  editAvailabilityPage = '/EditAvailabilityPage';
  static String  usersListPage = '/UsersListPage';
  static String  appointmentListPage = '/AppointmentListPage';
  static String  editOpeningClosingTime = '/EditOpeningClosingTime';
  static String  appointmentTypesPage = '/AppointmentTypesPage';
  static String  notificationListPage = '/NotificationListPage';
  static String  searchAppointmentByCINPage = '/SearchAppointmentByCINPage';
  static String  searchPatientByCINPage = '/SearchPatientByCINPage';
  static String  analysesPage = '/AnalysesPage';
  static String  categoriesPage = '/CategoriesPage';
  static String  addCategoriesPage = '/AddCategoriesPage';
  static String  addAnalysePage = '/AddAnalysePage';
  static String  editContactPage = '/EditContactPage';


  static List<GetPage> pages = [
    GetPage(
      name: homePage,
      page: () => const HomePage(),
    ),

    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
    ),

    GetPage(
      name: editAvailabilityPage,
      page: () => const EditAvailabilityPage(),
    ),

    GetPage(
      name: usersListPage,
      page: () => const UsersListPage(),
    ),

    GetPage(
      name: appointmentListPage,
      page: () => const AppointmentListPage(),
    ),

    GetPage(
      name: appointmentTypesPage,
      page: () => const AppointmentTypesPage(),
    ),
    
    GetPage(
      name: notificationListPage,
      page: () => const NotificationListPage(),
    ),

    GetPage(
      name: searchAppointmentByCINPage,
      page: () => const SearchAppointmentByCINPage(),
    ),

    GetPage(
      name: searchPatientByCINPage,
      page: () => const SearchPatientByCINPage(),
    ),

    GetPage(
      name: analysesPage,
      page: () => const AnalysesPage(),
    ),

    GetPage(
      name: categoriesPage,
      page: () => const CategoriesPage(),
    ),

    GetPage(
      name: addCategoriesPage,
      page: () => const AddCategoriesPage(),
    ),

    GetPage(
      name: addAnalysePage,
      page: () => const AddAnalysePage(),
    ),

    GetPage(
      name: editContactPage,
      page: () => const EditContactPage(),
    ),

    // GetPage(
    //   name: authTest,
    //   page: () => AuthService().handleAuth(),
    // ),
    
  ];  
}