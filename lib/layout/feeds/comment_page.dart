import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/cubit.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/user_profile/user_profile.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/shared/IconBrocen.dart';

class CommentPage extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var postId;

  CommentPage({this.postId});

  var textController = TextEditingController();
  var dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                titleSpacing: 0,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    IconBroken.Arrow___Left_2,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  "Comment",
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
              body: ConditionalBuilder(
                  condition: SocialCubit.get(context).comment.length > 0,
                  builder: (context) => Padding(
                      padding: EdgeInsets.all(8),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context, index) =>
                                        buildComment(
                                            SocialCubit.get(context)
                                                .comment[index],
                                            context),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 15,
                                        ),
                                    itemCount: SocialCubit.get(context)
                                        .comment
                                        .length)),
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.6)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 7,
                                          validator: (val) {
                                            if (val.isEmpty) {
                                              return 'Type Any Thing..';
                                            }
                                            return null;
                                          },
                                          controller: textController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        )),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (formKey.currentState.validate()) {
                                          SocialCubit.get(context).commentPosts(
                                            comment: textController.text,
                                            dateTime: dateTime.toString(),
                                            postId: postId,
                                          );
                                        }

                                        textController.clear();
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.green.withOpacity(0.8),
                                      )),
                                  if (textController.text == null)
                                    IconButton(
                                        icon: Icon(
                                      Icons.send,
                                      color: Colors.green.withOpacity(0.2),
                                    ))
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  fallback: (context) => Padding(
                      padding: EdgeInsets.all(8),
                      child:
                     Form(
                       key: formKey,
                       child:  Container(
                         height: double.infinity,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               'Be the first comment',
                               style:
                               TextStyle(color: Colors.grey, fontSize: 16),
                             ),
                             Spacer(),
                             Container(
                               margin: EdgeInsets.all(5),
                               decoration: BoxDecoration(
                                   border: Border.all(
                                       color: Colors.green.withOpacity(0.6)),
                                   borderRadius:
                                   BorderRadius.all(Radius.circular(20)),
                                   color: Colors.white),
                               child: Row(
                                 children: [
                                   Expanded(
                                     child: Padding(
                                       padding: const EdgeInsets.only(left: 10),
                                       child: TextFormField(
                                         minLines: 1,
                                         maxLines: 7,
                                         validator: (val) {
                                           if (val.isEmpty) {
                                             return 'Type Any Thing..';
                                           }
                                           return null;
                                         },
                                         controller: textController,
                                         decoration: InputDecoration(
                                           border: InputBorder.none,
                                         ),
                                       ),
                                     ),
                                   ),
                                   IconButton(
                                       onPressed: () {
                                         if (formKey.currentState.validate()) {
                                           SocialCubit.get(context).commentPosts(
                                             comment: textController.text,
                                             dateTime: dateTime.toString(),
                                             postId: postId,
                                           );
                                         }

                                         textController.clear();
                                       },
                                       icon: Icon(
                                         Icons.send,
                                         color: Colors.green.withOpacity(0.8),
                                       ))
                                 ],
                               ),
                             )
                           ],
                         ),
                       ),
                     )
                  )));
        },
        listener: (context, state) {});
  }

  Widget buildComment(CommentModel commentModel, context) => Row(children: [
        Padding(
          padding: EdgeInsets.all(2),
          child: CircleAvatar(
            backgroundImage: NetworkImage('${commentModel.image}'),
            radius: 22,
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
            padding: EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${commentModel.name}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  commentModel.comment ?? '',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  commentModel.dateTime,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(.4)),
                ),
              ],
            ),
          ),
        ))
      ]);
}
