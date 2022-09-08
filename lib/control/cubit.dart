import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/chats/chats_layout.dart';
import 'package:social/layout/feeds/feeds_layout.dart';
import 'package:social/layout/my_profile/my_profile_layout.dart';
import 'package:social/layout/users/users.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/create_post_model.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    FeedsLayout(),
    ChatLayout(),
    MyProfileLayout(),
  ];
  List<String> titles = [
    "Home",
    "Chat",
    "Profile",
  ];

  void changeScreen(int index) {
    if (index == 1) getUsers();
    currentIndex = index;
    emit(HomeNavBarState());
  }

  UserModel userModel;
  Map CheckData;

  void getUserData() {
    emit(SocialLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(uId);
      print("${value.data()}");
      userModel = UserModel.fromJson(value.data());
      CheckData = value.data();
      emit(SocialSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialErrorState(error: error.toString()));
    });
  }

  File profileFile;
  var picker = ImagePicker();

  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileFile = File(pickedFile.path);
      emit(SocialPickProfileSuccessState());
    } else {
      print('No thing  happen');
      emit(SocialPickProfileErrorState());
    }
  }

  File coverFile;

  Future<void> pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverFile = File(pickedFile.path);
      emit(SocialPickCoverSuccessState());
    } else {
      print('No thing  happen');
      emit(SocialPickCoverErrorState());
    }
  }

  void uploadProfileImage({String name, bio, phone}) {
    emit(SocialUpdateDataLoadingState());
    fs.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileFile.path)
        .pathSegments
        .last}')
        .putFile(profileFile)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateData(profile: value, bio: bio, name: name, phone: phone);
      }).catchError((error) {
        emit(SocialUploadProfileErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileErrorState());
    });
  }

  void uploadCoverImage({String name, bio, phone}) {
    emit(SocialUpdateDataLoadingState());

    fs.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverFile.path)
        .pathSegments
        .last}')
        .putFile(coverFile)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateData(cover: value, bio: bio, name: name, phone: phone);
        print(value);
      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverErrorState());
    });
  }

  void updateData({String name, bio, phone, profile, cover}) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: userModel.email,
      uId: userModel.uId,
      cover: cover ?? userModel.cover,
      image: profile ?? userModel.image,
      bio: bio,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateDataErrorState());
    });
  }

  File postImageFile;

  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);
      emit(SocialPickPostImageSuccessState());
    } else {
      print('No thing  happen');
      emit(SocialPickPostImageErrorState());
    }
  }

  void removePostImage() {
    postImageFile = null;
    emit(SocialRemovePostImageSuccessState());
  }

  void uploadPostImage({
    String dateTime,
    dateTimeShow,
    text,
  }) {
    emit(SocialCreatePostImageLoadingState());

    fs.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file(postImageFile.path)
        .pathSegments
        .last}')
        .putFile(postImageFile)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, dateTime: dateTime, postImage: value,dateTimeShow: dateTimeShow);
        createPostForCurrentUser(text: text, dateTime: dateTime, postImage: value,dateTimeShow: dateTimeShow);
        print(value);
      }).catchError((error) {
        emit(SocialCreatePostImageErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostImageErrorState());
    });
  }

  void createPostForCurrentUser({String text, postImage, dateTime, tags,dateTimeShow}) {
    emit(SocialCreatePostForCurrentUserLoadingState());
    CreatePostModel model = CreatePostModel(
        name: userModel.name,
        dateTimeShow: dateTimeShow,
        uId: userModel.uId,
        dateTime: dateTime,
        postImage: postImage ?? '',
        profileImage: userModel.image,
        text: text ?? '',
        tags: tags ?? "");
    FirebaseFirestore.instance
        .collection('userPosts').doc(uId).collection('myPost').add(
        model.toMap())
        .then((value) {
      emit(SocialCreatePostForCurrentUserSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostForCurrentUserErrorState());
    });
  }

  void createPost({String text, postImage, dateTime, tags,dateTimeShow}) {
    emit(SocialCreatePostLoadingState());
    CreatePostModel model = CreatePostModel(
        name: userModel.name,
        dateTimeShow: dateTimeShow,
        uId: userModel.uId,
        dateTime: dateTime,
        postImage: postImage ?? '',
        profileImage: userModel.image,
        text: text ?? '',
        tags: tags ?? "");
    FirebaseFirestore.instance
        .collection('allPosts').add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      print('done');
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<CreatePostModel> post = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> commentCont = [];
  List<CreatePostModel> myPost = [];
  List<String> myPostId = [];
  List<int> myLikes = [];
  List<CreatePostModel> userPost = [];
  List<String> userPostId = [];
  List<int> userLikes = [];

  void sendMessage({String message, receiverId, dateTime, dateTimeChat,type}) {
    MessageModel messageModel = MessageModel(
        dateTime: dateTime,
        message: message,
        receiverId: receiverId,
        senderId: userModel.uId,
        dateTimeChat: dateTimeChat,
        type: type
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialReceiverMessageSuccessState());
    }).catchError((error) {
      emit(SocialReceiverMessageErrorState());
    });
  }



  FlutterAudioRecorder2  audioRecorder;
   String  filePath;
   bool isPlaying = false;
   bool isUploading = false;
   bool isRecorded = false;
   bool isRecording = false;
   bool isRecordPlaying=false;
   AudioPlayer audioPlayer = AudioPlayer();
   String voiceUrl = '';
  int selectedIndex=-1;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  Future<void>  onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

       isUploading = true;
       emit(SocialUploadingVoiceLoadingState());
    try {
      await firebaseStorage
          .ref('upload-voice-firebase')
          .child(
           filePath.substring( filePath.lastIndexOf('/'),  filePath.length))
          .putFile(File( filePath))
          .then((value) {
        value.ref.getDownloadURL().then((value) {
            voiceUrl = value;
          print(value);
            emit(SocialUploadingVoiceSuccessState());

        });

      });
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      emit(SocialUploadingVoiceErrorState());
    } finally {

         isUploading = false;
        emit(SocialUploadingVoiceFinallyState());
    }
  }

  Future<void> messageButtonPressed(int index,voice) async {

      selectedIndex = index;
      if(! isRecordPlaying) {
        isRecordPlaying=true;
        audioPlayer.play(DeviceFileSource(voice));
        isRecordPlaying=false;
        emit(SocialPlayVoiceMessageState());
      }else{
        audioPlayer.pause();
        isRecordPlaying = false;
        emit(SocialStopPlayRecorderSuccessState());
      }
    audioPlayer.onPlayerComplete.listen((duration) {
        selectedIndex = -1;
        position=Duration.zero;
        isRecordPlaying=false;
        emit(SocialStopVoiceMessageState());
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      duration=newDuration;
      emit(SocialDurationVoiceMessageState());
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      position=newPosition;
      emit(SocialPositionVoiceMessageState());
    });
  }

  void  onRecordAgainButtonPressed() {

       isRecorded = false;
  emit(SocialStartRecorderAgainSuccessState());
  }

  Future<void>  onRecordButtonPressed(context) async {
    if ( isRecording) {
       audioRecorder.stop();
       isRecording = false;
       isRecorded = true;
       emit(SocialStopRecorderSuccessState());
    } else {
       isRecorded = false;
       isRecording = true;

      await  startRecording(context);
      emit(SocialStartRecorderSuccessState());
    }
  }

  void  onRecorderPlayButtonPressed() {
    if (! isPlaying) {
       isPlaying = true;

       audioPlayer.play(DeviceFileSource( filePath));
       audioPlayer.onPlayerComplete.listen((duration) {

           isPlaying = false;
        });
       emit(SocialStartPlayRecorderSuccessState());
    } else {
       audioPlayer.pause();
       isPlaying = false;
       emit(SocialStopPlayRecorderSuccessState());

    }
  }

  Future<void>  startRecording(context) async {
    final bool hasRecordingPermission =
    await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
       audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
      await  audioRecorder.initialized;
       audioRecorder.start();
       filePath = filepath;
       emit(SocialSaveRecorderPathSuccessState());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
      emit(SocialSaveRecorderPathErrorState());

    }
  }



  List<MessageModel> messages = [];

  void getMessage({String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {

        messages.add(MessageModel.fromJson(element.data()));

      });
      emit(SocialGetMessageSuccessState());
    });
  }

  void getAllPosts() {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('allPosts').orderBy('dateTimeShow').snapshots().listen((value){
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          postId.add(element.id);
          likes.add(value.docs.length);
          post.add(CreatePostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostSuccessState());
    });
  }


  void getMyPosts(uid) {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('userPosts').doc(uid).collection(
        'myPost').orderBy('dateTimeShow').snapshots().listen((value){
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          myPostId.add(element.id);
          myLikes.add(value.docs.length);
          myPost.add(CreatePostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostSuccessState());
    });
  }

  void getUserPosts(uid) {
    print('111111');

    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('userPosts').doc(uid).collection(
        'myPost').get().
    then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          userPostId.add(element.id);
          userLikes.add(value.docs.length);
          userPost.add(CreatePostModel.fromJson(element.data()));
          emit(SocialGetPostSuccessState());
        }).catchError((error) {});
      });
    }).catchError((error) {
      emit(SocialGetPostErrorState());
    });
  }

  void likePosts(String postId) {
    FirebaseFirestore.instance
        .collection('allPosts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState());
    });
  }


  List<UserModel> users = [];
  List usersName = [];
  UserModel usersModel = UserModel();

  void getUsers() {
    if (users.length == 0) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId)
            users.add(UserModel.fromJson(element.data()));
        });


        emit(SocialGetAllUserSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUserErrorState());
      });
    }
  }

  void commentPosts({String comment, postId, dateTime}) {
    CommentModel commentModel = CommentModel(
      dateTime: dateTime,
      comment: comment,
      postId: postId,
      senderId: userModel.uId,
      name: userModel.name,
      image: userModel.image,

    );
    FirebaseFirestore.instance
        .collection('allPosts')
        .doc(postId)
        .collection('comments')
        .doc(userModel.uId).collection('comment')
        .add(commentModel.toMap()).then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState());
    });
  }



  List<CommentModel> comment = [];

  void getComment({String postId}) {
    FirebaseFirestore.instance
        .collection('allPosts')
        .doc(postId)
        .collection('comments')
        .doc(userModel.uId)
        .collection('comment')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comment = [];
      event.docs.forEach((element) {
        comment.add(CommentModel.fromJson(element.data()));
        // print(messages);
      });
      //print(messages);
      emit(SocialGetCommentSuccessState());
    });
  }
}
