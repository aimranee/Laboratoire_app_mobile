import 'dart:developer';

class AvailabilityModel{
  String mon;
  String tue;
  String wed;
  String thu;
  String fri;
  String sat;
  String sun;
  String id;

  AvailabilityModel({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
    this.id
});

  factory AvailabilityModel.fromJson(Map<String,dynamic> json){
    return AvailabilityModel(
    mon: json['mon'],
    tue: json['tue'],
    wed: json['wed'],
    thu: json['thu'],
    fri: json['fri'],
    sat: json['sat'],
    sun: json['sun'],
    id: json['id'].toString()

    );
  }
  Map<String,dynamic> toUpdateJson(){
    return {
      "mon": mon,
      "tue": tue,
      "wed": wed,
      "thu": thu,
      "fri": fri,
      "sat": sat,
      "sun": sun,
      "id": id
    };

  }

}