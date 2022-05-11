class DrProfileModel {
  String firstName;
  String lastName;
  String email;
  String pNo1;
  String pNo2;
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
    this.pNo1,
    this.pNo2,
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
        pNo1: json['pNo1'],
        pNo2: json['pNo2'],
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
      "pNo1": pNo1,
      "pNo2": pNo2,
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