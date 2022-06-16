class AnalysesCatModel {
  String analysesId;
  String analysesName;
  double analysesPrice;
  AnalysesCatModel({
    this.analysesId,
    this.analysesName,
    this.analysesPrice,
  });
  
  AnalysesCatModel.fromJson(Map<String, dynamic> json) {
    analysesId = json['id'].toString();
    analysesName = json['name'];
    analysesPrice = double.parse(json['price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = analysesId;
    data['name'] = analysesName;
    data['price'] = analysesPrice;
    return data;
  }
}
