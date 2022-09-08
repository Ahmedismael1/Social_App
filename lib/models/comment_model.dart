class CommentModel {
  String senderId,postId,dateTime,comment,name,image;
  CommentModel({this.comment,this.dateTime, this.senderId,this.postId,this.image,this.name});

  CommentModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    image = json['image'];
    name = json['name'];
    postId = json['postId'];
    dateTime = json['dateTime'];
    comment = json['comment'];
  }

  Map<String, dynamic> toMap(){
    return{
      "senderId":senderId,
      "image":image,
      "name":name,
      "postId":postId,
      "dateTime":dateTime,
      "comment":comment,


    };
  }
}
