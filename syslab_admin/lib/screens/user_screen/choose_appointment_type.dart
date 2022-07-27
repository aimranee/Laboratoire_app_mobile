// import 'package:syslab_admin/screens/userScreen/newAppointmetTime.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/screens/user_screen/new_appointmet_time.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/error_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/Service/appointment_type_service.dart';

class ChooseTypePage extends StatefulWidget {
  final userDetails;

  const ChooseTypePage({Key key, this.userDetails}) : super(key: key);
  @override
  _ChooseTypePageState createState() => _ChooseTypePageState();
}

class _ChooseTypePageState extends State<ChooseTypePage> {
  int _number;
  int _serviceTimeMin;
  String _appointmentType = "";
  String _openingTime = "";
  String _closingTime = "";
  String uId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Types"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _appointmentType == "" ? false : true,
          onPressed: () {
            Get.to(
              ()=> NewAppointmentTimePage(
                  appointmentType: _appointmentType,
                  serviceTimeMin: _serviceTimeMin,
                  openingTime: _openingTime,
                  closingTime: _closingTime,
                  userDetails: widget.userDetails,
              ),
            );
          },
          title: "Suivant",
        ),
        body: _buildContent());
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(
                  top: 10.0, left: 20, right: 10, bottom: 10),
              child: Center(
                  child: Text("Quel type de rendez-vous",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 16.0,
                      )))),
          FutureBuilder(
              future: AppointmentTypeService
                  .getData(), //fetch all appointment types
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length == 0
                      ? NoDataWidget()
                      : _buildGridView(snapshot.data);
                } else if (snapshot.hasError) {
                  return IErrorWidget();
                } else {
                  return LoadingIndicatorWidget();
                }
              }),
        ],
      ),
    );
  }

  Widget _buildGridView(appointmentTypesDetails) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: GridView.count(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: .9,
        crossAxisCount: 2,
        children: List.generate(appointmentTypesDetails.length, (index) {
          return _cardImg(appointmentTypesDetails[index], index + 1); //send type details and index with increment one
        }),
      ),
    );
  }

  Widget _cardImg(
    appointmentTypesDetails,
    num num,
  ) {
    return GestureDetector(
      onTap: () {
        _serviceTimeMin = appointmentTypesDetails.forTimeMin;
        setState(() {
          if (_number == num) {
            //if user again tap
            setState(() {
              _appointmentType = ""; //clear name
              _number = 0;
              //set to zero
            });
          } else {
            //if user taps
            setState(() {
              _appointmentType = appointmentTypesDetails.title; //set the service name
              _serviceTimeMin = appointmentTypesDetails.forTimeMin; //set the service time
              //every appointment has defrent defrent time scheduled
              _openingTime = appointmentTypesDetails.openingTime;
              _closingTime = appointmentTypesDetails.closingTime;
            });

            _number = num; //set the number to taped card index+1
          }
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Stack(
          clipBehavior: Clip.none,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 40,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),//get images
                  ),
            ),
            Positioned.fill(
                left: 0,
                right: 0,
                bottom: 0,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: num ==
                            _number //if tap card value index+1 match with number value it mean user tap on the card
                        ? Container(
                            width: double.infinity,
                            height: 40,
                            color: btnColor,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(appointmentTypesDetails.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans-Bold',
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(appointmentTypesDetails.title,
                                      style: const TextStyle(
                                        fontFamily: 'OpenSans-Bold',
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                            ),
                          )))
          ],
        ),
      ),
    );
  }
}
