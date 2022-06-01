import 'package:get/get.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReachUS extends StatefulWidget {
  const ReachUS({Key key}) : super(key: key);

  @override
  _ReachUSState createState() => _ReachUSState();
}

class _ReachUSState extends State<ReachUS> {
  bool isConn = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer : CustomDrawer(isConn: isConn),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title: "Nous joindre", isConn: isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: IBoxDecoration.upperBoxDecoration(),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    // child: Container(
                    //     color: Colors.grey,
                    //     child: Center(child: Text("Your asset"))),
                    //delete the just above code [ child container ] and uncomment the below code and set your assets
                    child: Image.asset(
                      'assets/images/map3.png',
                      fit: BoxFit.cover,
                    ))),
          ),
          Positioned(
            bottom: -4,
            left: 5,
            right: 5,
            child: SizedBox(
                height: 110,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "We are here...",
                          style: kPageTitleStyle,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Positioned(
            right: 25,
            bottom: 30,
            child: GestureDetector(
              onTap: () async {
                const latitude = "30.4029593"; // laboratoire latitude from google map
                const longitude = "-9.5298985"; // laboratoire longitude from google map
                const _url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                await canLaunch(_url)
                    ? await launch(_url)
                    : throw 'Could not launch $_url'; //launch google map
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: btnColor,
                child: Icon(
                  Icons.near_me,
                  color: appBarIconColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
