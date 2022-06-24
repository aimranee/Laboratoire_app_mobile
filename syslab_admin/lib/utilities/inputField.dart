import 'package:syslab_admin/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputFields {
  static Widget commonInputField(
      controller, labelText, validator, keyboardType, maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }

  static Widget readableInputField(controller, labelText, maxLine) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLine,
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }
}
