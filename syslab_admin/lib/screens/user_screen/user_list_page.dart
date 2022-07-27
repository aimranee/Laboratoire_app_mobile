// import 'package:syslab_admin/screens/userScreen/editUserProfilePage.dart';
import 'package:get/get.dart';
import 'package:syslab_admin/screens/user_screen/edit_userprofile_page.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/box_widget.dart';
import 'package:syslab_admin/widgets/error_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({Key key}) : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  @override
  Widget build(BuildContext context) {
    bool _isEnableBtn = true;
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Liste patients"),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _handleByCINBtn,
        title: "Rechercher par CIN",
        isEnableBtn: _isEnableBtn,
      ),
      body: FutureBuilder(
        future: PatientService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0
                ? const NoDataWidget()
                : _buildUserList(snapshot.data);
          } else if (snapshot.hasError) {
            return const IErrorWidget();
          } else {
            return const LoadingIndicatorWidget();
          }
      }),
    );
  }

  _handleByCINBtn() {
    Get.toNamed("/SearchPatientByCINPage");
  }

  Widget _buildUserList(userList) {
    return ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(()=>
                      EditUserProfilePage(userDetails: userList[index])
                    );
                  },
                  child: ListTile(
                    trailing: const Icon(
                      Icons.arrow_right,
                      color: primaryColor,
                    ),

                    leading: CircularUserImageWidget(userList: userList[index]),
                    title: Text(
                        "${userList[index].firstName} ${userList[index].lastName}"),
                    subtitle:
                        Text("CIN : ${userList[index].cin}"),
                  ),
                ),
                const Divider()
              ],
            ),
          );
        });
  }
}

