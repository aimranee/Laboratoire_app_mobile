import 'package:syslab_admin/screens/user_screen/edit_userprofile_page.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/box_widget.dart';
import 'package:syslab_admin/widgets/buttons_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';

class SearchPatientByCINPage extends StatefulWidget {
  const SearchPatientByCINPage({Key key}) : super(key: key);

  @override
  _SearchPatientByCINPageState createState() => _SearchPatientByCINPageState();
}

class _SearchPatientByCINPageState extends State<SearchPatientByCINPage> {
  List _userList = [];
  bool _isLoading = false;
  final bool _isEnableBtn = true;
  bool _isSearchedBefore = false;

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
          hintText: "Rechercher patient CIN",
          validatorText: "Entrez CIN",
        ),
        actions: [
          SearchBtnWidget(
            onPressed: _handleSearchBtn,
            isEnableBtn: _isEnableBtn,
          )
        ],
      ),
      body: Container(
        child: _cardListBuilder(),
      ),
    );
  }

  Widget _cardListBuilder() {
    return ListView(
      children: [
        //_buildUpperBoxContainer(),
        !_isSearchedBefore
            ? Container()
            : _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LoadingIndicatorWidget(),
                  )
                : _userList.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: _userList.length,
                        itemBuilder: (context, index) {
                          return _buildChatList(_userList[index]);
                        },
                      )
                    : const NoDataWidget()
      ],
    );
  }

  Widget _buildChatList(userList) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditUserProfilePage(userDetails: userList)),
              );
            },
            child: ListTile(
              leading: CircularUserImageWidget(userList: userList),
              title: Text("${userList.firstName} ${userList.lastName}"),
              subtitle: Text("Créé à ${userList.createdTimeStamp}"),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }

  _handleSearchBtn() async {

    String searchByCIN = _searchByCINController.text; //lowercase all letter and remove all space
    if (searchByCIN != "") {
      setState(() {
        _isLoading = true;
        _isSearchedBefore = true;
      });

      final res = await PatientService.getUserByCIN(searchByCIN);

      setState(() {
        _userList = res;
        _isLoading = false;
      });
    }
  }
}
