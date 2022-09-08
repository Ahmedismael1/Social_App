import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:social/control/cubit.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/user_profile/user_profile.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/user_model.dart';

import '../../shared/IconBrocen.dart';

class ChatPage extends StatelessWidget {
  var textController = TextEditingController();
  String message;
  var dateTime = DateTime.now().millisecondsSinceEpoch;
  String dateTimeChat = DateFormat("hh:mm a").format(DateTime.now());
  UserModel model;
  var formKey = GlobalKey<FormState>();

  ChatPage({this.model});

  @override
  Widget build(BuildContext context) {
    var cubit=  SocialCubit.get(context);

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
        title: InkWell(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundImage: NetworkImage('${model.image}'),
                  radius: 17,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${model.name}',
                style: const TextStyle(color: Colors.black),
              )
            ],
          ),
          onTap: () async{
            cubit.getUserPosts(model.uId);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileLayout(
                      userModel: model,
                    ))); // Update the
            print( model.name);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body:    BlocConsumer< SocialCubit, SocialStates>(
    listener: (context, state){
      if(state is SocialUploadingVoiceSuccessState) {
        cubit  .sendMessage(
            receiverId: model.uId,
            message: cubit.voiceUrl,
            dateTime: dateTime.toString(),
            dateTimeChat: dateTimeChat,
            type: 'voice'
        );
      }

    },

          builder: (context, state){
            return  ConditionalBuilder(
                condition:  cubit.messages.length > 0,
                builder: (context) =>
                    Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                             Expanded(
                                      child: ListView.separated(
                                          itemBuilder: (context, index) {
                                            var messages =  cubit
                                                .messages[index];

                                            if ( cubit
                                                .userModel
                                                .uId ==
                                                messages.senderId) {
                                              return buildMyMessage(messages,context,index);
                                            } else {
                                              return buildMessage(messages,context,index);
                                            }
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                height: 5,
                                              ),
                                          itemCount:  cubit
                                              .messages
                                              .length)),
                              cubit.isRecorded?
                              cubit.isUploading?
                              Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.green.withOpacity(0.6)),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white),
                                  child:   const Text('Uplaoding to Firebase')
                              ):
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green.withOpacity(0.6)),
                                    borderRadius:
                                    const BorderRadius.all(const Radius.circular(20)),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.restore_from_trash, color: Colors.red.withOpacity(0.8),),
                                      onPressed: (){cubit.onRecordAgainButtonPressed();},
                                    ),
                                    IconButton(
                                      icon: Icon(cubit.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.green[900].withOpacity(0.8),size: 35,),
                                      onPressed: (){cubit.onRecorderPlayButtonPressed();},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send, color: Colors.green.withOpacity(0.8),),
                                      onPressed: (){
                                        cubit.onFileUploadButtonPressed();
                                          if(state is SocialUploadingVoiceSuccessState) {
                                            cubit  .sendMessage(
                                                receiverId: model.uId,
                                                message: cubit.voiceUrl,
                                                dateTime: dateTime.toString(),
                                                dateTimeChat: dateTimeChat,
                                                type: 'voice'
                                            );
                                          }


                                      },
                                    ),
                                  ],
                                ),
                              ):
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green.withOpacity(0.6)),
                                    borderRadius:
                                    const BorderRadius.all( Radius.circular(20)),
                                    color: Colors.white),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        cubit.onRecordButtonPressed(context);
                                        },
                                      icon: cubit.isRecording
                                          ? Icon(Icons.stop, color: Colors.red.withOpacity(0.8),size: 25,)
                                          : Icon(Icons.mic, color: Colors.green.withOpacity(0.8),size: 25,),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: TextFormField(

                                            validator: (val){
                                              if (val.isEmpty) {
                                                return 'Type Any Thing..' ;
                                              }
                                              return null;
                                            },
                                            minLines: 1,
                                            maxLines: 7,

                                            controller: textController,
                                            decoration: const InputDecoration(
                                              hintText: 'send',

                                              border: InputBorder.none,
                                            ),
                                          )
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {

                                          if(formKey.currentState.validate()){
                                            cubit  .sendMessage(
                                                receiverId: model.uId,
                                                message: textController.text,
                                                dateTime: dateTime.toString(),
                                                dateTimeChat: dateTimeChat,
                                                type: 'text'
                                            );

                                          }



                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: Colors.green.withOpacity(0.8),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                fallback: (context) =>
                    Form(
                        key: formKey,
                        child:  Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Start Chat',style: TextStyle(color: Colors.grey,fontSize: 16),),



                                  const Spacer(),
                                  cubit.isRecorded?
                                  cubit.isUploading?
                                  Container(
                                    height: 50,
                                      width: MediaQuery.of(context).size.width*0.85,
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.green.withOpacity(0.6)),
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(20)),
                                          color: Colors.white),
                                      child:   const Text('Uploading')
                                  ):
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.green.withOpacity(0.6)),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.restore_from_trash, color: Colors.red.withOpacity(0.8),),
                                          onPressed: (){cubit.onRecordAgainButtonPressed();},
                                        ),
                                        IconButton(
                                          icon: Icon(cubit.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.green[900].withOpacity(0.8),size: 35,),
                                          onPressed: (){cubit.onRecorderPlayButtonPressed();},
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.send, color: Colors.green.withOpacity(0.8),),
                                          onPressed: (){
                                            cubit.onFileUploadButtonPressed();
                                            if(state is SocialUploadingVoiceSuccessState) {
                                              cubit  .sendMessage(
                                                  receiverId: model.uId,
                                                  message: cubit.voiceUrl,
                                                  dateTime: dateTime.toString(),
                                                  dateTimeChat: dateTimeChat,
                                                  type: 'voice'
                                              );
                                            }


                                          },
                                        ),
                                      ],
                                    ),
                                  ):
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.green.withOpacity(0.6)),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: (){
                                            cubit.onRecordButtonPressed(context);
                                          },
                                          icon: cubit.isRecording
                                              ? Icon(Icons.stop, color: Colors.red.withOpacity(0.8),size: 25,)
                                              : Icon(Icons.mic, color: Colors.green.withOpacity(0.8),size: 25,),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: TextFormField(

                                                validator: (val){
                                                  if (val.isEmpty) {
                                                    return 'Type Any Thing..' ;
                                                  }
                                                  return null;
                                                },
                                                minLines: 1,
                                                maxLines: 7,

                                                controller: textController,
                                                decoration: const InputDecoration(
                                                  hintText: 'send',

                                                  border: InputBorder.none,
                                                ),
                                              )
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {

                                              if(formKey.currentState.validate()){
                                                cubit  .sendMessage(
                                                    receiverId: model.uId,
                                                    message: textController.text,
                                                    dateTime: dateTime.toString(),
                                                    dateTimeChat: dateTimeChat,
                                                    type: 'text'
                                                );

                                              }



                                            },
                                            icon: Icon(
                                              Icons.send,
                                              color: Colors.green.withOpacity(0.8),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )))
            ); },

      )


    );
  }

  Widget buildMessage(MessageModel messageModel,index,context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: const Radius.circular(
                10.0,
              ),
              topStart: const Radius.circular(
                10.0,
              ),
              topEnd: const Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (messageModel.type=='text')?
              Text(
                messageModel.message??'',
                style: const TextStyle(fontSize: 16),
              ):
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${model.image}'),
                      radius: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        child: SocialCubit.get(context).selectedIndex == index
                            ? const Icon(Icons.pause,size: 35,)
                            : const Icon(Icons.play_arrow,size: 35),
                        onTap: () =>SocialCubit.get(context).messageButtonPressed(index,messageModel.message),
                      ),
                    ),
                    SocialCubit.get(context).selectedIndex == index?
                    Slider(
                        divisions: 10,

                        value: SocialCubit.get(context).position.inSeconds.toDouble(),
                        min: 0,
                        max:SocialCubit.get(context).duration.inSeconds.toDouble() ,
                        onChanged: (value)async{
                          SocialCubit.get(context).position=Duration(seconds: value.toInt());
                          await AudioPlayer().seek( SocialCubit.get(context).position);
                        }):
                    Slider(value: 0,
                        min: 0,
                        max:SocialCubit.get(context).duration.inSeconds.toDouble() ,
                        onChanged: (value)async{
                          SocialCubit.get(context).position=Duration(seconds: value.toInt());
                          await AudioPlayer().seek( SocialCubit.get(context).position);
                        }),

                  ],
                ),
              ),
              Text(
                messageModel.dateTimeChat,
                style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.4)),
              ),
            ],)
        ),
      );

  Widget buildMyMessage(MessageModel messageModel,context,index) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsets.only(left: 38.0,top: 10,right: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(
                .2,
              ),
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(
                  10.0,
                ),
                topStart: const Radius.circular(
                  10.0,
                ),
                topEnd: const Radius.circular(
                  10.0,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                (messageModel.type=='text')?
                Text(
                  messageModel.message??'',
                  style: const TextStyle(fontSize: 16),
                ):
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('${model.image}'),
                        radius: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          child: SocialCubit.get(context).selectedIndex == index
                              ? const Icon(Icons.pause,size: 35,)
                              : const Icon(Icons.play_arrow,size: 35),
                          onTap: () =>SocialCubit.get(context).messageButtonPressed(index,messageModel.message),
                        ),
                      ),
                      SocialCubit.get(context).selectedIndex == index?
                      Slider(
                          divisions: 10,

                          value: SocialCubit.get(context).position.inSeconds.toDouble(),
                          min: 0,
                          max:SocialCubit.get(context).duration.inSeconds.toDouble() ,
                          onChanged: (value)async{
                         SocialCubit.get(context).position=Duration(seconds: value.toInt());
                        await AudioPlayer().seek( SocialCubit.get(context).position);
                          }):
                      Slider(value: 0,
                          min: 0,
                          max:SocialCubit.get(context).duration.inSeconds.toDouble() ,
                          onChanged: (value)async{
                            SocialCubit.get(context).position=Duration(seconds: value.toInt());
                            await AudioPlayer().seek( SocialCubit.get(context).position);
                          }),

                    ],
                  ),
                ),
                Text(
                messageModel.dateTimeChat,
                style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.4)),
              ),
            ],)
          ),
        ),
      );


}
