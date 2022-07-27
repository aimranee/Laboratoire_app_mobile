import 'package:get/get.dart';
import 'package:syslab_admin/screens/prescription/add_prescription_page.dart';
import 'package:syslab_admin/screens/prescription/editprescriptionDetails.dart';
import 'package:syslab_admin/service/prescription_service.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/widgets/error_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:syslab_admin/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';

class PrescriptionListByIDPage extends StatefulWidget {
  final String appointmentId;
  final String userId;
  final String patientName;
  final String date;
  final String time;
  final String appointmentType;
  final String price;
  const PrescriptionListByIDPage({Key key,this.price, this.appointmentId,this.userId,this.patientName,this.time,this.appointmentType,this.date}) : super(key: key);
  @override
  _PrescriptionListByIDPageState createState() => _PrescriptionListByIDPageState();
}

class _PrescriptionListByIDPageState extends State<PrescriptionListByIDPage> {

  final ScrollController _scrollController=ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.patientName),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child:  const Icon(Icons.add),

          backgroundColor:btnColor,
          onPressed: (){
            Get.to(() => AddPrescriptionPage(
                  title: "Ajouter une nouvelle résultats",
                  patientName: widget.patientName,
                  appointmentType: widget.appointmentType,
                  date: widget.date,
                  time: widget.time,
                  appointmentId: widget.appointmentId,
                  patientId: widget.userId,
                  price: widget.price,
                )
            );
          }
      ),
      body:FutureBuilder(

        future: PrescriptionService.getDataByApId(appointmentId: widget.appointmentId,uId: widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0
                ? const NoDataWidget()
                : Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, left: 8, right: 8),
                  child: _buildCard(snapshot.data)
                );
          } else if (snapshot.hasError) {
            return const IErrorWidget();
          } else {
            return const LoadingIndicatorWidget();
          }
        }),
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
              Get.to(() => PrescriptionDetailsPage(
                title: prescriptionDetails[index].appointmentName,
                prescriptionDetails:prescriptionDetails[index],
                )
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
                        style: const TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 14.0,
                        )),
                    trailing: const Icon(Icons.arrow_forward_ios,color: iconsColor,size: 20,),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${prescriptionDetails[index].patientName}",
                          style: const TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 14,
                          ),
                        ),
                        Text("${prescriptionDetails[index].appointmentDate} ${prescriptionDetails[index].appointmentTime}",
                          style: const TextStyle(
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
