import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patient/Service/admin_profile_service.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/curverdpath.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/widgets/call_msg_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:patient/widgets/error_widget.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:patient/widgets/no_data_widget.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

double latitude = 0;
double longitude = 0;

class _ContactUsState extends State<ContactUs> {
  bool isConn = Get.arguments;
  @override
  void initState() {
    _setData();
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex = CameraPosition(
    target:  LatLng(latitude, longitude),
    zoom: 14.0
  );

  final List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer : CustomDrawer(isConn: isConn),
      body: FutureBuilder(
        future : AdminProfileService.getData(),
        builder: (context, snapshot) {
          if(snapshot.hasData)
            return snapshot.data.length == 0 
            ? NoDataWidget()
            : _buildContent(snapshot.data[0]);
          else if (snapshot.hasError)
            return IErrorWidget();
          else
            return LoadingIndicatorWidget();
        }
      )
      
    );
  }

  Widget _buildContent(profile) {
    
    return Container(
    child: SingleChildScrollView(
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
                        children: [
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.only(top: 20, left: 30.0, bottom: 10.0),
                            child: Text(
                                "Laboratoire : ${profile.laboratoireName}",
                                //doctors first name and last name
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans-Bold',
                                  fontSize: 15.0,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0, bottom: 10.0),
                            child: Text(
                                "Directeur : ${profile.firstName} ${profile.lastName}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans-Bold',
                                  fontSize: 15.0,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:70.0),
                            child: CallMsgWidget(
                              primaryNo: profile.pNo1,
                              whatsAppNo: profile.whatsAppNo,
                            ),
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
            child: _callUsMailUsBox(profile.pNo1, profile.pNo2, profile.email)),
        const Padding(
          padding: EdgeInsets.only(top: 8, left: 40.0, right: 25),
          child: Text("Location :", style: kPageTitleStyle),
        ),
        _locationPatient(latitude, longitude),
        const Padding(
          padding: EdgeInsets.only(top: 8, left: 40.0, right: 25),
          child: Text("À propos de nous :", style: kPageTitleStyle),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 25, top: 8.0, bottom: 28.0),
          child: Text(
            profile.aboutUs,
            style: kParaStyle,
          ))
      ],
      ),
      )
    );
  }   
  Widget _callUsMailUsBox(String phn1, String phn2, String email) {
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
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(child: Text("appelez-nous", style: kPageTitleStyle)),
                  SizedBox(height:12),
                  Center(
                    child: Text(
                      "$phn1   /   $phn2",
                      style: const TextStyle(
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
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
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(child: const Text("Envoyez-nous un courrier", style: kPageTitleStyle)),
                      SizedBox(height:12),
                      Center(
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 16.0,
                          ),
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
  _locationPatient (latitude, longitude) {
    
    _markers.add(
      Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
        title: 'P2M location'
        )
      )
    );
    return Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 25, top: 8.0),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * .39,
            width: MediaQuery.of(context).size.width * .8,
            child: IgnorePointer(ignoring: true,
              child: GoogleMap(
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller){
                  _controller.complete(controller);
                },
              ),
            ),
        ),
      );
  }

  _setData() async {
    final  res = await AdminProfileService.getData();
    String address = res[0].address;
    setState((){
      latitude = double.parse(address.split(',')[0]);
      longitude = double.parse(address.split(',')[1]);
    });
  }

}
