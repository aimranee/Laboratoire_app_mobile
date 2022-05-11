// ignore: file_names
class UserModel{
  String firstName;
  String lastName;
  String uId;
  String city;
  String email;
  String fcmId;
  String pNo;
  String searchByName;
  String age;
  String gender;
  String createdDate;

  UserModel({
    this.firstName,
    this.lastName,
    this.uId,
    this.city,
    this.email,
    this.fcmId,
    this.pNo,
    this.searchByName,
    this.age,
    this.gender,
    this.createdDate

  });

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      firstName:json['firstName'],
      lastName:json['lastName'],
      uId:json['uId'],
      city:json['city'],
      email:json['email'],
      fcmId:json['fcmId'],
      pNo:json['pNo'],
      searchByName:json['searchByName'],
      age:json['age'],
        gender: json['gender'],
        createdDate:json['createdTimeStamp']

    );
  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "uId": uId,
      "city": city,
      "email": email,
      "fcmId": fcmId,
      "pNo": pNo,
      "searchByName":searchByName,
      "age": age,
      "gender":gender
    };

  }
  Map<String,dynamic> toUpdateJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "city": city,
      "age": age,
      "email": email,
      "searchByName":searchByName,
      "uId": uId,
      "gender":gender
    };

  }
}