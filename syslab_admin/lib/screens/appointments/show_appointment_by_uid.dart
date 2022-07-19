// import 'package:syslab_admin/screens/appointment/editAppointmetDetailsPage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/screens/appointments/edit_appointment_details_page.dart';
import 'package:syslab_admin/service/appointment_service.dart';
import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:syslab_admin/widgets/errorWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:syslab_admin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';

class ShowAppointmentByUidPage extends StatefulWidget {
  final userId;

  const ShowAppointmentByUidPage({Key key, this.userId}) : super(key: key);
  @override
  _ShowAppointmentByUidPageState createState() =>
      _ShowAppointmentByUidPageState();
}

class _ShowAppointmentByUidPageState extends State<ShowAppointmentByUidPage> {
  String uId = "";
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Tous les rendez-vous"),
        body: Container(child: cardListBuilder()));
  }

  Widget cardListBuilder() {
    return FutureBuilder(
        future: AppointmentService.getAppointmentByUser(widget.userId), // a previously-obtained Future<String> or null
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0
                ? NoDataWidget()
                : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return patientDetailsCard(snapshot.data[index]);
                    },
                  );
          } else if (snapshot.hasError) {
            return IErrorWidget();
          } else {
            return LoadingIndicatorWidget();
          }
        });
  }

  Widget patientDetailsCard(appointmentDetails) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ListTile(
            isThreeLine: true,
            title: Text(
              "${appointmentDetails.uName}",
              style: kCardTitleStyle,
            ),
            trailing: editBtn(appointmentDetails),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 8.0), child: Divider()),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Date de rendez-vous:        ${appointmentDetails.appointmentDate}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Heure de rendez-vous:       ${appointmentDetails.appointmentTime}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Type de rendez-vous:        ${appointmentDetails.appointmentType}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "CIN de patient:                    ${appointmentDetails.cin}"),
                ),
                if(appointmentDetails.location.toString() != "null")
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Emplacement:     ${appointmentDetails.location}"),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Text("Appointment Status:     "),
                      if (appointmentDetails.appointmentStatus == "Confirmed")
                        _statusIndicator(Colors.green)
                      else if (appointmentDetails.appointmentStatus ==
                          "Pending")
                        _statusIndicator(Colors.yellowAccent)
                      else if (appointmentDetails.appointmentStatus ==
                          "Rejected")
                        _statusIndicator(Colors.red)
                      else if (appointmentDetails.appointmentStatus ==
                          "Rescheduled")
                        _statusIndicator(Colors.orangeAccent)
                      else
                        Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("${appointmentDetails.appointmentStatus}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }

  Widget editBtn(appointmentDetails) {
    return EditIconBtnWidget(
      onTap: () {
        Get.to(()=> EditAppointmentDetailsPage(
            appointmentDetails: appointmentDetails));
      },
    );
  }
}
