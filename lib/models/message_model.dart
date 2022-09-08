class MessageModel {
  String senderId,receiverId,dateTime,message,dateTimeChat,type;
  MessageModel({this.message,this.dateTime, this.senderId,this.receiverId,this.dateTimeChat,this.type});

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    type = json['type'];
    dateTimeChat = json['dateTimeChat'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    message = json['message'];
  }

  Map<String, dynamic> toMap(){
    return{
      "senderId":senderId,
      "type":type,
      "dateTimeChat":dateTimeChat,
      "receiverId":receiverId,
      "dateTime":dateTime,
      "message":message,


    };
  }
}
