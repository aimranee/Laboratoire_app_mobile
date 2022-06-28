class PatientModel {
  String uId;
  String firstName;
  String lastName;
  String email;
  String password;
  String fcmId;
  String pNo;
  String city;
  String createdTimeStamp;
  String updatedTimeStamp;
  String age;
  String gender;
  String cin;
  String hasRamid;
  String hasCnss;
  String familySituation;
  String bloodType;
  String diseaseState;

  PatientModel(
      {this.uId,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.fcmId,
      this.pNo,
      this.city,
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

  PatientModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'].toString();
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    fcmId = json['fcmId'];
    pNo = json['pNo'];
    city = json['city'];
    createdTimeStamp = json['createdTimeStamp'];
    updatedTimeStamp = json['updatedTimeStamp'];
    age = json['age'];
    gender = json['gender'];
    cin = json['cin'];
    hasRamid = json['hasRamid'].toString();
    hasCnss = json['hasCnss'].toString();
    familySituation = json['familySituation'];
    bloodType = json['bloodType'];
    diseaseState = json['diseaseState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uId'] = uId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['fcmId'] = fcmId;
    data['pNo'] = pNo;
    data['city'] = city;
    data['createdTimeStamp'] = createdTimeStamp;
    data['updatedTimeStamp'] = updatedTimeStamp;
    data['age'] = age;
    data['gender'] = gender;
    data['cin'] = cin;
    data['hasRamid'] = hasRamid;
    data['hasCnss'] = hasCnss;
    data['familySituation'] = familySituation;
    data['bloodType'] = bloodType;
    data['diseaseState'] = diseaseState;
    return data;
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