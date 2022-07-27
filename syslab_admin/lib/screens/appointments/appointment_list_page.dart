import 'dart:developer';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syslab_admin/screens/appointments/edit_appointment_details_page.dart';
import 'package:syslab_admin/service/appointment_service.dart';
import 'package:syslab_admin/service/appointment_type_service.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/buttons_widget.dart';
import 'package:syslab_admin/widgets/error_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/font_style.dart';
// import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:intl/intl.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({Key key}) : super(key: key);

  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final DateRangePickerController _datePickerController = DateRangePickerController();
  final bool _isEnableBtn = true;
  int limit = 20;
  int itemLength = 0;
  bool isMoreData = false;
  final List<String> _appointmentTypes = [];
  final List<String> _selectedTypes = [];
  final List<String> _allStatus = [
    "Pending",
    "Rejected",
    "Confirmed",
    "Visited",
    "Canceled"
  ];
  String _firstDate = "All";
  String _lastDate = "All";
  final List<String> _selectedStatus = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _scrollListener();
    _getSetData();

    super.initState();
  }

  _getSetData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await AppointmentTypeService.getData();
    for (var type in res) {
      setState(() {
        _appointmentTypes.add(type.title);
      });
    }
    setState(() {
      _selectedTypes.addAll(_appointmentTypes);
      _selectedStatus.addAll(_allStatus);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _filteredAppBar(context, "Appointment"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          title: "Rechercher par CIN",
          onPressed: _handleByNameBtn,
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
              icon: const Icon(Icons.filter_alt_sharp),
              onPressed: showDialogBox,
            ),
            backgroundColor: btnColor,
            onPressed: () {}),
        body: _isLoading
            ? const LoadingIndicatorWidget()
            : Container(child: cardListBuilder()));
  }

  _handleByNameBtn() {
    Get.toNamed("/SearchAppointmentByCINPage");
  }

  Widget _filteredAppBar(context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        title,
        style: kAppBarTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: appBarColor,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: const Icon(Icons.date_range), onPressed: _openDialogForDate)),
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: const Icon(Icons.merge_type_sharp),
                onPressed: showDialogBoxByType))
      ],
    );
  }

  Widget cardListBuilder() {
    return FutureBuilder(
        future: AppointmentService.getData(
            _selectedStatus,
            _selectedTypes,
            _firstDate,
            _lastDate,
            limit), // a previously-obtained Future<String> or null
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0){
              return const NoDataWidget();
            
            } else {
              itemLength = snapshot.data.length;
              return ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return patientDetailsCard(snapshot.data[index]);
                },
              );
            }
          }
          else if (snapshot.hasError) {
            return const IErrorWidget();
          } else {
            return const LoadingIndicatorWidget();
          }
        });
  }

  showDialogBox() {
    List<String> newStatus = [];
    newStatus.addAll(_selectedStatus);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text("Choose a status"),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _allStatus.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        activeColor: primaryColor,
                        title: Text(_allStatus[index]),
                        value: newStatus.contains(_allStatus[index]),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue) {
                              newStatus.add(_allStatus[index]);
                            } else {
                              newStatus.remove(_allStatus[index]);
                            }
                          });
                        });
                  }),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: const Text("OK"),
                  onPressed: () {
                    _handleStatus(newStatus);
                    Navigator.pop(context);
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  showDialogBoxByType() {
    List<String> newStatus = [];
    newStatus.addAll(_selectedTypes);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text("Choisissez un type"),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _appointmentTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        activeColor: primaryColor,
                        title: Text(_appointmentTypes[index]),
                        value: newStatus.contains(_appointmentTypes[index]),
                        onChanged: (newValue) {
                          setState(() {
                            if (!newStatus.contains(_appointmentTypes[index])) {
                              newStatus.add(_appointmentTypes[index]);
                            } else {
                              newStatus.remove(_appointmentTypes[index]);
                            }
                            log("${newStatus.length}");
                          });
                        });
                  }),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: const Text("OK"),
                  onPressed: () {
                    _handleTypes(newStatus);
                    Navigator.pop(context);
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  _handleTypes(newStatus) {
    if (newStatus.length == 0) {
      ToastMsg.showToastMsg("veuillez sélectionner au moins un");
    } else if (newStatus.length > 0) {
      _selectedTypes.clear();
      setState(() {
        _selectedTypes.addAll(newStatus);
      });
    }
  }

  _handleStatus(newStatus) {
    if (newStatus.length == 0) {
      ToastMsg.showToastMsg("Veuillez sélectionner au moins un");
    } else if (newStatus.length > 0) {
      _selectedStatus.clear();
      setState(() {
        _selectedStatus.addAll(newStatus);
      });
    }
  }

  String _subTitleWithSpace(String subTitle) {
    String string = subTitle;

    for (int i = 0; i < 24 - subTitle.length; i++) {
      string = string + "  ";
    }
    return string;
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
                      if (appointmentDetails.appointmentStatus == "Confirmed")
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

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }

  Widget editBtn(appointmentDetails) {
    return EditIconBtnWidget(
      onTap: () {
        Get.to(() => EditAppointmentDetailsPage(
                appointmentDetails: appointmentDetails),
        );
      },
    );
  }

  void _dateRangePicker() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child :
          SfDateRangePicker(
            view: DateRangePickerView.month,
            monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 6),
            selectionMode: DateRangePickerSelectionMode.range,
            //onSelectionChanged: _onSelectionChanged,
            showActionButtons: true,
            controller: _datePickerController,
            onSubmit: (Object val) {
              // log(val.toString());
              if (val is PickerDateRange) {
                // log("message"+val.startDate.toString());
                setState(() {
                  _firstDate = _setTodayDateFormat(val.startDate);
                  _lastDate = _setTodayDateFormat(val.endDate);
                });
              }
              Navigator.pop(context);
            },
            onCancel: () {
              _datePickerController.selectedRanges = null;
              Navigator.pop(context);
            },
          ))
        );
      },
    );
  }

  String _setTodayDateFormat(date) {
    final DateFormat formatter = DateFormat('M-d-yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  _openDialogForDate() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text("Choose"),
          content: const Text(
              "Appuyez sur Tout pour obtenir le rendez-vous de toutes les dates\n\nAppuyez sur Date pour choisir une plage de dates"),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: const Text("Tous", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  setState(() {
                    _firstDate = "All";
                    _lastDate = "All";
                  });
                  Navigator.pop(context);
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: const Text(
                  "Date",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // onPressed();
                  
                  Navigator.pop(context);
                  _dateRangePicker();
                })
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      // print("length" $itemLength $limit");
      if (itemLength >= limit) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            limit += 20;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }
}
