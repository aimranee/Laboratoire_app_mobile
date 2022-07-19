class UserModel {
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
  String isAnyNotification;
  String createdTimeStamp;
  String updatedTimeStamp;

  UserModel(
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
      this.diseaseState,
      this.isAnyNotification,
      this.createdTimeStamp,
      this.updatedTimeStamp});

  UserModel.fromJson(Map<String, dynamic> json) {
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
    isAnyNotification = json['isAnyNotification'];
  }

  Map<String, dynamic> toJsonAdd() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['pNo'] = this.pNo;
    data['fcmId'] = this.fcmId;
    data['city'] = this.city;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['cin'] = this.cin;
    data['hasRamid'] = this.hasRamid;
    data['hasCnss'] = this.hasCnss;
    data['familySituation'] = this.familySituation;
    data['bloodType'] = this.bloodType;
    data['isAnyNotification'] = this.isAnyNotification;
    data['createdTimeStamp'] = this.createdTimeStamp;
    data['updatedTimeStamp'] = this.updatedTimeStamp;
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
      "isAnyNotification": isAnyNotification,
      "updatedTimeStamp": updatedTimeStamp,
    };
  }
}