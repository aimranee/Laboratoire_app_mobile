import 'package:get/get.dart';
import 'package:syslab_admin/screens/homePage.dart';
import 'package:syslab_admin/service/authService/authService.dart';

class AppRoutes {
  static String  homePage = '/HomePage';
  static String  authTest = '/AuthTest';


  static List<GetPage> pages = [
    GetPage(
      name: homePage,
      page: () => const HomePage(),
    ),

    // GetPage(
    //   name: authTest,
    //   page: () => AuthService().handleAuth(),
    // ),
    
  ];  
}