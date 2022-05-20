class ServiceModel{
  String title;
  String price;
  String duree;
  String desc;
  String category;

  ServiceModel({
    this.duree,
    this.price,
    this.title,
    this.desc,
    this.category

  });

  factory ServiceModel.fromJson(Map<String,dynamic> json){
    return ServiceModel(

      title: json['title'],
      duree: json['duree'],
      price: json['price'],
      desc: json['description'],
      category: json['category_id'],

    );
  }

}