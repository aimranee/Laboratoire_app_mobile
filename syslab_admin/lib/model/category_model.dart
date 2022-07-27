class CategoryModel {
  String id;
  String name;
  String description;
  String createdTimeStamp;
  String updatedTimeStamp;

  CategoryModel({
    this.id, 
    this.name, 
    this.description,
    this.createdTimeStamp,
    this.updatedTimeStamp
  });

  factory CategoryModel.fromJson(Map<String,dynamic> json){
    return CategoryModel(

      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      createdTimeStamp: json['createdTimeStamp'],
      updatedTimeStamp: json['updatedTimeStamp']
    );
  }

    Map<String, dynamic> toAddJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['createdTimeStamp'] = createdTimeStamp;
    data['updatedTimeStamp'] = updatedTimeStamp;
    return data;
  }

  Map<String,dynamic> toUpdateJson(){
    return {
      "id": id,
      "name": name,
      "description": description,
      "updatedTimeStamp": updatedTimeStamp
    };
  }
}