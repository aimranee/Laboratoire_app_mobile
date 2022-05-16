
class ServiceModel{
  String title;
  String prix;
  String duree;
  String desc;


  ServiceModel({
    this.duree,
    this.prix,
    this.title,
    this.desc

  });

  factory ServiceModel.fromJson(Map<String,dynamic> json){
    return ServiceModel(

      title: json['title'],
      duree: json['duree'],
      prix: json['prix'],
      desc: json['description']

    );
  }

}