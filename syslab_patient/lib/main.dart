import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:patient/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true,);
  initializeDateFormatting();
  // Stripe.publishableKey = 'pk_test_51L5terGwqZ9fHWymgPqbertK1y3uH71QFgPBIaSBuegAhrw9ClYypmglh1ifEmkmMkPbZH3tEEjD1XPvaviAu1YK002PzXuYGp';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return //<--- ChangeNotifierProvider

      GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.homeScreen,
      getPages: AppRoutes.pages,
      
    );
  }
}

class NotificationDotModel {}
