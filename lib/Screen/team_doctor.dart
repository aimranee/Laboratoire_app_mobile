import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/more_service.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/error_widget.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:laboratoire_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/Service/service_service.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/buttons_widget.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool isConn = Get.arguments;
  final bool _isLoading = false;

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

        CAppBarWidget(title: 'Service', isConn: isConn),
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
                    future: ServiceService.getData(),
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
                    })),
          ),
        ),
      ],
    );
  }

  Widget _buildGridView(service) {
    return GridView.count(
      childAspectRatio: .8, //you can change the size of items
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(service.length, (index) {
        return _cardImg(service[index]);
      }),
    );
  }

  Widget _cardImg(serviceDetails) {
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
                      child: Text(serviceDetails.title,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreServiceScreen(
                                serviceDetails:
                                    serviceDetails), //send to data to the next screen
                          ),
                        );
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
