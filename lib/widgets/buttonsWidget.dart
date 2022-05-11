// import 'package:laboratoire_app/Screen/Login_SignUp.dart';
// import 'package:laboratoire_app/Screen/login.dart';
import 'package:laboratoire_app/Screen/Login_SignUp.dart';
import 'package:laboratoire_app/service/authService/authService.dart';
import 'package:laboratoire_app/utilities/colors.dart';
import 'package:flutter/material.dart';

class LoginButtonsWidget extends StatelessWidget {
  @required
  final String title;
  @required
  final onPressed;
  LoginButtonsWidget({this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(60, 16, 60, 0),
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
  @required
  final String title;
  MoreButtonsWidget({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: ElevatedButton(
        onPressed: () {},
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
  @required
  final String title;
  @required
  final onPressed;

  EditBtnWidget({this.title, this.onPressed});
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
            style: TextStyle(color: primaryColor, fontSize: 12),
          )),
    );
  }
}

class EditIconBtnWidget extends StatelessWidget {
  @required
  final onTap;
  EditIconBtnWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
              radius: 15.0,
              backgroundColor: btnColor,
              // foregroundColor: Colors.green,
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              )),
        ));
  }
}

class DeleteButtonWidget extends StatelessWidget {
  @required
  final String title;
  @required
  final onPressed;
  DeleteButtonWidget({this.onPressed, this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        8,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RoundedBtnWidget extends StatelessWidget {
  @required
  final String title;
  @required
  final onPressed;
  RoundedBtnWidget({this.onPressed, this.title});
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
            }),
        const Text(
          "LogOut",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

class SignInBtnWidget extends StatelessWidget {
  const SignInBtnWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            icon: const Icon(
              Icons.login,
              color: Colors.white,
            ),
            onPressed: () {
              LoginSignupScreen(back : true);
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
  @required
  final isEnableBtn;
  @required
  final onPressed;
  SearchBtnWidget({this.isEnableBtn, this.onPressed});
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
