class AppointmentTypeModel{
  String id;
  String title;
  String imageUrl;
  int forTimeMin;
  String openingTime;
  String closingTime;

  AppointmentTypeModel({
    this.id,
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

  Map<String, dynamic> toAddJson() {
    return {
      "title":  title,
      "forTimeMin": (forTimeMin).toString(),
      "imageUrl":  imageUrl,
      "openingTime": openingTime,
      "closingTime": closingTime,
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "title":  title,
      "forTimeMin": (forTimeMin).toString(),
      "imageUrl":  imageUrl,
      "id": id,
      "openingTime": openingTime,
      "closingTime": closingTime,
    };
  }

}