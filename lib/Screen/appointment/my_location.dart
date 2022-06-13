import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:laboratoire_app/SetData/screen_arg.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MyLocation extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyLocation({Key key}) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  final _isBtnDisable = "false";
  
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target:  LatLng(30.4031875, -9.5285625),
    zoom: 15.6
  );

  @override
  Widget build(BuildContext context) {
    
    final PatientDetailsArg _patientDetailsArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      bottomNavigationBar: BottomNavigationStateWidget(
          title: "Suivant",
          onPressed: () {
            
            if (true) {
              
                Get.toNamed(
                  '/ConfirmationPage',
                  arguments: PatientDetailsArg(
                    _patientDetailsArgs.pFirstName,
                    _patientDetailsArgs.pLastName,
                    _patientDetailsArgs.pPhn,
                    _patientDetailsArgs.pEmail,
                    _patientDetailsArgs.pCity,
                    _patientDetailsArgs.desc,
                    _patientDetailsArgs.analyses,
                    _patientDetailsArgs.price,
                    _patientDetailsArgs.appointmentType,
                    _patientDetailsArgs.serviceTimeMIn,
                    _patientDetailsArgs.selectedTime,
                    _patientDetailsArgs.selectedDate,
                  ),
                );
                
            }
          },
          clickable: _isBtnDisable,
        ),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title: "Localisation", isConn: true),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: IBoxDecoration.upperBoxDecoration(),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    ),

                    child: GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      // markers: Set<Marker>.of(_markers),
                      onMapCreated: (GoogleMapController controller){
                        _controller.complete(controller);
                      }
                    )
                )
              ),
          ),
          // Positioned(
          //   bottom: 15,
          //   left: 10,
          //   right: 10,
          //   child: SizedBox(
          //       height: 160,
          //       child: Card(
          //         shape: const RoundedRectangleBorder(
          //           borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(10),
          //               topRight: Radius.circular(10),
          //               bottomRight: Radius.circular(10),
          //               bottomLeft: Radius.circular(10),
          //           ),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //               const Text(
          //                 "J'habite ici...",
          //                 style: kPageTitleStyle,
          //               ),
          //               FutureBuilder(
          //                   // future: DrProfileService
          //                   //     .getData(), //fetch doctors profile details like name, profileImage, description etc
          //                   builder: (context, snapshot) {
          //                     if (snapshot.hasData) {
          //                       return snapshot.data.length == 0
          //                           ? const Text("")
          //                           : Text(snapshot.data[0].address,
          //                               style: const TextStyle(
          //                                 fontFamily: 'OpenSans-SemiBold',
          //                                 fontSize: 12.0,
          //                               ));
          //                     } else if (snapshot.hasError) {
          //                       return const Text("");
          //                     } else {
          //                       return const LoadingIndicatorWidget();
          //                     }
          //                   }
          //                 ),
          //             ],
          //           ),
          //         ),
          //       )),
          // ),
        ],
      ),
    );
  }
}
