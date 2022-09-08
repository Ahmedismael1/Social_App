import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/add_new_post/add_new_post_Layout.dart';
import 'package:social/layout/edit_profile/edit_profile.dart';
import 'package:social/models/create_post_model.dart';
import 'package:social/models/user_model.dart';

import '../../control/cubit.dart';
import '../../shared/IconBrocen.dart';
import '../../shared/my_widget.dart';



class UserProfileLayout extends StatelessWidget {

  UserModel userModel;
  UserProfileLayout({this.userModel});
  @override
  Widget build(BuildContext context) {

      return BlocConsumer<SocialCubit,SocialStates>(builder: (context,state)
      {
        var cubit= userModel;
        return WillPopScope(child: SafeArea(child: Scaffold(

          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(3),
              child: Column(children: [
                Container(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Container(
                          height: 190.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                4.0,
                              ),
                              topRight: Radius.circular(
                                4.0,
                              ),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${cubit.cover}'
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      CircleAvatar(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              '${cubit.image}'
                          ),
                          radius: 56,
                        ),
                        backgroundColor: Theme.of(context).backgroundColor,
                        radius: 60,
                      )
                    ],
                  ),
                  height: 240,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${cubit.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${cubit.bio}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Text(
                  '${SocialCubit.get(context).userPost.length} Posts',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 10,),
                ConditionalBuilder(
                  condition: SocialCubit.get(context).userPost.length > 0 ,

                  builder: (context) => ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildProfilePosts(
                          SocialCubit.get(context).userPost[index],
                          index,
                          context),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                      itemCount: SocialCubit.get(context).userPost.length),
                  fallback: (context) =>

                      Container(
                          child:
                          Column(children: [
                            SizedBox(height: 20,),
                            Text('There is no Posts',style: TextStyle(color: Colors.grey,fontSize: 16),)
                          ],)

                      ),
                )

              ]),
            ),
          ),
        )), onWillPop: (){
          SocialCubit.get(context).userPost=[];
          Navigator.pop(context);

        }) ;

      }, listener: (context,state){});

  }
  Widget buildProfilePosts(
      CreatePostModel postModel, index, context) =>
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
                  IconButton(
                    onPressed: () async {},
                    icon: Icon(
                      Icons.more_horiz_outlined,
                      size: 25,
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

                ],
              )
            ],
          ),
        ),
      );
}
