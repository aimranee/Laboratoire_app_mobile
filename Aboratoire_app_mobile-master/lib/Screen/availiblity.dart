import 'package:get/get.dart';
import 'package:laboratoire_app/Service/availablity_service.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/error_widget.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:laboratoire_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({Key key}) : super(key: key);

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  bool isConn = Get.arguments;
  final bool _isLoading = false;
  @override
  void initState() {
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading
        ? const LoadingIndicatorWidget() : 
        BottomNavigationWidget(
        title: "Demander Rendez-vous",
        route: "/AppoinmentPage",
        isConn: isConn,
      ),
      drawer : CustomDrawer(isConn: isConn),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          
          CAppBarWidget(title: "Disponibilité", isConn : isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: IBoxDecoration.upperBoxDecoration(),
              child: 
              FutureBuilder(
                  future:
                      AvailabilityService.getAvailability(), //fetch all times
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.length == 0
                          ? const NoDataWidget()
                          : _buildContent(snapshot);
                    } else if (snapshot.hasError) {
                      return const IErrorWidget();
                    } else {
                      return const LoadingIndicatorWidget();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(top: 25.0, left: 20, right: 20),
            child: Text("Nous sommes disponibles sur",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans-Bold',
                  fontSize: 15.0,
                ))),
        Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: buildTable(snapshot.data[0])),
      ],
    );
  }

  Widget buildTable(day) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
      child: Column(
        children: [
          rowContent("Jour", "Temps"),
          const Divider(),
          rowContent("Lundi", "${day.mon}"),
          const Divider(),
          rowContent("Mardi", "${day.tue}"),
          const Divider(),
          rowContent("Mercredi", "${day.wed}"),
          const Divider(),
          rowContent("Jeudi", "${day.thu}"),
          const Divider(),
          rowContent("Vendredi", "${day.fri}"),
          const Divider(),
          rowContent("Samedi", "${day.sat}"),
          const Divider(),
          rowContent("Dimanche", "${day.sun}"),
          const Divider(),
        ],
      ),
    );
  }

  Widget rowContent(String first, String last) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(first,
            style: const TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              fontSize: 14.0,
            )),
        Text(
          last,
          style: const TextStyle(
            fontFamily: 'OpenSans-SemiBold',
            fontSize: 14.0,
          ),
        )
      ],
    );
  }
}
