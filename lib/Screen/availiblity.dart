import 'package:get/get.dart';
import 'package:laboratoire_app/Service/availablityService.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/errorWidget.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:laboratoire_app/widgets/noDataWidget.dart';
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading
        ? LoadingIndicatorWidget() : 
        BottomNavigationWidget(
        title: "Book an appointment",
        route: "/AppoinmentPage",
      ),
      drawer : CustomDrawer(isConn: isConn),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          
          CAppBarWidget(title: "Availability", isConn : isConn),
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
                          ? NoDataWidget()
                          : _buildContent(snapshot);
                    } else if (snapshot.hasError) {
                      return IErrorWidget();
                    } else {
                      return LoadingIndicatorWidget();
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
            padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Text("We are available on",
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          rowContent("Day", "Time"),
          const Divider(),
          rowContent("Monday", "${day.mon}"),
          const Divider(),
          rowContent("Tuesday", "${day.tue}"),
          const Divider(),
          rowContent("Wednesday", "${day.wed}"),
          const Divider(),
          rowContent("Thursday", "${day.thu}"),
          const Divider(),
          rowContent("Friday", "${day.fri}"),
          const Divider(),
          rowContent("Saturday", "${day.sat}"),
          const Divider(),
          rowContent("Sunday", "${day.sun}"),
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
