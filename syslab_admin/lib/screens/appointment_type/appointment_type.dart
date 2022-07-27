import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/Service/appointment_type_service.dart';
import 'package:syslab_admin/screens/appointment_type/edit_appointment_type.dart';
import 'package:syslab_admin/widgets/buttons_widget.dart';
import 'package:syslab_admin/widgets/error_widget.dart';
import 'package:syslab_admin/widgets/image_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';

class AppointmentTypesPage extends StatefulWidget {
  const AppointmentTypesPage({Key key}) : super(key: key);

  @override
  _AppointmentTypesPageState createState() => _AppointmentTypesPageState();
}

class _AppointmentTypesPageState extends State<AppointmentTypesPage> {
  final bool _isenableBtn = true;
  bool _isLoading = false;
  String _disableStartTime;
  String _disableEndTime;
  String uId = "";

  @override
  void initState() {
    // TODO: implement initState
    // getUId();
    _getAndSetTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Types de rendez-vous"),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : FutureBuilder(
                future: AppointmentTypeService.getData(),
                //fetch all appointment types
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.length == 0
                        ? NoDataWidget()
                        : buildGridView(snapshot.data);
                  } else if (snapshot.hasError) {
                    return IErrorWidget();
                  } else {
                    return LoadingIndicatorWidget();
                  }
                }
            )
        );
  }

  Widget buildGridView(appointmentTypesDetails) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8, bottom: 8),
      child: GridView.count(
        childAspectRatio: .9,
        crossAxisCount: 2,
        children: List.generate(appointmentTypesDetails.length, (index) {
          return _cardImg(appointmentTypesDetails[index]);
        }),
      ),
    );
  }

  Widget _cardImg(appointmentTypesDetails) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Card(
                //color: Colors.red,
                // color: Colors.yellowAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10.0,
              ),
              // color: Colors.yellowAccent,
            ),
            Positioned(
              top: 1,
              left: 4,
              right: 4,
              bottom: 50,
              child: SizedBox(
                  // height:double.infinity,
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.all(00.0),
                      child: appointmentTypesDetails.imageUrl == ""
                          ? const Icon(
                              Icons.category_outlined,
                              color: primaryColor,
                            )
                          : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: ImageBoxFillWidget(
                                  imageUrl: appointmentTypesDetails.imageUrl)
                              //get image
                              ))),
            ),
            Positioned.fill(
              left: 0,
              right: 0,
              bottom: 30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(appointmentTypesDetails.title,
                    style: const TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 12.0,
                    )),
              ),
            ),
            Positioned(
                top: 0, //you can change the position of edit button
                left: 0,
                child: _editBtn(appointmentTypesDetails)),
          ],
        ),
      ),
    );
  }

  Widget _editBtn(appointmentTypesDetails) {
    return EditBtnWidget(
      title: "Éditer",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditAppointmentTypes(
              disableStartTime: _disableStartTime,
              disableEndTime: _disableEndTime,
              appointmentTypesDetails: appointmentTypesDetails,
            ),
          ),
        );
      },
    );
  }

  void _getAndSetTime() async {
    // log("ssssssss");
    setState(() {
      _isLoading = true;
    });
    
    final res = await AppointmentTypeService.getData();
    setState(() {
      
      _disableStartTime = res[0].openingTime;
      _disableEndTime = res[0].closingTime;
      _isLoading = false;
    });
  }
}
