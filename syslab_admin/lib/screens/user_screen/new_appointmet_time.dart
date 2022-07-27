import 'package:get/get.dart';
import 'package:syslab_admin/screens/user_screen/register_patient_page.dart';
import 'package:syslab_admin/service/time_calculation.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class NewAppointmentTimePage extends StatefulWidget {
  final String openingTime;
  final String closingTime;
  final String appointmentType;
  final int serviceTimeMin;
  final userDetails;

  const NewAppointmentTimePage(
      {Key key,
      this.openingTime,
      this.closingTime,
      this.appointmentType,
      this.serviceTimeMin,
      this.userDetails})
      : super(key: key);

  @override
  _NewAppointmentTimePageState createState() => _NewAppointmentTimePageState();
}

class _NewAppointmentTimePageState extends State<NewAppointmentTimePage> {
  bool _isLoading = false;
  String _setTime = "";
  String uId = "";
  // ignore: prefer_typing_uninitialized_variables
  var _selectedDate;
  List _bookedTimeSlots;
  final List<dynamic> _morningTimeSlotsList = [];
  final List<dynamic> _afternoonTimeSlotsList = [];
  final List<dynamic> _eveningTimeSlotsList = [];

  String _openingTimeHour = "";
  String _openingTimeMin = "";
  String _closingTimeHour = "";
  String _closingTimeMin = "";

  @override
  void initState() {
    super.initState();
    _getAndSetAllInitialData();
  }

  _getAndSetAllInitialData() async {
    setState(() {
      _isLoading = true;
    });

    _selectedDate = await _initializeDate(); //Initialize start time
    await _getAndSetOpeningClosingTime();
    _getAndsetTimeSlots(
        _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);

    setState(() {
      _isLoading = false;
    });
  }

  _reCallMethodes() async {
    setState(() {
      _isLoading = true;
    });
    _getAndsetTimeSlots(
      _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);
      setState(() {
        _isLoading = false;
      });
  }

  Future<String> _initializeDate() async {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.month}-${dateParse.day}-${dateParse.year}";

    return formattedDate;
  }

  Future<void> _getAndSetOpeningClosingTime() async {
    //break the opening and closing time in to the hour and minute
    _openingTimeHour = (widget.openingTime).substring(0, 2);
    _openingTimeMin = (widget.openingTime).substring(3, 5);
    _closingTimeHour = (widget.closingTime).substring(0, 2);
    _closingTimeMin = (widget.closingTime).substring(3, 5);

  }

  _getAndsetTimeSlots(String openingTimeHour, String openingTimeMin,
      String closingTimeHour, String closingTimeMin) {
    int serviceTime = widget.serviceTimeMin;

    List<String> timeSlots = TimeCalculation.calculateTimeSlots(
        openingTimeHour,
        openingTimeMin,
        closingTimeHour,
        closingTimeMin,
        serviceTime); //calculate all the possible time slots between opening and closing time

    if (_bookedTimeSlots != null) {
      //if any booked time exists on the selected day
      timeSlots = TimeCalculation.reCalculateTimeSlots(
          timeSlots,
          _bookedTimeSlots,
          _selectedDate,
          closingTimeHour,
          closingTimeMin,
          widget.serviceTimeMin); // Recalculate the time according to the booked time slots and date
    }

    _arrangeTimeSlots(
        timeSlots); //separate the time according to morning, afternoon and evening slots
  }

  _arrangeTimeSlots(List timeSlots) {
    _morningTimeSlotsList.clear();
    _afternoonTimeSlotsList.clear();
    _eveningTimeSlotsList.clear();

    for (var element in timeSlots) {
      if (int.parse(element.substring(0, 2)) < 12) {
        _morningTimeSlotsList.add(element);
      }

      if (int.parse(element.substring(0, 2)) >= 12 &&
          int.parse(element.substring(0, 2)) < 17) {
        _afternoonTimeSlotsList.add(element);
      }

      if (int.parse(element.substring(0, 2)) >= 17 &&
          int.parse(element.substring(0, 2)) < 24) {
        _eveningTimeSlotsList.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Choisissez l'heure"),
      bottomNavigationBar: BottomNavBarWidget(
        isEnableBtn: _setTime == "" ? false : true,
        onPressed: () {
          Get.to(() => 
              RegisterPatient(
                userDetails: widget.userDetails,
                appointmentType: widget.appointmentType,
                serviceTimeMin: widget.serviceTimeMin,
                setTime: _setTime,
                selectedDate: _selectedDate,
              ),
          );
        },
        title: "Suivant",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                child: SingleChildScrollView(
                  // controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      _buildCalendar(),
                      const Divider(),
                      _isLoading
                          ? const LoadingIndicatorWidget()
                          : Column(
                                  children: <Widget>[
                                    _morningTimeSlotsList.isEmpty
                                        ? Container()
                                        : const Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0),
                                            child: Text("Créneau horaire du matin",
                                                style: TextStyle(
                                                  fontFamily:
                                                      'OpenSans-SemiBold',
                                                  fontSize: 14,
                                                )),
                                          ),
                                    _morningTimeSlotsList.isEmpty
                                        ? Container()
                                        : _slotsGridView(
                                            _morningTimeSlotsList,
                                            _bookedTimeSlots,
                                            widget.serviceTimeMin),
                                    _afternoonTimeSlotsList.isEmpty
                                        ? Container()
                                        : const Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0),
                                            child: Text("Créneau horaire de l'après-midi",
                                                style: TextStyle(
                                                  fontFamily:
                                                      'OpenSans-SemiBold',
                                                  fontSize: 14,
                                                )),
                                          ),
                                    _afternoonTimeSlotsList.isEmpty
                                        ? Container()
                                        : _slotsGridView(
                                            _afternoonTimeSlotsList,
                                            _bookedTimeSlots,
                                            widget.serviceTimeMin),
                                    _eveningTimeSlotsList.isEmpty
                                        ? Container()
                                        : const Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0),
                                            child: Text("Créneau horaire du soir",
                                                style: TextStyle(
                                                  fontFamily:
                                                      'OpenSans-SemiBold',
                                                  fontSize: 14,
                                                )),
                                          ),
                                    _eveningTimeSlotsList.isEmpty
                                        ? Container()
                                        : _slotsGridView(
                                            _eveningTimeSlotsList,
                                            _bookedTimeSlots,
                                            widget.serviceTimeMin),
                                  ],
                                )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: btnColor,
      selectedTextColor: Colors.white,
      daysCount: 7,
      onDateChange: (date) {
        // New date selected
        setState(() {
          final dateParse = DateTime.parse(date.toString());

          _selectedDate =
              "${dateParse.month}-${dateParse.day}-${dateParse.year}";
          _reCallMethodes();
        });
      },
    );
  }

  Widget _slotsGridView(timeSlotsList, bookedTimeSlot, serviceTimeMin) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: timeSlotsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 1, crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return _timeSlots(timeSlotsList[index], bookedTimeSlot, serviceTimeMin);
      },
    );
  }

  String _setTodayDateFormate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('M-d-yyyy');
    String formatted = formatter.format(now);
    // if(formatted.substring(0,1)=="0") {
    //   formatted=formatted.substring(1,2)+formatter.format(now).substring(2);
    // }
    return formatted;
  }

  Widget _timeSlots(String time, bookedTime, serviceTimeMin) {
    bool _isNoRemainingTime = false;

    final todayDate = _setTodayDateFormate();

    if (_selectedDate == todayDate) {

      if (int.parse(time.substring(0, 2)) < DateTime.now().hour) {
        //true the time is over

        _isNoRemainingTime = true;
      } else if (int.parse(time.substring(0, 2)) == DateTime.now().hour) {
        //false
        if (int.parse(time.substring(3, 5)) <= DateTime.now().minute) {
          _isNoRemainingTime = true;
        }
      }
    }

    var bookedTimeSlots = [];

    if (bookedTime != null) {
      bookedTimeSlots = TimeCalculation.calculateBookedTime(
          time, bookedTime, serviceTimeMin); //get all disabled time
    }

    return GestureDetector(
      onTap: _isNoRemainingTime || bookedTimeSlots.contains(time)
          ? null
          : () {
              setState(() {
                _setTime == time ? _setTime = "" : _setTime = time;
              });
            },
      child: Card(
        color: time == _setTime
            ? btnColor
            : _isNoRemainingTime || bookedTimeSlots.contains(time)
                ? Colors.red
                : Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              time,
              style: TextStyle(
                  color: time == _setTime ? Colors.white : Colors.white),
            ),
          ),
        ),
      ),
    );
  }

}
