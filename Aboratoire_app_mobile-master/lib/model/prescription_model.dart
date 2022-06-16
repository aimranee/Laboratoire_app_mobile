
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
    this.isPaied
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
      price: json['price'],
      drName: json['drName'],
      fileUrl: json['fileUrl'],
      isPaied: json['isPaied']
    );
  }
    Map<String,dynamic> toJsonUpdateStatus(){
    return {

      "isPaied":isPaied,
      "id":id,

    };

  }

}