import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/cubit.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/chats/chat_page.dart';
import 'package:social/layout/chats/home_page.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/my_widget.dart';

class ChatLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) =>
                buildChatItem(SocialCubit.get(context).users[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: SocialCubit.get(context).users.length);
      },
    );
  }

}
Widget buildChatItem(UserModel userModel, context) => InkWell(
  onTap: () {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
              model: userModel,

            ))); // Update the state of the app.
    SocialCubit.get(context).getMessage(receiverId: userModel.uId);
  },
  child: Padding(
    padding: EdgeInsets.all(15),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.all(2),
          child: CircleAvatar(
            backgroundImage: NetworkImage(userModel.image),
            radius: 27,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userModel.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);
