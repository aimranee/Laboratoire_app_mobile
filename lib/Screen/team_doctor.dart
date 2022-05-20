import 'dart:developer';

import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/dr_profile_page.dart';
import 'package:laboratoire_app/Service/dr_profile_service.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/widgets/auth_screen.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/error_widget.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:laboratoire_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/buttons_widget.dart';

class TeamDoctPage extends StatefulWidget {
  const TeamDoctPage({Key key}) : super(key: key);

  @override
  _TeamDoctPageState createState() => _TeamDoctPageState();
}

class _TeamDoctPageState extends State<TeamDoctPage> {
  bool isConn = Get.arguments;
  bool _isLoading = false;

  @override
  void initState() {
     
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:  _isLoading
              ? LoadingIndicatorWidget()
              : BottomNavigationWidget(
          title: "Book an appointment",
          route: '/AppoinmentPage',
        ),
        drawer : CustomDrawer(isConn: isConn),
        body: _buildContent());
  }

  Widget _buildContent() {
    return Stack(
      //overflow: Overflow.visible,
      children: <Widget>[

        CAppBarWidget(title: 'Infermiers', isConn: isConn),
        Positioned(
          top: 90,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: IBoxDecoration.upperBoxDecoration(),
            child: Padding(
               
                padding: const EdgeInsets.only(
                  top: 0.0,
                  left: 20,
                  right: 20,
                ),
                child: FutureBuilder(
                    future: DrProfileService.getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.length == 0
                            ? const NoDataWidget()
                            : _buildGridView(snapshot.data);
                      } else if (snapshot.hasError) {
                        return const IErrorWidget();
                      } else {
                        return LoadingIndicatorWidget();
                      }
                    })),
          ),
        ),
      ],
    );
  }

  Widget _buildGridView(doctor) {
    return GridView.count(
      childAspectRatio: .8, //you can change the size of items
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(doctor.length, (index) {
        return _cardImg(doctor[index]);
      }),
    );
  }

  Widget _cardImg(doctorDetails) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: <Widget>[
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
              // color: Colors.yellowAccent,
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              top: 0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // CircleAvatar(
                    //   backgroundColor: Colors.white,
                    //   radius: 35,
                    //   child: ClipOval(
                    //       child: Padding(
                    //           padding: const EdgeInsets.all(00.0),
                    //           child: serviceDetails. == ""
                    //               ? Icon(Icons.category_outlined,
                    //                   color: appBarColor)
                    //               : ImageBoxFillWidget(
                    //                   imageUrl: serviceDetails.imageUrl))),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(doctorDetails.firstName+" "+doctorDetails.lastName,
                          style: const TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 12.0,
                          )),
                    ),
                    // Text(serviceDetails,
                    //     style: const TextStyle(
                    //       fontFamily: 'OpenSans-SemiBold',
                    //       fontSize: 12.0,
                    //     )),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              //bottom: -10,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: 30,
                    child: RoundedBtnWidget(
                      title: "More",
                      onPressed: () {
                        Get.to( () => DoctorProfilePage(id: doctorDetails.id),
                        ); //send to data to the next screen
                      },
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
