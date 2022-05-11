
class AppointmentModel{
  String appointmentDate;
  String appointmentStatus;
  String appointmentTime;
  String pCity;
  String age;
  String pEmail;
  String pFirstName;
  String pLastName;
  String serviceName;
  int serviceTimeMin;
  String uId;
  String pPhn;
  String description;
  String searchByName;
  String uName;
  String id;
  String createdTimeStamp;
  String updatedTimeStamp;
  String gender;

  AppointmentModel({
    this.appointmentDate,
    this.appointmentStatus,
    this.appointmentTime,
    this.pCity,
    this.age,
    this.pEmail,
    this.pFirstName,
    this.pLastName,
    this.serviceName,
    this.serviceTimeMin,
    this.uId,
    this.pPhn,
    this.description,
    this.searchByName,
    this.uName,
    this.id,
    this.createdTimeStamp,
    this.updatedTimeStamp,
    this.gender

  });

  factory AppointmentModel.fromJson(Map<String,dynamic> json){
    return AppointmentModel(
      appointmentDate:json['appointmentDate'],
      appointmentStatus:json['appointmentStatus'],
      appointmentTime:json['appointmentTime'],
      pCity:json['pCity'],
      age:json['age'],
      pEmail:json['pEmail'],
      pFirstName:json['pFirstName'],
      pLastName:json['pLastName'],
      serviceName:json['serviceName'],
      serviceTimeMin:int.parse(json['serviceTimeMin'],),
      uId:json['uId'],
      pPhn:json['pPhn'],
      description:json['description'],
      searchByName:json['searchByName'],
      uName:json['uName'],
        id:json['id'],
        createdTimeStamp:json['createdTimeStamp'],
        updatedTimeStamp:json['updatedTimeStamp'],
      gender: json['gender']

    );
  }
   Map<String,dynamic> toJsonAdd(){
    return {
      "appointmentDate":appointmentDate,
      "appointmentStatus":appointmentStatus,
      "appointmentTime":appointmentTime,
      "pCity":pCity,
      "age":age,
      "pEmail":pEmail,
      "pFirstName":pFirstName,
      'pLastName':pLastName,
      "serviceName":serviceName,
      "serviceTimeMin":(serviceTimeMin).toString(),
      "uId":uId,
      "pPhn":pPhn,
      "description":description,
      "searchByName":searchByName,
      "uName":uName,
      "gender":gender,

    };

  }
  Map<String,dynamic> toJsonUpdateStatus(){
    return {

      "appointmentStatus":appointmentStatus,
      "id":id,

    };

  }
}