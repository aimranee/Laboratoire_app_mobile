
class UserModel{
 String firstName;
 String lastName;
 String uId;
 String city;
 String email;
 String fcmId;
 String imageUrl;
 String pNo;
 String searchByName;
 String age;
 String createdTimeStamp;
 String updateTimeStamp;
 String gender;

  UserModel({
     this.firstName,
     this.lastName,
     this.uId,
     this.city,
     this.email,
     this.fcmId,
     this.imageUrl,
     this.pNo,
     this.searchByName,
     this.age,
     this.createdTimeStamp,
     this.updateTimeStamp,
     this.gender

  });

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      firstName:json['firstName'],
      lastName:json['lastName'],
      uId:json['uId'],
      city:json['city'],
      email:json['email'],
      fcmId:json['fcmId'],
      imageUrl:json['imageUrl'],
      pNo:json['pNo'],
      searchByName:json['searchByName'],
      age:json['age'],
      createdTimeStamp: json['createdTimeStamp'],
      updateTimeStamp:json['updatedTimeStamp'],
        gender:json['gender']

    );
  }

  Map<String,dynamic> toUpdateJson(){
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "city": this.city,
      "age": this.age,
      "email": this.email,
      "imageUrl": this.imageUrl,
      "searchByName":this.searchByName,
      "uId": this.uId,
      "gender":this.gender
    };

  }
}