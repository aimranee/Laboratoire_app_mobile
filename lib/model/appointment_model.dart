class AppointmentModel{
  String appointmentDate;
  String appointmentStatus;
  String appointmentTime;
  String appointmentType;
  int serviceTimeMin;
  String uId;
  String description;
  String uName;
  String id;
  String createdTimeStamp;
  String updatedTimeStamp;

  AppointmentModel({
    this.appointmentDate,
    this.appointmentStatus,
    this.appointmentTime,
    this.appointmentType,
    this.serviceTimeMin,
    this.uId,
    this.description,
    this.uName,
    this.id,
    this.createdTimeStamp,
    this.updatedTimeStamp,
  });

  factory AppointmentModel.fromJson(Map<String,dynamic> json){
    return AppointmentModel(
      appointmentDate:json['appointmentDate'],
      appointmentStatus:json['appointmentStatus'],
      appointmentTime:json['appointmentTime'],
      appointmentType:json['appointmentType'],
      serviceTimeMin:int.parse(json['serviceTimeMin'],),
      uId:json['uId'],
      description:json['description'],
      uName:json['uName'],
      id:json['id'],
      createdTimeStamp:json['createdTimeStamp'],
      updatedTimeStamp:json['updatedTimeStamp'],

    );
  }
   Map<String,dynamic> toJsonAdd(){
    return {
      "appointmentDate":appointmentDate,
      "appointmentStatus":appointmentStatus,
      "appointmentTime":appointmentTime,
      "appointmentType":appointmentType,
      "serviceTimeMin":(serviceTimeMin).toString(),
      "uId":uId,
      "description":description,
      "uName":uName,

    };

  }
  Map<String,dynamic> toJsonUpdateStatus(){
    return {

      "appointmentStatus":appointmentStatus,
      "id":id,

    };

  }
}