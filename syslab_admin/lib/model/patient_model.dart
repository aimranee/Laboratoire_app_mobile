class PatientModel {
  String uId;
  String firstName;
  String lastName;
  String email;
  String password;
  String pNo;
  String fcmId;
  String city;
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
      this.pNo,
      this.fcmId,
      this.city,
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
    pNo = json['pNo'];
    fcmId = json['fcmId'];
    city = json['city'];
    age = json['age'].toString();
    gender = json['gender'];
    cin = json['cin'];
    hasRamid = json['hasRamid'].toString();
    hasCnss = json['hasCnss'].toString();
    familySituation = json['familySituation'];
    bloodType = json['bloodType'];
    diseaseState = json['diseaseState'];
  }

  Map<String, dynamic> toJsonAdd() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['pNo'] = pNo;
    data['fcmId'] = fcmId;
    data['city'] = city;
    data['age'] = age;
    data['gender'] = gender;
    data['cin'] = cin;
    data['hasRamid'] = hasRamid;
    data['hasCnss'] = hasCnss;
    data['familySituation'] = familySituation;
    data['bloodType'] = bloodType;
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