// import 'package:syslab_admin/screens/userScreen/editUserProfilePage.dart';
import 'package:syslab_admin/service/userService.dart';
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
  Widget build(BuildContext context) {
    bool _isEnableBtn = true;
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "users"),
      bottomNavigationBar: BottomNavTwoBarWidget(
        firstBtnOnPressed: _handleByNameBtn,
        firstTitle: "Search By Name",
        isenableBtn: _isEnableBtn,
        secondBtnOnPressed: _handleByIdBtn,
        secondTitle: "Search By ID",
      ),
      body: FutureBuilder(
          future: UserService.getUsers(),
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
    Navigator.pushNamed(context, "/SearchUserByNamePage");
  }

  _handleByIdBtn() {
    Navigator.pushNamed(context, "/SearchUserByIdPage");
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => EditUserProfilePage(
                    //           userDetails: userList[index]
                    //           )),
                    // );
                  },
                  child: ListTile(
                    trailing: Icon(
                      Icons.arrow_right,
                      color: primaryColor,
                    ),

                    leading: CircularUserImageWidget(userList: userList[index]),
                    title: Text(
                        "${userList[index].firstName} ${userList[index].lastName}"),
                    //         DateFormat _dateFormat = DateFormat('y-MM-d');
                    // String formattedDate =  _dateFormat.format(dateTime);
                    subtitle:
                        const Text("Created at userList[index].createdTimeStamp"),
                    //  isThreeLine: true,
                  ),
                ),
                const Divider()
              ],
            ),
          );
        });
  }
}
