class UserModel {
  String id;
  String firstName;
  String lastName;
  String uId;
  String city;
  String email;
  String fcmId;
  String pNo;
  String searchByName;
  String createdTimeStamp;
  String updatedTimeStamp;
  String age;
  String gender;
  String cin;
  String familySituation;
  String hasRamid;
  String hasCnss;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.uId,
      this.city,
      this.email,
      this.fcmId,
      this.pNo,
      this.searchByName,
      this.createdTimeStamp,
      this.updatedTimeStamp,
      this.age,
      this.gender,
      this.cin,
      this.familySituation,
      this.hasRamid,
      this.hasCnss});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    uId = json['uId'];
    city = json['city'];
    email = json['email'];
    fcmId = json['fcmId'];
    pNo = json['pNo'];
    searchByName = json['searchByName'];
    createdTimeStamp = json['createdTimeStamp'];
    updatedTimeStamp = json['updatedTimeStamp'];
    age = json['age'];
    gender = json['gender'];
    cin = json['cin'];
    familySituation = json['familySituation'];
    hasRamid = json['hasRamid'];
    hasCnss = json['hasCnss'];
  }

  Map<String, dynamic> toJsonAdd() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['uId'] = uId;
    data['city'] = city;
    data['email'] = email;
    data['fcmId'] = fcmId;
    data['pNo'] = pNo;
    data['searchByName'] = searchByName;
    data['createdTimeStamp'] = createdTimeStamp;
    data['updatedTimeStamp'] = updatedTimeStamp;
    data['age'] = age;
    data['gender'] = gender;
    data['cin'] = cin;
    data['familySituation'] = familySituation;
    data['hasRamid'] = hasRamid;
    data['hasCnss'] = hasCnss;
    return data;
  }
}