// import 'package:flutter_geocoder/geocoder.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syslab_admin/screens/user_screen/confiramtionPage.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/font_style.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';

class MyLocation extends StatefulWidget {
  final userDetails;
  final String appointmentType;
  final int serviceTimeMin;
  final String setTime;
  final String selectedDate;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String city;
  final String des;
  final String analyses;
  final double price;
  final String location;

  const MyLocation({Key key, 
    this.userDetails, 
    this.appointmentType,   
    this.serviceTimeMin, 
    this.setTime, 
    this.selectedDate, 
    this.firstName, 
    this.lastName, 
    this.phoneNumber, 
    this.email, 
    this.city, 
    this.des, 
    this.analyses, 
    this.price, 
    this.location
  }) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  
  GoogleMapController googleMapController;
  double latitude = 0;
  double longitude = 0;
  String addressPatient = "";
  String addressLine = "";
  int id = 0;
  // TextEditingController _searchController = TextEditingController();
  // final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target:  LatLng(30.4031875, -9.5285625),
    zoom: 14
  );
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    
    // final PatientDetailsArg _patientDetailsArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: IAppBars.commonAppBar(context, "Emplacement"),
      bottomNavigationBar: BottomNavBarWidget(
          title: "Suivant",
          onPressed: () {
            
            if (longitude != 0) {
              
                Get.to(
                  () => ConfirmationPage(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    phoneNumber: widget.phoneNumber,
                    email: widget.email,
                    city: widget.city,
                    des: widget.des,
                    appointmentType: widget.appointmentType,
                    serviceTimeMin: widget.serviceTimeMin,
                    setTime: widget.setTime,
                    selectedDate: widget.selectedDate,
                    uId: widget.userDetails.uId,
                    analyses: widget.analyses,
                    price: widget.price,
                    location: addressPatient,
                    cin: widget.userDetails.cin,
                    userFcmId: widget.userDetails.fcmId
                  ),
                );
                
            }
          },
          isEnableBtn: longitude == 0 ? false : true,
        ),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                // decoration: IBoxDecoration.upperBoxDecoration(),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    ),
                          
                    child: GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      markers: markers,
                      zoomControlsEnabled: false,
                      onTap: (LatLng latLng) async {
                        GeoCode geoCode = GeoCode();
                        Address address =
                            await geoCode.reverseGeocoding(latitude: latLng.latitude, longitude: latLng.longitude);
                        String adresse = "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
                        Marker newMarker = Marker(
                          markerId: MarkerId('$id'),
                          position: LatLng(latLng.latitude, latLng.longitude),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        );
                        markers.clear();
                        markers.add(newMarker);

                        // log("message : "+first.addressLine.toString());
                        setState(() {
                          longitude = latLng.longitude;
                          latitude = latLng.latitude;
                          addressPatient = "$latitude,$longitude";
                          addressLine = adresse;
                        });
                      },
                      onMapCreated: (GoogleMapController controller){
                        googleMapController = controller;
                      }
                    ),
                )
              ),
          ),
          Positioned(
            bottom: 25,
            left: 10,
            right: 10,
            child: SizedBox(
                height: 170,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "",
                          style: kCardSubTitleStyle,
                        ),
                        
                        if (longitude==0)
                        const Text("..."),
                        if (longitude!=0)
                          Text(addressLine,
                            style: kCardSubTitleStyle,
                          ),
                             
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),

      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 115),
        child: FloatingActionButton.extended(
          backgroundColor: appBarColor,
          onPressed: () async {
            
            Position position = await _determinePosition();
            
            googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

            markers.clear();

            markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));
            
            GeoCode geoCode = GeoCode();
            Address address =
                await geoCode.reverseGeocoding(latitude: position.latitude, longitude: position.longitude);
            String adresse = "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
            setState(() {
              longitude = position.longitude;
              latitude = position.latitude;
              addressLine = adresse;
              addressPatient = "$latitude,$longitude";
            });

          },
          label: const Text("Choisir ma location"),
          icon: const Icon(Icons.location_history),
          
        ),
      ),
    );
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
