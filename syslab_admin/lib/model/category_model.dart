class CategoryModel {
  String id;
  String name;
  String description;

  CategoryModel({
    this.id, 
    this.name, 
    this.description
  });

  factory CategoryModel.fromJson(Map<String,dynamic> json){
    return CategoryModel(

      id: json['id'].toString(),
      name: json['name'],
      description: json['description']

    );
  }
}