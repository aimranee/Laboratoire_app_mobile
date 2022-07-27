import 'dart:developer';

import 'package:get/get.dart';
import 'package:syslab_admin/screens/analyses_page.dart/add_analyses.dart';
import 'package:syslab_admin/screens/analyses_page.dart/edit_analyses_page.dart';
import 'package:syslab_admin/screens/analyses_page.dart/show_analyse_page.dart';
import 'package:syslab_admin/service/analyses_service.dart';
import 'package:syslab_admin/service/category_service.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/buttons_widget.dart';
import 'package:syslab_admin/widgets/error_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';

class AnalysesPage extends StatefulWidget {
  final String catId;
  const AnalysesPage({this.catId, Key key}) : super(key: key);

  @override
  _AnalysesPageState createState() => _AnalysesPageState();
}

class _AnalysesPageState extends State<AnalysesPage> {
  final bool _isEnableBtn = true;
  String catId="";
  String catName ="";
  @override
  void initState() {
    getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Liste analyses"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Ajouter analyse",
          onPressed: () {
            Get.to(()=> AddAnalysePage(catId: catId, catName: catName));
          },
          isEnableBtn: _isEnableBtn,
        ),
        body: FutureBuilder(
            future: AnalysesService.getDataId(widget.catId), //fetch all service details
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.length == 0
                    ? NoDataWidget()
                    : buildGridView(snapshot.data);
              } else if (snapshot.hasError) {
                return IErrorWidget();
              } else {
                return LoadingIndicatorWidget();
              }
            }));
  }

  Widget buildGridView(analyses) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: .8,
        crossAxisCount: 2,
        children: List.generate(analyses.length, (index) {
          return cardImg(analyses[index]);
        }),
      ),
    );
  }

  Widget cardImg(analysesDetails) {
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
                // color: Colors.red,
                // color: Colors.yellowAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(analysesDetails.name,
                          style: const TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 16.0,
                          )),
                    ),
                    // Text(analysesDetails.subTitle,
                    //     style: const TextStyle(
                    //       fontFamily: 'OpenSans-SemiBold',
                    //       fontSize: 12.0,
                    //     )),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: EditBtnWidget(
                  title: "Edit",
                  onPressed: () {
                    Get.to(() => EditAnalysesPage(analysesDetails: analysesDetails), //send to data to the next screen
                    );
                  },
                )),
            Positioned.fill(
              //bottom: -10,

              child: Align(
                alignment: Alignment.bottomCenter,
                child: MoreButtonsWidget(title: "Plus", onPressed: (){
                  Get.to(()=>ShowAnalyseScreen(analysesDetails : analysesDetails));
                },),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCategories() async {
    final res = await CategoryService.getDataById(widget.catId);
    setState(() {
        catId = res[0].id;
        catName = res[0].name;
      });
  }
}
