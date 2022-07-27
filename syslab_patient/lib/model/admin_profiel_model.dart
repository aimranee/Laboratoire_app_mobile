class AdminProfileModel {
  String uId;
  String firstName;
  String lastName;
  String laboratoireName;
  String pNo1;
  String pNo2;
  String fcmId;
  String email;
  String aboutUs;
  String whatsAppNo;
  String address;

  AdminProfileModel(
      {this.uId,
      this.firstName,
      this.lastName,
      this.laboratoireName,
      this.pNo1,
      this.pNo2,
      this.fcmId,
      this.email,
      this.aboutUs,
      this.whatsAppNo,
      this.address
      });

  AdminProfileModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'].toString();
    firstName = json['firstName'];
    lastName = json['lastName'];
    laboratoireName = json['laboratoireName'];
    pNo1 = json['pNo1'];
    pNo2 = json['pNo2'];
    fcmId = json['fcmId'];
    email = json['email'];
    aboutUs = json['aboutUs'];
    whatsAppNo = json['whatsAppNo'];
    address = json['address'];
  }
}