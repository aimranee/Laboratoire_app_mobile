import 'package:syslab_admin/utilities/colors.dart';
import 'package:flutter/material.dart';

class DialogBoxes {
  static Future confirmationBox(
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

  static Future deleteConfirmationBox(context, onPressed) {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text("Delete"),
          content: const Text("Are you sure want to delete"),
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
}
