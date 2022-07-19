import 'package:get/get.dart';
import 'package:syslab_admin/screens/appointment_type/appointment_type.dart';
import 'package:syslab_admin/screens/appointments/appointment_list_page.dart';
import 'package:syslab_admin/screens/edit_availability_page.dart';
import 'package:syslab_admin/screens/home_page.dart';
import 'package:syslab_admin/screens/notification_page.dart';
import 'package:syslab_admin/screens/search_screeen/search_appointment_by_cin.dart';
import 'package:syslab_admin/screens/user_screen/user_list_page.dart';

class AppRoutes {
  static String  homePage = '/HomePage';
  static String  authTest = '/AuthTest';
  static String  editAvailabilityPage = '/EditAvailabilityPage';
  static String  usersListPage = '/UsersListPage';
  static String  appointmentListPage = '/AppointmentListPage';
  static String  editOpeningClosingTime = '/EditOpeningClosingTime';
  static String  appointmentTypesPage = '/AppointmentTypesPage';
  static String  notificationListPage = '/NotificationListPage';
  static String  searchAppointmentByCINPage = '/SearchAppointmentByCINPage';


  static List<GetPage> pages = [
    GetPage(
      name: homePage,
      page: () => const HomePage(),
    ),

    GetPage(
      name: editAvailabilityPage,
      page: () => EditAvailabilityPage(),
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

    // GetPage(
    //   name: authTest,
    //   page: () => AuthService().handleAuth(),
    // ),
    
  ];  
}