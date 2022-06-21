import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/curverdpath.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/widgets/call_msg_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool isConn = Get.arguments;
  @override
  void initState() {
     
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target:  LatLng(30.4031875, -9.5285625),
    zoom: 15.6
  );

  final List<Marker> _markers = [];
    


  @override
  Widget build(BuildContext context) {
    _markers.add(
      const Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(30.4031875, -9.5285625),
        infoWindow: InfoWindow(
        title: 'P2M location'
        )
      )
    );
    return Scaffold(
      drawer : CustomDrawer(isConn: isConn),
        body: SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        height: 240,
        // color: Colors.yellowAccent,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            SizedBox(
              height: 130,
              width: MediaQuery.of(context).size.width,
              // color: Colors.red,
              child: CustomPaint(
                painter: CurvePainter(),
              ),
            ),
            Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: appBarIconColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      "Contactez-nous",
                      style: kAppbarTitleStyle,
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.home,
                          color: appBarIconColor,
                        ),
                        onPressed: () {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/HomePage'));
                        })
                  ],
                )),
            Positioned(
              top: 70,
              left: 25,
              right: 25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.only(top: 30, left: 30.0),
                          child: Text(
                              "Laboratoire P2M SYSLAB",
                              //doctors first name and last name
                              style: TextStyle(
                                color: Colors.black,
                                //change colors form here
                                fontFamily: 'OpenSans-Bold',
                                // change font style from here
                                fontSize: 15.0,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child: Text(
                              //"jhdsvdsh",
                              "POTENTIEL 2 MAROC",
                              //doctor subtitle
                              style: TextStyle(
                                color: Colors.black,
                                //change colors form here
                                fontFamily: 'OpenSans-Bold',
                                // change font style from here
                                fontSize: 15.0,
                              )),
                        ),
                        CallMsgWidget(
                          primaryNo: "0604440684",
                          whatsAppNo: "0604440684",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 25, top: 10),
          child: _callUsMailUsBox("0604440684", "KHAOULA.TOUIJER@P2M.MA")),
      const Padding(
        padding: EdgeInsets.only(top: 8, left: 40.0, right: 25),
        child: Text("Location", style: kPageTitleStyle),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 25, top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * .39,
                width: MediaQuery.of(context).size.width * .8,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: 
                  Card(
                    // color: Colors.black,
                    elevation: 10.0,
                    child: 
                    GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      markers: Set<Marker>.of(_markers),
                      onMapCreated: (GoogleMapController controller){
                        _controller.complete(controller);
                      }
                    )
                )
                ),
                )
            
          ],
        ),
      )
    ],
      ),
    ));
  }

  Widget _callUsMailUsBox(String phn, String email) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * .10,
          width: MediaQuery.of(context).size.width * .8,
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("appelez-nous", style: kPageTitleStyle),
                    Text(
                      phn,
                      style: const TextStyle(
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
          width: MediaQuery.of(context).size.width * .8,
          child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Envoyez-nous un courrier", style: kPageTitleStyle),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
