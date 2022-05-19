class DrProfileModel {
  String firstName;
  String lastName;
  String email;
  String dNo1;
  String dNo2;
  String description;
  String whatsAppNo;
  String subTitle;
  String profileImageUrl;
  String address;
  String aboutUs;
  String fdmId;
  String id;

  DrProfileModel({
    this.firstName,
    this.lastName,
    this.email,
    this.dNo1,
    this.dNo2,
    this.description,
    this.whatsAppNo,
    this.subTitle,
    this.profileImageUrl,
    this.address,
    this.aboutUs,
    this.fdmId,
    this.id
  });

  factory DrProfileModel.fromJson(Map<String, dynamic> json){
    return DrProfileModel(

        firstName: json['firstName'],
        lastName: json['lastName'],
        dNo1: json['dNo1'],
        dNo2: json['dNo2'],
        email: json['email'],
        subTitle: json['subTitle'],
        description: json['description'],
        whatsAppNo: json['whatsAppNo'],
        profileImageUrl: json['profileImageUrl'],
        address: json['address'],
        aboutUs: json['aboutUs'],
        fdmId: json['fcmId'],
        id: json['id']
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "dNo1": dNo1,
      "dNo2": dNo2,
      "description": description,
      "whatsAppNo": whatsAppNo,
      "subTitle": subTitle,
      "profileImageUrl": profileImageUrl,
      "address": address,
      "aboutUs": aboutUs,
      "id": id
    };
  }

}