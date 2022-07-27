import 'package:get/get.dart';
import 'package:syslab_admin/screens/login_page.dart';
import 'package:syslab_admin/service/authService/auth_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:flutter/material.dart';

class LoginButtonsWidget extends StatelessWidget {

  final String title;

  final onPressed;
  const LoginButtonsWidget({Key key,  this.title, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: Center(
                child: Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                    ))),
            onPressed: onPressed));
  }
}

class MoreButtonsWidget extends StatelessWidget {

  final String title;
  final onPressed;
  const MoreButtonsWidget({Key key, this.onPressed, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: btnColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class EditBtnWidget extends StatelessWidget {

  final String title;

  final onPressed;

  const EditBtnWidget({ this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(color: primaryColor, fontSize: 12),
          )),
    );
  }
}

class EditIconBtnWidget extends StatelessWidget {

  final onTap;
  const EditIconBtnWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: onTap,
          child: const CircleAvatar(
              radius: 15.0,
              backgroundColor: btnColor,
              // foregroundColor: Colors.green,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              )),
        ));
  }
}

class RoundedBtnWidget extends StatelessWidget {

  final String title;

  final onPressed;
  const RoundedBtnWidget({Key key, this.onPressed,  this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: btnColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class SignOutBtnWidget extends StatelessWidget {
  const SignOutBtnWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              AuthService.signOut();
              Get.to( () => const LoginPage());
            }),
        const Text(
          "LogOut",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

class SearchBtnWidget extends StatelessWidget {

  final isEnableBtn;

  final onPressed;
  const SearchBtnWidget({this.isEnableBtn, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: primaryColor,
      radius: 20,
      child: IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: isEnableBtn ? onPressed : null,
      ),
    );
  }
}
