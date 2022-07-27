class PrescriptionModel {
  String id;
  String results;
  String patientName; //fcm id
  String appointmentId;
  String appointmentTime;
  String appointmentDate;
  String appointmentName;
  String drName;
  String price;
  String isPaied;
  String patientId;
  String prescriptionStatus;
  String createdTimeStamp;
  String updatedTimeStamp;

  PrescriptionModel({
    this.id,
    this.appointmentTime,
    this.appointmentDate,
    this.appointmentId,
    this.appointmentName,
    this.price,
    this.patientName,
    this.results,
    this.drName,
    this.isPaied,
    this.patientId,
    this.prescriptionStatus,
    this.createdTimeStamp,
    this.updatedTimeStamp
  });

  factory PrescriptionModel.fromJson(Map<String,dynamic> json){
    return PrescriptionModel(
      id: json['id'].toString(),
      appointmentTime: json['appointmentTime'],
      appointmentDate: json['appointmentDate'],
      appointmentId: json['appointmentId'],
      appointmentName: json['appointmentName'],
      results: json['results'],
      patientName: json['patientName'],
      price: json['price'].toString(),
      drName: json['drName'],
      prescriptionStatus: json['prescriptionStatus'],
      isPaied: json['isPaied'].toString(),
      patientId: json['patientId'].toString(),
      createdTimeStamp: json['createdTimeStamp'],
      updatedTimeStamp	: json['updatedTimeStamp']
    );
  }
  
  Map<String,dynamic> toJsonAdd(){
    return {
      "appointmentId": appointmentId,
      "patientId": patientId,
      "appointmentTime": appointmentTime,
      "appointmentDate": appointmentDate,
      "appointmentName": appointmentName,
      "drName": drName,
      "price": price,
      "patientName": patientName,
      "results": results,
      "prescriptionStatus": prescriptionStatus,
      "createdTimeStamp": createdTimeStamp,
      "updatedTimeStamp": updatedTimeStamp
    };
  }

  Map<String,dynamic> toJsonUpdate(){
    return {
      "results": results,
      "drName": drName,
      "prescriptionStatus": prescriptionStatus,
      "updatedTimeStamp": updatedTimeStamp,
      "id": id
    };
  }

  //   Map<String,dynamic> toJsonUpdatePaied(){
  //   return {
  //     "isPaied":isPaied,
  //     "id":id
  //   };
  // }

  Map<String,dynamic> toJsonUpdateStatus(){
    return {
      "prescriptionStatus": prescriptionStatus,
      "id": id,
      "updatedTimeStamp": updatedTimeStamp
    };
  }

}