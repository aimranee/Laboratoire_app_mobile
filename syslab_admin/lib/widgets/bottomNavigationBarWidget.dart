import 'package:syslab_admin/utilities/colors.dart';
import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final String title;
  final bool isEnableBtn;
  final onPressed;
  const BottomNavBarWidget({ this.title,  this.isEnableBtn, this.onPressed});
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
                  onPressed: isEnableBtn ? onPressed : null),
            )));
  }
}

class BottomNavTwoBarWidget extends StatelessWidget {
  final String firstTitle;
  final bool isenableBtn;
  final firstBtnOnPressed;
  BottomNavTwoBarWidget(
      { this.firstTitle,
      this.firstBtnOnPressed,
       this.isenableBtn});
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
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: btnColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: Center(
                            child: Text(firstTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                ))),
                        onPressed: isenableBtn ? firstBtnOnPressed : null),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            )));
  }
}
