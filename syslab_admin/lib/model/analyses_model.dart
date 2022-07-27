class AnalysesModel {
  String id;
  String name;
  String libBilan;
  String libAutomat;
  String valeurReference;
  String unite;
  String price;
  String description;
  String min;
  String max;
  String categoryId;
  String categoryName;
  String titre;
  String dispo;
  String lotsActif;
  String index;
  String createdTimeStamp;
  String updatedTimeStamp;

  AnalysesModel(
      {this.id,
      this.name,
      this.libBilan,
      this.libAutomat,
      this.valeurReference,
      this.unite,
      this.price,
      this.description,
      this.min,
      this.max,
      this.categoryId,
      this.categoryName,
      this.titre,
      this.dispo,
      this.lotsActif,
      this.index,
      this.createdTimeStamp,
      this.updatedTimeStamp});

  AnalysesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    libBilan = json['libBilan'];
    libAutomat = json['libAutomat'];
    valeurReference = json['valeurReference'];
    unite = json['unite'];
    price = json['price'];
    description = json['description'];
    min = json['min'];
    max = json['max'];
    categoryId = json['categoryId'].toString();
    categoryName = json['categoryName'];
    titre = json['titre'];
    dispo = json['dispo'];
    lotsActif = json['lotsActif'];
    index = json['index'];
    createdTimeStamp = json['createdTimeStamp'];
    updatedTimeStamp = json['updatedTimeStamp'];
  }

  Map<String, dynamic> toAddJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['libBilan'] = libBilan;
    data['libAutomat'] = libAutomat;
    data['valeurReference'] = valeurReference;
    data['unite'] = unite;
    data['price'] = price;
    data['description'] = description;
    data['min'] = min;
    data['max'] = max;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['titre'] = titre;
    data['createdTimeStamp'] = createdTimeStamp;
    data['updatedTimeStamp'] = updatedTimeStamp;
    return data;
  }

  Map<String,dynamic> toUpdateJson(){
    return {
      'id' : id,
      'name' : name,
      'libBilan' : libBilan,
      'libAutomat' : libAutomat,
      'valeurReference' : valeurReference,
      'unite' : unite,
      'price' : price,
      'description' : description,
      'min' : min,
      'max' : max,
      'categoryId' : categoryId,
      'categoryName' : categoryName,
      'titre' : titre,
      'updatedTimeStamp' : updatedTimeStamp
    };
  }

}
