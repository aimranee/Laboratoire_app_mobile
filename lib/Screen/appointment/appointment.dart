import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/appointment/choosetimeslots.dart';
import 'package:laboratoire_app/Service/Firebase/readData.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/errorWidget.dart';
import 'package:laboratoire_app/widgets/imageWidget.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:laboratoire_app/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/utilities/dialogBox.dart';
import 'package:laboratoire_app/Service/appointmentTypeService.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({Key key}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int _number;
  int _serviceTimeMin;
  String _serviceName = "";
  String _openingTime = "";
  String _closingTime = "";
  String closedDay = "";
  bool isConn = Get.arguments;
  final bool _isLoading = false;

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar: _isLoading
          ? LoadingIndicatorWidget()
          : BottomNavigationStateWidget(
          title: "Next",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseTimeSlotPage(
                  serviceName: _serviceName,
                  serviceTimeMin: _serviceTimeMin,
                  openingTime: _openingTime,
                  closingTime: _closingTime,
                  closedDay: closedDay,
                  isConn : isConn
                ),
              ),
            );
            // Navigator.pushNamed(context, "/ChooseTimeSlotPage",
            //     arguments: ServiceScrArg(_serviceName, _serviceTimeMin,_openingTime,_closingTime));
          },
          clickable: _serviceName,
        ),
        drawer: CustomDrawer(isConn: isConn),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CAppBarWidget(title: "Book an appointment", isConn: isConn), //common app bar
            Positioned(
                top: 90,
                left: 0,
                right: 0,
                bottom: 0,
                child:
                //_stopBooking?showDialogBox():
                _buildContent()),
          ],
        ));
  }

  Widget _buildContent() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: IBoxDecoration.upperBoxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
                child: Center(
                    child: Text("What type of appointment",
                        style: kPageTitleStyle))),
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
          return _cardImg(appointmentTypesDetails[index],
              index + 1); //send type details and index with increment one
        }),
      ),
    );
  }

  Widget _cardImg(
    appointmentTypesDetails,
    num num,
  ) {
    // print("hhhhhhhhhhh : "+appointmentTypesDetails.day);
    return GestureDetector(
      onTap: () {
        _serviceTimeMin = appointmentTypesDetails.forTimeMin;
        setState(() {
          if (_number == num) {
            //if user again tap
            setState(() {
              _serviceName = ""; //clear name
              _number = 0;
              //set to zero
            });
          } else {
            //if user taps
            setState(() {
              _serviceName =
                  appointmentTypesDetails.title; //set the service name
              _serviceTimeMin =
                  appointmentTypesDetails.forTimeMin; //set the service time
              _openingTime = appointmentTypesDetails.openingTime;
              _closingTime = appointmentTypesDetails.closingTime;
              closedDay = appointmentTypesDetails.day;
            });

            _number = num; //set the number to taped card index+1
          }
        });
      },
      child: Container(
        //  height: MediaQuery.of(context).size.height * .2,
        // width:  MediaQuery.of(context).size.width*.15,
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 40,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: ImageBoxFillWidget(
                      // imageUrl: appointmentTypesDetails.imageUrl,
                    ) //get images
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
                                          fontSize: 12.0,
                                        )),
                                    Text(appointmentTypesDetails.subTitle,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 12.0,
                                        ))
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 40,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(appointmentTypesDetails.title,
                                        style: const TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 12.0,
                                        )),
                                    Text(appointmentTypesDetails.subTitle,
                                        style: const TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 12.0,
                                        )),
                                  ],
                                ),
                              ),
                            )))
            ],
          ),
        ),
      ),
    );
  }
}
