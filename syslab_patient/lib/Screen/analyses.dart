import 'package:get/get.dart';
import 'package:patient/utilities/decoration.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/error_widget.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:patient/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:patient/Service/analyses_service.dart';
import 'package:patient/Screen/more_service.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/buttons_widget.dart';

// ignore: must_be_immutable
class AnalysesPage extends StatefulWidget {
  String id;
  String title;
  AnalysesPage({Key key, this.title, this.id}) : super(key: key);

  @override
  _AnalysesPageState createState() => _AnalysesPageState();
}

class _AnalysesPageState extends State<AnalysesPage> {
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
              ? const LoadingIndicatorWidget()
              : BottomNavigationWidget(
          title: "Demander Rendez-vous",
          route: '/AppoinmentPage',
          isConn: isConn,
        ),
        drawer : CustomDrawer(isConn: isConn),
        body: _buildContent());
  }

  Widget _buildContent() {
    return Stack(
      //overflow: Overflow.visible,
      children: <Widget>[

        CAppBarWidget(title: widget.title, isConn: isConn),
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
                    future: AnalysesService.getDataId(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.length == 0
                            ? const NoDataWidget()
                            : _buildGridView(snapshot.data);
                      } else if (snapshot.hasError) {
                        return const IErrorWidget();
                      } else {
                        return const LoadingIndicatorWidget();
                      }
                    }
                  )
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridView(analyses) {
    return GridView.count(
      childAspectRatio: .8, //you can change the size of items
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(analyses.length, (index) {
        return _cardImg(analyses[index]);
      }),
    );
  }

  Widget _cardImg(analysesDetails) {
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
                    //           child: analysesDetails. == ""
                    //               ? Icon(Icons.category_outlined,
                    //                   color: appBarColor)
                    //               : ImageBoxFillWidget(
                    //                   imageUrl: analysesDetails.imageUrl))),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(analysesDetails.name,
                          style: const TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 16.0,
                          )),
                    ),
                    // Text(analysesDetails,
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
                      title: "Plus",
                      onPressed: () {
                        Get.to(() => MoreServiceScreen(analysesDetails: analysesDetails), //send to data to the next screen
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
