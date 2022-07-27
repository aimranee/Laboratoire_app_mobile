import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class IErrorWidget extends StatelessWidget {
  const IErrorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 300,
            child:
            //Container(color: Colors.red,)
            SvgPicture.asset(
                "assets/icons/error.svg",
                semanticsLabel: 'Acme Logo'
            ),
          ),
          const SizedBox(height: 20),
          const Text("Désolé c'est une erreur!",style: TextStyle(
            fontFamily: 'OpenSans-SemiBold',
            fontSize: 14,
          )),
        ],
      ),
    );
  }
}
