import 'package:get/get.dart';
import 'package:syslab_admin/screens/appointments/edit_appointment_details_page.dart';
import 'package:syslab_admin/service/appointment_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/boxWidget.dart';
import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:syslab_admin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';

class SearchAppointmentByCINPage extends StatefulWidget {
  const SearchAppointmentByCINPage({Key key}) : super(key: key);

  @override
  _SearchAppointmentByCINPageState createState() =>
      _SearchAppointmentByCINPageState();
}

class _SearchAppointmentByCINPageState
    extends State<SearchAppointmentByCINPage> {
  final bool _isEnableBtn = true;
  bool _isLoading = false;
  bool _isSearchedBefore = false;
  List appointmentDetails = [];
  final TextEditingController _searchByCINController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose

    _searchByCINController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: SearchBoxWidget(
            controller: _searchByCINController,
            hintText: "Rechercher un patient CIN",
            validatorText: "Saisissez le CIN",
          ),
          actions: [
            SearchBtnWidget(
              onPressed: _handleSearchBtn,
              isEnableBtn: _isEnableBtn,
            )
          ],
        ),
        //Appbars.commonAppBar(context, "Appointments"),
        body: Container(child: cardListBuilder()));
  }

  _handleSearchBtn() async {
    String searchByCIN = _searchByCINController.text;
//lowercase all letter and remove all space
    if (searchByCIN != "") {
      setState(() {
        _isLoading = true;
        _isSearchedBefore = true;
      });

      final res = await AppointmentService.getAppointmentByCIN(searchByCIN);

      setState(() {
        appointmentDetails = res;
        _isLoading = false;
      });
    }
  }

  Widget cardListBuilder() {
    return ListView(
      children: [
        // _buildSearchBoxContainer(),
        !_isSearchedBefore
            ? Container()
            : _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingIndicatorWidget(),
                  )
                : appointmentDetails.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: appointmentDetails.length,
                        itemBuilder: (context, index) {
                          return patientDetailsCard(
                              appointmentDetails[index]);
                        },
                      )
                    : NoDataWidget(),
      ],
    );
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
                      "${_subTitleWithSpace("Id de Rendez-vous:")}${appointmentDetails.id}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Date de Rendez-vous:")}${appointmentDetails.appointmentDate}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Temps de Rendez-vous:")}${appointmentDetails.appointmentTime}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Type de Rendez-vous:")}${appointmentDetails.appointmentType}"),
                ),
                if(appointmentDetails.location != "")
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Emplacement:")}${appointmentDetails.location}"),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("CIN:")}${appointmentDetails.cin}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text("${_subTitleWithSpace("Statut du rendez-vous:")} "),
                      if (appointmentDetails.appointmentStatus == 
                          "Confirmed")
                        _statusIndicator(Colors.green)
                      else if (appointmentDetails.appointmentStatus ==
                          "Pending")
                        _statusIndicator(Colors.yellowAccent)
                      else if (appointmentDetails.appointmentStatus ==
                          "Rejected")
                        _statusIndicator(Colors.red)
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
  String _subTitleWithSpace(String subTitle) {
    String string = subTitle;

    for (int i = 0; i < 24 - subTitle.length; i++) {
      string = string + "  ";
    }
    return string;
  }
  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }

  Widget editBtn(appointmentDetails) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () {
              Get.to(
                 () => EditAppointmentDetailsPage(
                    appointmentDetails: appointmentDetails),
            );
          },
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
