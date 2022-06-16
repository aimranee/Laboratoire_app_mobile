class UserModel {
  String id;
  String firstName;
  String lastName;
  String uId;
  String city;
  String email;
  String fcmId;
  String pNo;
  String createdTimeStamp;
  String updatedTimeStamp;
  String age;
  String gender;
  String cin;
  String familySituation;
  String hasRamid;
  String hasCnss;
  String bloodType;
  String diseaseState;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.uId,
      this.city,
      this.email,
      this.fcmId,
      this.pNo,
      this.createdTimeStamp,
      this.updatedTimeStamp,
      this.age,
      this.gender,
      this.cin,
      this.hasRamid,
      this.hasCnss,
      this.familySituation,
      this.bloodType,
      this.diseaseState});

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    uId = json['uId'];
    city = json['city'];
    email = json['email'];
    fcmId = json['fcmId'];
    pNo = json['pNo'];
    age = json['age'];
    gender = json['gender'];
    cin = json['cin'];
    familySituation = json['familySituation'];
    hasRamid = json['hasRamid'].toString();
    hasCnss = json['hasCnss'].toString();
    bloodType = json['bloodType'];
    diseaseState = json['diseaseState'];
  }

    Map<String,dynamic> toJsonAdd(){
    return {
      'firstName':firstName,
      'lastName':lastName,
      'email':email,
      'bloodType':bloodType,
      'cin':cin,
      'uId':uId,
      'city':city,
      'pNo':pNo,
      'age':age,
      'gender':gender,
      'familySituation':familySituation,
      'hasRamid':hasRamid,
      'hasCnss':hasCnss,
      'fcmId':fcmId,
    };

  }
  Map<String,dynamic> toUpdateJson(){
    return {
      "uId": uId,
      "firstName": firstName,
      "lastName": lastName,
      "city": city,
      "age": age,
      "email": email,
      "gender":gender,
      "pNo": pNo,
      "cin": cin,
      "familySituation": familySituation,
      "hasRamid": hasRamid,
      "hasCnss": hasCnss,
      "bloodType": bloodType,
    };
  }
}