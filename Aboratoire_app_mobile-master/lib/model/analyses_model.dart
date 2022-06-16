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
  String createdAt;
  String updatedAt;

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
      this.createdAt,
      this.updatedAt});

  AnalysesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    libBilan = json['lib_bilan'];
    libAutomat = json['lib_automat'];
    valeurReference = json['valeur_reference'];
    unite = json['unite'];
    price = json['price'];
    description = json['description'];
    min = json['min'];
    max = json['max'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    titre = json['titre'];
    dispo = json['dispo'];
    lotsActif = json['lots_actif'];
    index = json['index'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['lib_bilan'] = libBilan;
    data['lib_automat'] = libAutomat;
    data['valeur_reference'] = valeurReference;
    data['unite'] = unite;
    data['price'] = price;
    data['description'] = description;
    data['min'] = min;
    data['max'] = max;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['titre'] = titre;
    data['dispo'] = dispo;
    data['lots_actif'] = lotsActif;
    data['index'] = index;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
