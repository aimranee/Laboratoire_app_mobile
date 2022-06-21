
class AppointmentTypeModel{
  String title;
  String imageUrl;
  int forTimeMin;
  String openingTime;
  String closingTime;

  AppointmentTypeModel({
    this.title,
    this.imageUrl,
    this.forTimeMin,
    this.openingTime,
    this.closingTime,
  });

  factory AppointmentTypeModel.fromJson(Map<String,dynamic> json){
    return AppointmentTypeModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      forTimeMin:  int.parse(json['forTimeMin']),
      openingTime: json['openingTime'],
      closingTime: json['closingTime']
    );
  }

}