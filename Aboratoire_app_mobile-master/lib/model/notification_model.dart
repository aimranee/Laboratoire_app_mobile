
class NotificationModel{
  String body;
  String routeTo;
  String sendBy;
  String sendFrom;
  String sendTo;
  String title;
  String uId;
  String createdTimeStamp;

  NotificationModel({
    this.body,
    this.title,
    this.uId,
    this.routeTo,
    this.sendTo,
    this.createdTimeStamp,
    this.sendBy,
    this.sendFrom,

  });

  factory NotificationModel.fromJson(Map<String,dynamic> json){
    return NotificationModel(
      title:json['title'],
      body:json['body'],
      sendFrom:json['sendFrom'],
      sendBy:json['sendBy'],
      sendTo:json['sendTo'],
      routeTo:json['routeTo'],
      uId:json['uId'],
      createdTimeStamp:json['createdTimeStamp']

    );
  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "title":title,
      "body":body,
      "sendFrom":sendFrom,
      "sendBy":sendBy,
      "sendTo":sendTo,
      "routeTo":routeTo,
      "uId":uId
    };
  }
  Map<String,dynamic> toJsonAddForAdmin(){
    return {
      "title":title,
      "body":body,
      "sendBy":sendBy,
      "uId":uId
    };

  }
}