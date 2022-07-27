import 'package:get/get.dart';
import 'package:syslab_admin/screens/analyses_page.dart/analyses_page.dart';
import 'package:syslab_admin/screens/categories_screen/edit_categories_page.dart';
import 'package:syslab_admin/service/category_service.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/buttons_widget.dart';
import 'package:syslab_admin/widgets/error_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final bool _isEnableBtn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Examens biologiques"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Ajouter catégories",
          onPressed: () {
            Navigator.pushNamed(context, "/AddCategoriesPage");
          },
          isEnableBtn: _isEnableBtn,
        ),
        body: FutureBuilder(
            future: CategoryService.getData(), //fetch all categories details
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

  Widget buildGridView(categories) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: .8,
        crossAxisCount: 2,
        children: List.generate(categories.length, (index) {
          return cardImg(categories[index]);
        }),
      ),
    );
  }

  Widget cardImg(categoriesDetails) {
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
                      child: Text(categoriesDetails.name,
                          style: const TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 16.0,
                          )),
                    ),
                    Text(categoriesDetails.description,
                        style: const TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 12.0,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: EditBtnWidget(
                  title: "Éditer",
                  onPressed: () {
                    Get.to(() => EditcategoriesPage(
                      categoryDetails: categoriesDetails), //send to data to the next screen
                    );
                  },
                )),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RoundedBtnWidget(
                  title: "Analyses",
                  onPressed: () {
                    Get.to(() => AnalysesPage(catId: categoriesDetails.id));
                  }
                )),
            )
          ],
        ),
      ),
    );
  }
}
