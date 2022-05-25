// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:laboratoire_app/Service/app_data_controller.dart';
// import 'package:laboratoire_app/Service/category_service.dart';
// import 'package:laboratoire_app/SetData/screen_arg.dart';
// import 'package:laboratoire_app/model/analyses_category_model.dart';
// import 'package:laboratoire_app/utilities/color.dart';
// import 'package:laboratoire_app/utilities/decoration.dart';
// import 'package:laboratoire_app/widgets/appbars_widget.dart';
// import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
// import 'package:laboratoire_app/widgets/custom_drawer.dart';
// import 'package:laboratoire_app/widgets/error_widget.dart';
// import 'package:laboratoire_app/widgets/loading_indicator.dart';
// import 'package:laboratoire_app/widgets/no_data_widget.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';

// class ChooseAnalyses extends StatefulWidget {
//   const ChooseAnalyses({Key key}) : super(key: key);

//   @override
//   State<ChooseAnalyses> createState() => _ChooseAnalysesState();
// }

// class _ChooseAnalysesState extends State<ChooseAnalyses> {
//    final ScrollController _scrollController = ScrollController();
//     bool value = false;

//   bool isConn = true;
//   final bool _isLoading = false;

//   @override
//   void initState() {
    
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//   final AppDataController controller = Get.put(AppDataController());

//   @override
//   Widget build(BuildContext context) {

//     final PatientDetailsArg _patientDetailsArgs = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationStateWidget(
//           title: "Next",
//           onPressed: () {
//             Get.toNamed(
//                 '/ConfirmationPage',
//                 arguments: PatientDetailsArg(
//                   _patientDetailsArgs.pFirstName,
//                   _patientDetailsArgs.pLastName,
//                   _patientDetailsArgs.pPhn,
//                   _patientDetailsArgs.pEmail,
//                   _patientDetailsArgs.desc,
//                   _patientDetailsArgs.appointmentType,
//                   _patientDetailsArgs.serviceTimeMIn,
//                   _patientDetailsArgs.selectedTime,
//                   _patientDetailsArgs.selectedDate
//                 ),
//               );
//           },
//         ),
//         drawer: CustomDrawer(isConn: isConn),
//         body: Stack(
//           clipBehavior: Clip.none,
//           children: <Widget>[
//             CAppBarWidget(title: "Les analyses", isConn: isConn), //common app bar
//             Positioned(
//                 top: 90,
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height,
//                   decoration:IBoxDecoration.upperBoxDecoration(),
//                   child:FutureBuilder(
//                   future: CategoryService.getData(),
//                   //ReadData.fetchNotification(FirebaseAuth.instance.currentUser.uid),//fetch all times
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return snapshot.data.length == 0
//                           ? const NoDataWidget()
//                           : Padding(
//                           padding: const EdgeInsets.only(top: 0.0, left: 8, right: 8),
//                           child: _buildCard(snapshot.data));
//                     } else if (snapshot.hasError) {
//                       return const IErrorWidget();
//                     } else {
//                       return LoadingIndicatorWidget();
//                     }
//                   }
//                 ),
//               ),
//             )
//           ]
//         )
//       );
//   }
  

//   Widget _buildCard(catDetails) {
//         List subjectData = [];
//         List res;

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       controller.getSubjectData();
//     });
//     // _itemLength=notificationDetails.length;
//     return ListView.builder(
//         controller: _scrollController,
//         itemCount: catDetails.length,
//         itemBuilder: (context, index) {
//           return Card(
//               shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             child : GetBuilder<AppDataController>(builder: (controller) {
//             return Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: MultiSelectDialogField(
//                 items: res,
//                 title: const SizedBox(
//                   width:20,height:20,
//                   child: CircularProgressIndicator()),
//                 selectedColor: Colors.black,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.all(Radius.circular(30)),
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 2,
//                   ),
//                 ),
//                 buttonIcon: const Icon(
//                   Icons.keyboard_arrow_down_outlined, color: iconsColor,
//                   size: 20,
//                 ),
//                 buttonText: Text(
//                   catDetails[index].name,
//                   style: const TextStyle(
//                     fontFamily: 'OpenSans-Bold',
//                     fontSize: 14.0,
//                   )),
//                 onConfirm: (results) {
//                   subjectData = [];
//                   for (var i = 0; i < results.length; i++) {
//                     AnalysesCatModel data = results[i] as AnalysesCatModel;
//                     log(data.analysesId);
//                     log(data.analysesName);
//                     subjectData.add(data.analysesId);
//                   }
//                   log("data $subjectData");

//                 },
//               ),
//             );
//           }
//           ),
//           );
//         });
//   }
// }

// // FutureBuilder(
// //               future: AnalysesService.getDataId(catDetails[index].id),
// //               // child: GetBuilder<AppDataController>(builder: (controller) {
// //               builder: (context, snapshot) {
// //               return Padding(
// //                 padding: const EdgeInsets.all(10.0),
// //                 child: MultiSelectDialogField(
// //                   items: res,
// //                   title: const SizedBox(
// //                     width:20,height:20,
// //                     child: CircularProgressIndicator()),
// //                   selectedColor: Colors.black,
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: const BorderRadius.all(Radius.circular(30)),
// //                     border: Border.all(
// //                       color: Colors.white,
// //                       width: 2,
// //                     ),
// //                   ),
// //                   buttonIcon: const Icon(
// //                     Icons.keyboard_arrow_down_outlined, color: iconsColor,
// //                     size: 20,
// //                   ),
// //                   buttonText: Text(
// //                     catDetails[index].name,
// //                     style: const TextStyle(
// //                       fontFamily: 'OpenSans-Bold',
// //                       fontSize: 14.0,
// //                     )),
// //                   onConfirm: (results) {
// //                     subjectData = [];
// //                     for (var i = 0; i < results.length; i++) {
// //                       AnalysesCatModel data = results[i] as AnalysesCatModel;
// //                       log(data.analysesId);
// //                       log(data.analysesName);
// //                       subjectData.add(data.analysesId);
// //                     }
// //                     log("data $subjectData");

// //                   },
// //                 ),
// //               );
// //             }
// //           ),