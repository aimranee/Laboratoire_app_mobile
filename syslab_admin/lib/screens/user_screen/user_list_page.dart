// import 'package:syslab_admin/screens/userScreen/editUserProfilePage.dart';
import 'package:get/get.dart';
import 'package:syslab_admin/screens/user_screen/edit_userprofile_page.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/boxWidget.dart';
import 'package:syslab_admin/widgets/errorWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:syslab_admin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/appbars.dart';
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
      appBar: IAppBars.commonAppBar(context, "users"),
      bottomNavigationBar: BottomNavTwoBarWidget(
        firstBtnOnPressed: _handleByNameBtn,
        firstTitle: "Search By Name",
        isenableBtn: _isEnableBtn,
      ),
      body: FutureBuilder(
          future: PatientService.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : _buildUserList(snapshot.data);
            } else if (snapshot.hasError) {
              return IErrorWidget();
            } else {
              return LoadingIndicatorWidget();
            }
          }),
    );
  }

  _handleByNameBtn() {
    Get.toNamed("/SearchUserByNamePage");
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
                    //         DateFormat _dateFormat = DateFormat('y-MM-d');
                    // String formattedDate =  _dateFormat.format(dateTime);
                    subtitle:
                        Text("Created at ${userList[index].createdTimeStamp}"),
                  ),
                ),
                const Divider()
              ],
            ),
          );
        });
  }
}
