import 'package:laboratoire_app/Screen/prescription/prescriptionDetails.dart';
import 'package:laboratoire_app/Service/prescriptionService.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/bottomNavigationBarWidget.dart';
import 'package:laboratoire_app/widgets/errorWidget.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:laboratoire_app/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';


class PrescriptionListPage extends StatefulWidget {
  const PrescriptionListPage({Key key}) : super(key: key);

  @override
  _PrescriptionListPageState createState() => _PrescriptionListPageState();
}

class _PrescriptionListPageState extends State<PrescriptionListPage> {
 final ScrollController _scrollController=new ScrollController();
 void dispose() {
   // TODO: implement dispose
   _scrollController.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationWidget(route: "/ContactUsPage", title:"Contact us"),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title:"Prescriptions"),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration:IBoxDecoration.upperBoxDecoration(),
              child:FutureBuilder(
                  future: PrescriptionService.getData(),
                  //ReadData.fetchNotification(FirebaseAuth.instance.currentUser.uid),//fetch all times
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.length == 0
                          ? NoDataWidget()
                          : Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 8, right: 8),
                          child: _buildCard(snapshot.data));
                    } else if (snapshot.hasError) {
                      return IErrorWidget();
                    } else {
                      return LoadingIndicatorWidget();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCard(prescriptionDetails) {
    // _itemLength=notificationDetails.length;
    return ListView.builder(
        controller: _scrollController,
        itemCount: prescriptionDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>   PrescriptionDetailsPage(
                            title: prescriptionDetails[index].appointmentName,
                          prescriptionDetails:prescriptionDetails[index])
                      ),
                    );

            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: Text(
                      prescriptionDetails[index].appointmentName,
                      style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 14.0,
                      )),
                        trailing: Icon(Icons.arrow_forward_ios,color: iconsColor,size: 20,),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${prescriptionDetails[index].patientName}",
                          style: TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 14,
                          ),
                        ),
                        Text("${prescriptionDetails[index].appointmentDate} ${prescriptionDetails[index].appointmentTime}",
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }
}
