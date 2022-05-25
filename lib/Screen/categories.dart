import 'package:get/get.dart';
import 'package:laboratoire_app/Screen/analyses.dart';
import 'package:laboratoire_app/Service/category_service.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/auth_screen.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/error_widget.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:laboratoire_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key key}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
 final ScrollController _scrollController = ScrollController();
 bool _isLoading = false;
 bool isConn = false;
  @override
  void initState() {
    _TestConnection();
    super.initState();
  }

  _TestConnection() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _isLoading = true;
  });
  if (prefs.getString("fcm") != ""){
    setState(() {
      isConn = true;
    });
  }
  setState(() {
    _isLoading = false;
  });
}

 @override
  void dispose() {
   _scrollController.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading
        ? LoadingIndicatorWidget() : 
        BottomNavigationWidget(
        title: "Book an appointment",
        route: "/AppoinmentPage",
      ),
      drawer : CustomDrawer(isConn: isConn),
      body: _isLoading ? LoadingIndicatorWidget() : Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title:"Branches Biologiques", isConn: isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration:IBoxDecoration.upperBoxDecoration(),
              child:FutureBuilder(
                  future: CategoryService.getData(),
                  //ReadData.fetchNotification(FirebaseAuth.instance.currentUser.uid),//fetch all times
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.length == 0
                          ? const NoDataWidget()
                          : Padding(
                          padding: const EdgeInsets.only(top: 0.0, left: 8, right: 8),
                          child: _buildCard(snapshot.data));
                    } else if (snapshot.hasError) {
                      return const IErrorWidget();
                    } else {
                      return LoadingIndicatorWidget();
                    }
                  }
                ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCard(catDetails) {
    // _itemLength=notificationDetails.length;
    return ListView.builder(
        controller: _scrollController,
        itemCount: catDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => AnalysesPage(
                      title: catDetails[index].name,
                      id: catDetails[index].id
                    ),arguments: isConn
              );

            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: Text(
                      catDetails[index].name,
                      style: const TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 14.0,
                      )),
                        trailing: const Icon(Icons.arrow_forward_ios,color: iconsColor,size: 20,),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${catDetails[index].description}",
                          style: const TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }

}
