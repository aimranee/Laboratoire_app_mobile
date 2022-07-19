class AdminProfileModel {
  String uId;
  String firstName;
  String lastName;
  String aNo1;
  String aNo2;
  String email;
  String password;
  String profileImageUrl;
  String subTitle;
  String description;
  String fcmId;
  String whatsAppNo;
  String updatedTimeStamp;
  String isAnyNotification;
  String address;

  AdminProfileModel(
      {this.uId,
      this.firstName,
      this.lastName,
      this.aNo1,
      this.aNo2,
      this.email,
      this.password,
      this.profileImageUrl,
      this.subTitle,
      this.description,
      this.fcmId,
      this.whatsAppNo,
      this.updatedTimeStamp,
      this.isAnyNotification,
      this.address});

  AdminProfileModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'].toString();
    firstName = json['firstName'];
    lastName = json['lastName'];
    aNo1 = json['aNo1'];
    aNo2 = json['aNo2'];
    email = json['email'];
    password = json['password'];
    profileImageUrl = json['profileImageUrl'].toString();
    subTitle = json['subTitle'];
    description = json['description'];
    fcmId = json['fcmId'];
    whatsAppNo = json['whatsAppNo'];
    updatedTimeStamp = json['updatedTimeStamp'];
    isAnyNotification = json['isAnyNotification'];
    address = json['address'];
  }

  Map<String,dynamic> toUpdateJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "aNo1": aNo1,
      "aNo2": aNo2,
      "email": email,
      "subTitle": subTitle,
      "description":description,
      "whatsAppNo":whatsAppNo,
      "address":address,
      "isAnyNotification":isAnyNotification
    };

  }
}