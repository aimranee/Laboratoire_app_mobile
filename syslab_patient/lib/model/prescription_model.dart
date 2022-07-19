
class PrescriptionModel {
  String id;
  String prescription;
  String patientName; //fcm id
  String appointmentId;
  String appointmentTime;
  String appointmentDate;
  String appointmentName;
  String drName;
  String price;
  String fileUrl;
  String isPaied;
  String prescriptionStatus;
  String patientId;
  String updatedTimeStamp;

  PrescriptionModel({
    this.id,
    this.appointmentTime,
    this.appointmentDate,
    this.appointmentId,
    this.appointmentName,
    this.price,
    this.patientName,
    this.prescription,
    this.fileUrl,
    this.drName,
    this.isPaied,
    this.patientId,
    this.prescriptionStatus,
    this.updatedTimeStamp
  });

  factory PrescriptionModel.fromJson(Map<String,dynamic> json){
    return PrescriptionModel(
      id: json['id'].toString(),
      appointmentTime: json['appointmentTime'],
      appointmentDate: json['appointmentDate'],
      appointmentId: json['appointmentId'],
      appointmentName: json['appointmentName'],
      prescription: json['prescription'],
      patientName: json['patientName'],
      price: json['price'].toString(),
      drName: json['drName'],
      fileUrl: json['fileUrl'],
      isPaied: json['isPaied'].toString(),
      prescriptionStatus: json['prescriptionStatus'],
      updatedTimeStamp: json['updatedTimeStamp']
    );
  }
    Map<String,dynamic> toJsonUpdateStatus(){
    return {

      "isPaied":isPaied,
      "id":id,
      "updatedTimeStamp" : updatedTimeStamp
    };

  }

}