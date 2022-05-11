
class ServiceModel{
  String title;
  String subTitle;
  String imageUrl;
  String desc;


  ServiceModel({
    this.imageUrl,
    this.subTitle,
    this.title,
    this.desc

  });

  factory ServiceModel.fromJson(Map<String,dynamic> json){
    return ServiceModel(

      title: json['title'],
      subTitle: json['subTitle'],
      imageUrl: json['imageUrl'],
      desc: json['description']

    );
  }

}