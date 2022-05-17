import 'package:get/get.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {

  final String title;
  
  final String route;
  bool isConn;
  BottomNavigationWidget({Key key, this.title, this.route, this.isConn}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 8.0, bottom: 8.0),
        child: SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: btnColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: Center(
                  child: Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                      ))),
              onPressed: () {
                Get.toNamed(route, arguments: isConn);
              }),
        ),
      ),
    );
  }
}

class BottomNavigationStateWidget extends StatelessWidget {

  final String title;

  final String clickable;

  final onPressed;
  BottomNavigationStateWidget({this.title, this.onPressed, this.clickable});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20, top: 8.0, bottom: 8.0),
          child: SizedBox(
            height: 35,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                child: Center(
                    child: Text(title,
                        style: const TextStyle(
                          color: Colors.white,
                        ))),
                onPressed: clickable == "" ? null : onPressed),
          ),
        ));
  }
}
