class AdminModel {
  String uId;
  String firstName;
  String lastName;
  String laboratoireName;
  String pNo1;
  String pNo2;
  String email;
  String password;
  String aboutUs;
  String fcmId;
  String whatsAppNo;
  String isAnyNotification;
  String address;
  String createdTimeStamp;
  String updatedTimeStamp;

  AdminModel(
      {this.uId,
      this.firstName,
      this.lastName,
      this.laboratoireName,
      this.pNo1,
      this.pNo2,
      this.email,
      this.password,
      this.aboutUs,
      this.fcmId,
      this.whatsAppNo,
      this.updatedTimeStamp,
      this.isAnyNotification,
      this.address});

  AdminModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'].toString();
    firstName = json['firstName'];
    lastName = json['lastName'];
    laboratoireName = json['laboratoireName'];
    pNo1 = json['pNo1'];
    pNo2 = json['pNo2'];
    email = json['email'];
    // password = json['password'];
    aboutUs = json['aboutUs'];
    fcmId = json['fcmId'];
    whatsAppNo = json['whatsAppNo'];
    isAnyNotification = json['isAnyNotification'];
    address = json['address'];
    createdTimeStamp = json['createdTimeStamp'];
    updatedTimeStamp = json['updatedTimeStamp'];
  }

  Map<String,dynamic> toUpdateJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "laboratoireName": laboratoireName,
      "pNo1": pNo1,
      "pNo2": pNo2,
      "email": email,
      "aboutUs":aboutUs,
      "whatsAppNo":whatsAppNo,
      "address":address,
      "updatedTimeStamp": updatedTimeStamp,
      "uId": uId
    };

  }
}