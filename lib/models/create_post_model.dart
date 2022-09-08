class CreatePostModel {
  String name;
  String uId, postImage,text,profileImage,tags,dateTime,dateTimeShow;

  CreatePostModel({this.profileImage,this.dateTime, this.name,this.postImage, this.text, this.uId,this.tags,this.dateTimeShow});

  CreatePostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dateTimeShow = json['dateTimeShow'];
    postImage = json['postImage'];
    text = json['text'];
    profileImage = json['profileImage'];
    uId = json['uId'];
    tags = json['tags'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap(){
    return{
      "name":name,
      "dateTimeShow":dateTimeShow,
      "postImage":postImage,
      "text":text,
      "dateTime":dateTime,
      "profileImage":profileImage,
      "tags":tags,
      "uId":uId

    };
  }
}
