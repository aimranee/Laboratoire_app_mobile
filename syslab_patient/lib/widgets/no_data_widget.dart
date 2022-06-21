import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key key}) : super(key: key);

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
            width: 250,
            child:
            //Container(color: Colors.red,)
            SvgPicture.asset(
                "assets/icon/nodata.svg",
                semanticsLabel: 'Acme Logo'
            ),
          ),
          const SizedBox(height: 20),
          const Text("No Data Found!",style: TextStyle(
            fontFamily: 'OpenSans-SemiBold',
            fontSize: 14,
          )),
        ],
      ),
    );
  }
}

class NoBookingWidget extends StatelessWidget {
  const NoBookingWidget({Key key}) : super(key: key);

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
            width: 250,
            child:
            //Container(color: Colors.red,)
            SvgPicture.asset(
                "assets/icon/booking.svg",
                semanticsLabel: 'Acme Logo'
            ),
          ),
          const SizedBox(height: 0),
          const Padding(
            padding: EdgeInsets.only(left:20.0,right:20.0),
            child: Text("Il n'y a pas de rendez-vous trouvé ! veuillez appuyer sur le bouton Prendre un rendez-vous et prendre un nouveau rendez-vous",style: TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              fontSize: 14,
            )),
          ),
        ],
      ),
    );
  }
}
