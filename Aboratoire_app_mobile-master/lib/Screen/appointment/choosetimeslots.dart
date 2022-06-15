import 'package:get/get.dart';
import 'package:laboratoire_app/Service/DateAndTimeCalculation/time_calculation.dart';
import 'package:laboratoire_app/SetData/screen_arg.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChooseTimeSlotPage extends StatefulWidget {
  final String openingTime;
  final String closingTime;
  final String appointmentType;
  final int serviceTimeMin;
  bool isConn = false;

  ChooseTimeSlotPage(
      {Key key,
      this.openingTime,
      this.closingTime,
      this.appointmentType,
      this.serviceTimeMin,
      this.isConn})
      : super(key: key);

  @override
  _ChooseTimeSlotPageState createState() => _ChooseTimeSlotPageState();
}

class _ChooseTimeSlotPageState extends State<ChooseTimeSlotPage> {
  bool _isLoading = false;
  String _setTime = "";
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
    // await _getAndSetbookedTimeSlots();
    await _getAndSetOpeningClosingTime();
    // await _setClosingDate();
    _getAndsetTimeSlots(_openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);
    setState(() {
      _isLoading = false;
    });
  }

  _reCallMethodes() async {
    setState(() {
      _isLoading = true;
    });
    // await _getAndSetbookedTimeSlots();
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
        serviceTime
    ); //calculate all the possible time slots between opening and closing time

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
        bottomNavigationBar: BottomNavigationStateWidget(
          title: "Suivant",
          onPressed: () {
            Get.toNamed("/RegisterPatientPage",
                arguments: ChooseTimeScrArg(
                  widget.appointmentType,
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
            CAppBarWidget(title: "Demander Rendez-vous", isConn: widget.isConn),

            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.only(
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
                                    ? const LoadingIndicatorWidget()
                                      : Column(
                                            children: <Widget>[
                                              _morningTimeSlotsList.isEmpty
                                                  ? Container()
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Text(
                                                          "Matin",
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
                                                          "Après-midi",
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
                                                          "Soir",
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
    return formatted;
  }

  Widget _timeSlots(String time, bookedTime, serviceTimeMin) {
    bool _isNoRemainingTime = false;

    //print("dddddddddddddddddd ");
    final todayDate = _setTodayDateFormate();

    if (_selectedDate == todayDate) {
      if (int.parse(time.substring(0, 2)) < DateTime.now().hour) {

        _isNoRemainingTime = true;
      } else if (int.parse(time.substring(0, 2)) == DateTime.now().hour) {
        //false
        if (int.parse(time.substring(3, 5)) <= DateTime.now().minute) {
          _isNoRemainingTime = true;
        }
      }
    }

    return GestureDetector(
      onTap: _isNoRemainingTime 
          ? null
          : () {
              setState(() {
                _setTime == time ? _setTime = "" : _setTime = time;
              });
            },
        child: Card(
          color: time == _setTime
              ? btnColor
              : _isNoRemainingTime 
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
