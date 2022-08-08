
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syslab_admin/model/admin_model.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/font_style.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';


class EditContactPage extends StatefulWidget {
  const EditContactPage({Key key}) : super(key: key);

  @override
  _EditContactPageState createState() => _EditContactPageState();
}
  double latitude = 0;
  double longitude = 0;

class _EditContactPageState extends State<EditContactPage> {
  bool _isLoading = false;
  String _id = "";
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _laboratoireNameController = TextEditingController();
  final TextEditingController _aboutUsController = TextEditingController();
  final TextEditingController _whatsAppNoController = TextEditingController();
  final TextEditingController _primaryPhnController = TextEditingController();
  final TextEditingController _secondaryPhnController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fcmIdAdminController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    _fetchUserDetails(); //get and set all initial values
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _laboratoireNameController.dispose();
    _whatsAppNoController.dispose();
    _primaryPhnController.dispose();
    _secondaryPhnController.dispose();
    _aboutUsController.dispose();
    _addressController.dispose();
    _fcmIdAdminController.dispose();
    super.dispose();
  }

  GoogleMapController googleMapController;

  String addressAdmin = "";
  String addressLine = "";
  int id = 0;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target:  LatLng(latitude, longitude),
    zoom: 14
  );
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          title: "Update",
          onPressed: _takeConfirmation,
          isEnableBtn: _isEnableBtn,
        ),
        appBar: IAppBars.commonAppBar(context, "Edit Profile"),
        body: _isLoading
            ? const LoadingIndicatorWidget()
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    _inputField(
                        "First Name", "Enter first name", _firstNameController),
                    _inputField(
                        "Last Name", "Enter last name", _lastNameController),
                    _inputField(
                        "Last Name", "Enter last name", _laboratoireNameController),
                    _emailInputField(),
                    _phnNumInputField(
                        _primaryPhnController, "Enter primary phone number"),
                    _phnNumInputField(_secondaryPhnController,
                        "Enter secondary phone number"),
                    _phnNumInputField(
                        _whatsAppNoController, "Enter WhatsApp phone number"),
                    _descInputField(_aboutUsController, "About us", 5),

                    const SizedBox(height: 20),
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                       SizedBox(
                          // decoration: IBoxDecoration.upperBoxDecoration(),
                          width: MediaQuery.of(context).size.width,
                          height: 600,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)
                                ),
                    
                                // child: Column(
                                //   children: [
                                //     Row(children: [
                                //       Expanded(child: TextFormField(
                                //         controller: _searchController,
                                //         textCapitalization: TextCapitalization.words,
                                //         decoration: InputDecoration(hintText: 'Search by city'),
                                //       )),
                                //       IconButton(onPressed: () {}, icon: Icon(Icons.search),)
                                //     ],),
                                //     Expanded(
                                      
                                      child: 
                                      // Container(color: Colors.black,)
                                      GoogleMap(
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
                                            addressAdmin = "$latitude,$longitude";
                                            addressLine = adresse;
                                          });
                                        },
                                        onMapCreated: (GoogleMapController controller){
                                          googleMapController = controller;
                                        }
                                      ),
                                    // ),
                                  // ],
                                // )
                            ),
                          )
                        ),
                        Positioned(
                          bottom: 40,
                          left: 10,
                          right: 10,
                          child: SizedBox(
                              height: 120,
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
                                        Text(
                                          addressLine,
                                          style: kCardSubTitleStyle,
                                        ),
                                          
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        Positioned(
                          bottom: 110,
                          left: 120,
                          right: 120,
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
                                addressAdmin = "$latitude,$longitude";
                              });

                            },
                            label: const Text("Ma location"),
                            icon: const Icon(Icons.location_history),
                            
                          ),
                        ),
                      ]
                    ),
                    // const SizedBox(height: 20),
                  ],
                ),
              ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Update",
        "Are you sure you want to update profile details",
        _updateDetails); //take a confirmation form the user
  }

  _updateDetails() async {

    DateTime now = DateTime.now();
    String timeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);

    final adminModel = AdminModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        laboratoireName: _laboratoireNameController.text,
        uId: _id,
        aboutUs: _aboutUsController.text,
        email: _emailController.text,
        address: addressAdmin,
        pNo1: _primaryPhnController.text,
        pNo2: _secondaryPhnController.text,
        whatsAppNo: _whatsAppNoController.text,
        fcmId: _fcmIdAdminController.text,
        updatedTimeStamp: timeStamp);
    // log(">>>>>>>>>>>>>>>>>>>>>>${adminModel.toUpdateJson()}");
    final res = await AdminService.updateData(adminModel);
    if (res == "success") {
      ToastMsg.showToastMsg("Mise à jour réussie");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/EditContactPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _descInputField(controller, labelText, maxLine) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : "Entrez la description";
    }, TextInputType.multiline, maxLine);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
  }

  Widget _emailInputField() {
    return InputFields.commonInputField(_emailController, "Email", (item) {
      Pattern pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(item) || item == null) {
        return 'Entrez une adresse mail valide';
      } else {
        return null;
      }
    }, TextInputType.emailAddress, 1);
  }

  Widget _phnNumInputField(controller, labelText) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length == 10
          ? null
          : "Entrez un numéro de mobile à 10 chiffres avec l'indicatif du pays";
    }, TextInputType.phone, 1);
  }

  void _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    final res = await AdminService.getData();
    
    setState(() {
      //set all the values in to text fields
      _emailController.text = res[0].email;
      _lastNameController.text = res[0].lastName;
      _laboratoireNameController.text = res[0].laboratoireName;
      _firstNameController.text = res[0].firstName;
      _whatsAppNoController.text = res[0].whatsAppNo;
      _primaryPhnController.text = res[0].pNo1;
      _secondaryPhnController.text = res[0].pNo2;
      _aboutUsController.text = res[0].aboutUs;
      latitude = double.parse(res[0].address.split(',')[0]);
      longitude = double.parse(res[0].address.split(',')[1]);
      _fcmIdAdminController.text = res[0].fcmId;
      _id = res[0].uId;
    });
    Marker newMarker = Marker(
      markerId: MarkerId('$id'),
      position: LatLng(latitude, longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    markers.add(newMarker);
    GeoCode geoCode = GeoCode();
    Address address =
        await geoCode.reverseGeocoding(latitude: latitude, longitude: longitude);
    String adresse = "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
    setState(() {
      addressAdmin = "$latitude,$longitude";
      addressLine = adresse;

    });
    setState(() {
      _isLoading = false;
    });
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
