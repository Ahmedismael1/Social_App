import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:social/control/cubit.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/add_new_post/add_new_post_Layout.dart';
import 'package:social/layout/feeds/comment_page.dart';
import 'package:social/models/create_post_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/IconBrocen.dart';
import 'package:social/shared/my_widget.dart';

import '../my_profile/my_profile_layout.dart';

class FeedsLayout extends StatelessWidget {
  var commentController=TextEditingController();
  String datetime = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context){

     return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return
            ( SocialCubit.get(context).post.length > 0 &&
                SocialCubit.get(context).userModel != null)?
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Card(
                      color: Colors.grey.shade50,
                      child: Row(
                        children: [

                           CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '${SocialCubit.get(context).userModel.image}')

                            ),

                          Expanded(
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.all(12),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNewPost(
                                              userModel:
                                              SocialCubit.get(context)
                                                  .userModel,
                                            )));
                                  },
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'What\'s in your mind?',
                                      enabled: false,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              IconBroken.Image,
                              size: 28,
                              color: Colors.green,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNewPost(
                                        userModel:
                                        SocialCubit.get(context).userModel,
                                      )));
                            },
                          ),
                          InkWell(
                            child: Icon(
                              IconBroken.Camera,
                              size: 28,
                              color: Colors.black,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNewPost(
                                          userModel:
                                          SocialCubit.get(context).userModel)));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ConditionalBuilder(
                    condition: SocialCubit.get(context).post.length > 0 &&
                        SocialCubit.get(context).userModel != null,
                    builder: (context) => ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => buildNewFeeds(
                            SocialCubit.get(context).post[index],
                            SocialCubit.get(context).userModel,
                            index,
                            context),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 5,
                        ),
                        itemCount: SocialCubit.get(context).post.length),
                    fallback: (context) =>

                        Container(
                            height: 450,
                            child:   Center(
                              child: CircularProgressIndicator(),
                            )
                        ),
                  )
                ],
              ),
            ):
            Center(child: CircularProgressIndicator(),);
        },
      );
    });

  }

  Widget buildNewFeeds(
          CreatePostModel postModel, UserModel userModel, index, context) =>
      Padding(
        padding: EdgeInsets.all(3),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(postModel.profileImage),
                      radius: 24,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${postModel.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(
                            height: 3,
                          ),
                          Text('${postModel.dateTime}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: 10,
              ),
              myDivider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(7),
                    child: Text(
                      "${postModel.text}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (postModel.postImage != '')
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Image(
                        image: NetworkImage(
                          '${postModel.postImage}',
                        ),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            SocialCubit.get(context).likePosts(
                                SocialCubit.get(context).postId[index]);

                          //  FlutterRingtonePlayer.play(fromAsset: "assets/note2.wav");



                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4,),
                              Text("Like")
                            ],
                          ),
                          highlightColor: Colors.blue.shade300,
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            SocialCubit.get(context).getComment(postId:SocialCubit.get(context).postId[index] );

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentPage(postId:   SocialCubit.get(context).postId[index],

                                    )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                IconBroken.Chat,
                                color: Colors.grey.shade700,
                              ),
                              Text("Comment")
                            ],
                          ),
                          highlightColor: Colors.blue.shade300,
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Card(
                      elevation: 0,
                      color: Colors.grey.shade50,
                      child:
                      InkWell(child:
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage('${userModel.image}'),
                          ),
                          Expanded(
                              child: Container(
                                height: 60,
                                padding: EdgeInsets.all(12),
                                child: TextFormField(
                                  enabled: false,
                                  controller: commentController,
                                  decoration: InputDecoration(
                                    labelText: 'Write a comment',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              )),
                          IconButton(onPressed: (){
                            SocialCubit.get(context).getComment(postId:SocialCubit.get(context).postId[index] );

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentPage(postId:   SocialCubit.get(context).postId[index],

                                    )));
                          }, icon:  const Icon(
                            IconBroken.Chat,
                            size: 28,
                            color: Colors.black,
                          ))
                        ],
                      ),
                        onTap: (){
                        print(SocialCubit.get(context).postId[index]);
                        SocialCubit.get(context).getComment(postId:SocialCubit.get(context).postId[index] );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentPage(postId:   SocialCubit.get(context).postId[index],)));
                        },)
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
