import 'package:get/get.dart';
import 'package:syslab_admin/screens/edit_availability_page.dart';
import 'package:syslab_admin/screens/home_page.dart';
import 'package:syslab_admin/screens/user_screen/user_list_page.dart';

class AppRoutes {
  static String  homePage = '/HomePage';
  static String  authTest = '/AuthTest';
  static String  editAvailabilityPage = '/EditAvailabilityPage';
  static String  usersListPage = '/UsersListPage';


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
      page: () => UsersListPage(),
    ),

    // GetPage(
    //   name: authTest,
    //   page: () => AuthService().handleAuth(),
    // ),
    
  ];  
}