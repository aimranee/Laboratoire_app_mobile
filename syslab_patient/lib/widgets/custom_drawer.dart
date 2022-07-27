
import 'package:flutter/material.dart';
import 'package:patient/widgets/bottom_user_info.dart';
import 'package:patient/widgets/custom_list_tile.dart';
import 'package:patient/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  bool isConn = false;
  CustomDrawer({Key key, this.isConn}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;
  String username = "SYSLAB";

  @override
  void initState() {
    _getUserData();
    super.initState();
  }
_getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

      if (pref.getString("fcm") != "") {
        setState(() {
          username = pref.getString("firstName") + " " + pref.getString("lastName");
        });
      }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(20, 20, 20, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDrawerHeader(isColapsed: _isCollapsed, username: username),
              const Divider(
                color: Colors.grey,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.home_outlined,
                title: 'Home',
                root: '/HomePage',
                // isConn: widget.isConn,
                infoCount: 0,
              ),
              const SizedBox(height: 15),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.calendar_today,
                title: 'Availability',
                root: '/AvailabilityPage',
                isConn: widget.isConn,
                infoCount: 0,
              ),
              const SizedBox(height: 15),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.monitor_heart_rounded,
                title: 'Services',
                root: '/ServicesPage',
                isConn: widget.isConn,
                infoCount: 0,
              ),
              const SizedBox(height: 15),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.timelapse_outlined,
                title: 'Appointment',
                root: '/Appointmentstatus',
                isConn: widget.isConn,
                infoCount: 0,
              ),
              const SizedBox(height: 15),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.file_present_rounded,
                title: 'Documents',
                root: '/Documents',
                isConn: widget.isConn,
                infoCount: 0,
              ),
              const SizedBox(height: 15),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.payment_rounded,
                title: 'Payment',
                // root: '',
                // isConn: widget.isConn,
                infoCount: 0,
              ),
              const SizedBox(height: 15),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.person,
                title: 'Profile',
                root: '/Profile',
                isConn: widget.isConn,
                infoCount: 0,
              ),
              
              const Divider(color: Colors.grey),
              const Spacer(),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.notifications,
                title: 'Notifications',
                root: '/NotificationPage',
                infoCount: 2,
              ),
              const SizedBox(height: 10),
              BottomUserInfo(isCollapsed: _isCollapsed, isConn: widget.isConn),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
