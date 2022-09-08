import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/cubit.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/feeds/feeds_layout.dart';
import 'package:social/layout/my_profile/my_profile_layout.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/IconBrocen.dart';

class AddNewPost extends StatelessWidget {
  var textController = TextEditingController();
  var now = DateTime.now();
  var dateTimeShow = DateTime.now().millisecondsSinceEpoch;
  UserModel userModel;

  AddNewPost({this.userModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if(state is SocialCreatePostSuccessState) {
            SocialCubit.get(context).post.length=0;
            SocialCubit.get(context).getAllPosts();

            SocialCubit.get(context).myPost.length=0;
            SocialCubit.get(context).getMyPosts(userModel.uId);
            Navigator.pop(context);
          }

        },
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    titleSpacing: 0,
                    leading: IconButton(icon: Icon(IconBroken.Arrow___Left_2,color: Colors.black,),
                    onPressed: (){


                      SocialCubit.get(context).post.length=0;
                      SocialCubit.get(context).getAllPosts();

                      Navigator.pop(context);
                    },
                    ),
                    title: Text(
                      'Add New Post',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    actions: [
                      TextButton(
                          onPressed: () async {
                            if (SocialCubit.get(context).postImageFile ==
                                null) {
                              SocialCubit.get(context).createPost(
                                dateTime: now.toString(),
                                text: textController.text,
                                dateTimeShow: dateTimeShow.toString()
                              );  SocialCubit.get(context).createPostForCurrentUser(
                                dateTime: now.toString(),
                                text: textController.text,
                                dateTimeShow: dateTimeShow.toString()
                              );
                            } else {
                              SocialCubit.get(context).uploadPostImage(
                                dateTimeShow: dateTimeShow.toString(),
                                dateTime: now.toString(),
                                text: textController.text,
                              );
                            }
                            var image = SocialCubit.get(context).postImageFile;
                            var decodedImage = await decodeImageFromList(
                                image.readAsBytesSync());
                            print(decodedImage.width.bitLength);
                            print(decodedImage.height.bitLength);




                          },
                          child: Text(
                            'Post',
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                  backgroundColor: Colors.white,
                  body: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        if (state is SocialCreatePostImageLoadingState || state is SocialCreatePostForCurrentUserLoadingState)
                          LinearProgressIndicator(),
                        if (state is SocialCreatePostImageLoadingState|| state is SocialCreatePostForCurrentUserLoadingState)
                          SizedBox(
                            height: 5,
                          ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(2),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage('${userModel.image}'),
                                radius: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('${userModel.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        TextFormField(
                          controller: textController,
                          minLines: 1,
                          decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'What is in your mind..'),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Center(
                              child: TextButton(
                                  onPressed: () {
                                    SocialCubit.get(context).pickPostImage();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Icon(IconBroken.Image),
                                      Text('Select Image'),
                                    ],
                                  )),
                            )),
                          ],
                        ),
                        if (SocialCubit.get(context).postImageFile != null)
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(7),
                                child: Image(
                                  image: FileImage(
                                      SocialCubit.get(context).postImageFile),
                                  height: 450,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              CircleAvatar(
                                child: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).removePostImage();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 14,
                                  ),
                                ),
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                radius: 14,
                              )
                            ],
                          ),
                      ],
                    ),
                  )));
        });
  }
}
