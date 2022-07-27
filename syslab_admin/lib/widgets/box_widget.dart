import 'package:flutter_svg/flutter_svg.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:flutter/material.dart';

class CircularUserImageWidget extends StatelessWidget {
  @required
  final userList;
  const CircularUserImageWidget({Key key, this.userList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: ClipOval(
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: SvgPicture.asset(
            "assets/icons/patient.svg", 
            semanticsLabel: 'Acme Logo'
          ),
        )
      )
    );
  }
}

class SearchBoxWidget extends StatelessWidget {
  final controller;
  final hintText;
  final validatorText;
  const SearchBoxWidget({Key key, this.controller, this.hintText, this.validatorText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: TextFormField(
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        controller: controller,
        validator: (item) {
          return item.isNotEmpty ? null : validatorText;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white),
            hoverColor: Colors.red,
            fillColor: Colors.orangeAccent,

            // prefixIcon:Icon(Icons.,),
            //   labelText: "Full Name",
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: appBarColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: appBarColor, width: 1.0),
            )),
      ),
    );
  }
}
