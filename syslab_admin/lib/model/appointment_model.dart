
class AppointmentModel{
  String appointmentDate;
  String appointmentStatus;
  String appointmentTime;
  String appointmentType;
  int serviceTimeMin;
  String uId;
  String price;
  String analyses;
  String description;
  String uName;
  String id;
  String location;
  String createdTimeStamp;
  String updatedTimeStamp;

  AppointmentModel({
    this.appointmentDate,
    this.appointmentStatus,
    this.appointmentTime,
    this.appointmentType,
    this.serviceTimeMin,
    this.uId,
    this.price,
    this.analyses,
    this.description,
    this.uName,
    this.id,
    this.location,
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
      price:json['price'],
      analyses:json['analyses'],
      description:json['description'],
      uName:json['uName'],
      id:json['id'].toString(),
      location:json['location'],
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
      "price":price,
      "analyses":analyses,
      "description":description,
      "uName":uName,
      "location":location
    };

  }

   Map<String,dynamic> toJsonUpdate(){
    return {
      "id": id,
      "description": description,
    };

  }
  Map<String,dynamic> toJsonUpdateStatus(){
    return {

      "appointmentStatus": appointmentStatus,
      "id": id,

    };

  }
  Map<String,dynamic> toJsonUpdateResch(){
    return {
      "appointmentStatus": appointmentStatus,
      "id": id,
      "appointmentDate": appointmentDate,
      "appointmentTime": appointmentTime

    };

  }

}