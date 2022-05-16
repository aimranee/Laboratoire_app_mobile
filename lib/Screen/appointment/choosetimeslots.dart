import 'package:get/get.dart';
import 'package:laboratoire_app/Service/Firebase/readData.dart';
import 'package:laboratoire_app/Service/DateAndTimeCalculation/timeCalculation.dart';
import 'package:laboratoire_app/SetData/screenArg.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class ChooseTimeSlotPage extends StatefulWidget {
  final String openingTime;
  final String closingTime;
  final String serviceName;
  final int serviceTimeMin;
  final String closedDay;
  bool isConn = false;

  ChooseTimeSlotPage(
      {Key key,
      this.openingTime,
      this.closingTime,
      this.serviceName,
      this.serviceTimeMin,
      this.closedDay,
      this.isConn})
      : super(key: key);

  @override
  _ChooseTimeSlotPageState createState() => _ChooseTimeSlotPageState();
}

class _ChooseTimeSlotPageState extends State<ChooseTimeSlotPage> {
  bool _isLoading = false;
  String _setTime = "";
  var _selectedDate;
  var _selectedDay = DateTime.now().weekday;
  List _closingDate = [];
  List _dayCode = [];

  List _bookedTimeSlots;
  final List<dynamic> _morningTimeSlotsList = [];
  final List<dynamic> _afternoonTimeSlotsList = [];
  final List<dynamic> _eveningTimeSlotsList = [];

  String _openingTimeHour = "";
  String _openingTimeMin = "";
  String _closingTimeHour = "";
  String _closingTimeMin = "";
  String _lunchOpeningTimeHour = "";
  String _lunchOpeningTimeMin = "";
  String _lunchClosingTimeHour = "";
  String _lunchClosingTimeMin = "";

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
    await _getAndSetbookedTimeSlots();
    await _getAndSetOpeningClosingTime();
    await _setClosingDate();
    _getAndsetTimeSlots(_openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);
    setState(() {
      _isLoading = false;
    });
  }

  _reCallMethodes() async {
    setState(() {
      _isLoading = true;
    });
    await _getAndSetbookedTimeSlots();
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

  Future<void> _getAndSetbookedTimeSlots() async {
    _bookedTimeSlots = await ReadData.fetchBookedTime(_selectedDate);
  }

  Future<void> _getAndSetOpeningClosingTime() async {
    
    var openingClosingTime = await ReadData.fetchOpeningClosingTime();
  
    _openingTimeHour = (widget.openingTime).substring(0, 2);
    _openingTimeMin = (widget.openingTime).substring(3, 5);
    _closingTimeHour = (widget.closingTime).substring(0, 2);
    _closingTimeMin = (widget.closingTime).substring(3, 5);

    _dayCode = openingClosingTime["dayCode"]; //get and set clinic closing days
    final res = widget.closedDay; //get all closed day for specific appointment
    if (res != "" && res != null) {
      final coledDatArr = (res).split(',');
      for (var element in coledDatArr) {
        _dayCode.add(int.parse(element));
      }
    }
    if (openingClosingTime["lunchOpeningTime"] != "" &&
        openingClosingTime["lunchClosingTime"] != "") {
      _lunchOpeningTimeHour =
          (openingClosingTime["lunchOpeningTime"]).substring(0, 2);
      _lunchOpeningTimeMin =
          (openingClosingTime["lunchOpeningTime"]).substring(3, 5);
      _lunchClosingTimeHour =
          (openingClosingTime["lunchClosingTime"]).substring(0, 2);
      _lunchClosingTimeMin =
          (openingClosingTime["lunchClosingTime"]).substring(3, 5);
    }
    
  }

  _getAndsetTimeSlots(String openingTimeHour, String openingTimeMin,
      String closingTimeHour, String closingTimeMin) {
    int serviceTime = widget.serviceTimeMin;

    List<String> timeSlots = TimeCalculation.calculateTimeSlots(
        openingTimeHour,
        openingTimeMin,
        closingTimeHour,
        closingTimeMin,
        serviceTime
    ); //calculate all the possible time slots between opening and closing time

    //  print("Service Time" + " " + "$serviceTime");
    // print("...................." + "$timeSlots");

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
    // print("+++++++++++++++++++++++++ $timeSlots");

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
        bottomNavigationBar: BottomNavigationStateWidget(
          title: "Next",
          onPressed: () {
            Get.toNamed("/RegisterPatientPage",
                arguments: ChooseTimeScrArg(
                  widget.serviceName,
                  widget.serviceTimeMin,
                  _setTime,
                  _selectedDate,
                ),);
          },
          clickable: _setTime,
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CAppBarWidget(title: "Book an appointment", isConn: widget.isConn),

            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10, right: 10),
                          child: SingleChildScrollView(
                            // controller: _scrollController,
                            child: Column(
                              children: <Widget>[
                                _buildCalendar(),
                                const Divider(),
                                _isLoading
                                    ? LoadingIndicatorWidget()
                                    : _closingDate.contains(_selectedDate) ||
                                            _dayCode.contains(_selectedDay)
                                        ? const Center(
                                            child: Text(
                                            "Sorry! we can't take appointments in this day",
                                            style: TextStyle(
                                              fontFamily: 'OpenSans-SemiBold',
                                              fontSize: 14,
                                            ),
                                          ))
                                        : Column(
                                            children: <Widget>[
                                              _morningTimeSlotsList.isEmpty
                                                  ? Container()
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Text(
                                                          "Morning Time Slot",
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
                                                      padding:
                                                          EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Text(
                                                          "Afternoon Time Slot",
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
                                                      padding:
                                                          EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Text(
                                                          "Evening Time Slot",
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
              ),
            ),
          ],
        ));
  }

  Widget _buildCalendar() {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: appBarColor,
      selectedTextColor: Colors.white,
      daysCount: 7,
      onDateChange: (date) {
        // New date selected
        setState(() {
          final dateParse = DateTime.parse(date.toString());

          _selectedDate =
              "${dateParse.month}-${dateParse.day}-${dateParse.year}";
          _selectedDay = date.weekday;
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

    //print("dddddddddddddddddd ");
    final todayDate = _setTodayDateFormate();
    // print("tooooooooodddddddddddd $todayDate");

    if (_selectedDate == todayDate) {
      // print(DateTime.now().month);
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
    // print(time);
    // print(_isNoRemainingTime);
    if (_openingTimeHour != "" &&
        _closingTimeHour != "" &&
        _openingTimeMin != "" &&
        _closingTimeMin != "") {
      if (int.parse(time.substring(0, 2)) > int.parse(_lunchOpeningTimeHour) &&
          int.parse(time.substring(0, 2)) < int.parse(_lunchClosingTimeHour)) {
        //true the time is over

        _isNoRemainingTime = true;
      } else if (int.parse(time.substring(0, 2)) ==
          int.parse(_lunchOpeningTimeHour)) {
        if (int.parse(time.substring(3, 5)) >= int.parse(_lunchOpeningTimeMin)) {
          _isNoRemainingTime = true;
        }
      } else if (int.parse(time.substring(0, 2)) ==
          int.parse(_lunchClosingTimeHour)) {
        if (int.parse(time.substring(3, 5)) <= int.parse(_lunchClosingTimeMin)) {
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

  _setClosingDate() async {
    final res = await ReadData.fetchSettings();
    if (res != null) {
      setState(() {
        _closingDate = res["closingDate"];
      });
    }
  }
}
