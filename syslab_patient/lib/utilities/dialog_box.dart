import 'package:patient/utilities/color.dart';
import 'package:flutter/material.dart';

class DialogBoxes {
  static Future<String> confirmationBox(
      context, String title, String subTitle, onPressed) {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(title),
          content: Text(subTitle),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: const Text("OK"),
                onPressed: () {
                  onPressed();
                  Navigator.of(context).pop();
                }),
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  static Future<String> stopBookingAlertBox(
      context, String title, String subTitle) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {
            Navigator.popUntil(context, ModalRoute.withName('/HomePage'));
            return null;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(title),
            content: Text(subTitle),
          ),
        );
      },
    );
  }

  static Future<String> technicalIssueAlertBox(
      context, String title, String subTitle) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {
            return null;
            //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(title),
            content: Text(subTitle),
          ),
        );
      },
    );
  }
}
