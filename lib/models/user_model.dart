class UserModel {
  String name;
  String uId, phone, email,bio,image,cover;

  UserModel({this.email, this.name,this.cover, this.phone, this.uId,this.bio,this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    uId = json['uId'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toMap(){
    return{
    "name":name,
    "cover":cover,
    "image":image,
    "bio":bio,
      "phone":phone,
      "email":email,
      "uId":uId

    };
  }
}
