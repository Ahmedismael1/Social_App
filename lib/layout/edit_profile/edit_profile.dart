import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social/layout/my_profile/my_profile_layout.dart';
import 'package:social/shared/IconBrocen.dart';
import 'package:social/shared/reusables/reusable_text_filed.dart';

import '../../control/cubit.dart';
import '../../control/states.dart';

class EditProfile extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(builder: (context, state) {
      var cubit = SocialCubit.get(context).userModel;
      var profileImage = SocialCubit.get(context).profileFile;
      var coverImage = SocialCubit.get(context).coverFile;
      nameController.text = cubit.name;
      bioController.text = cubit.bio;
      phoneController.text = cubit.phone;
      return WillPopScope(
        onWillPop: (){
          SocialCubit.get(context).profileFile = null;
          SocialCubit.get(context).coverFile = null;
          print('${ SocialCubit.get(context).profileFile}');
          Navigator.pop(context);},
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading:IconButton(
                onPressed: (){
                SocialCubit.get(context).profileFile = null;
                SocialCubit.get(context).coverFile = null;
                print('${ SocialCubit.get(context).profileFile}');
                Navigator.pop(context); // Update the state of the app.

              },icon:  Icon(
                IconBroken.Arrow___Left_2,
                color: Colors.black,
              ),),
              actions: [
                TextButton(
                    onPressed: () {

                      SocialCubit.get(context).updateData(
                          phone: phoneController.text,
                          name: nameController.text,
                          bio: bioController.text);
                      SocialCubit.get(context).profileFile = null;
                      SocialCubit.get(context).coverFile = null;
                      print('${ SocialCubit.get(context).profileFile}');
                      Navigator.pop(context);

                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ))
              ],
              centerTitle: true,
              title: const Text(
                'Edit your profile',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(3),
              child: SingleChildScrollView(child:
              Column(
                  children: [
                    if (state is SocialUpdateDataLoadingState) LinearProgressIndicator(),
                    if (state is SocialUpdateDataLoadingState)
                      SizedBox(
                        height: 3,
                      ),
                    Container(
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
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
                                      image: coverImage == null
                                          ? NetworkImage('${cubit.cover}')
                                          : FileImage(coverImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    child: IconButton(
                                      onPressed: () {
                                        FocusScopeNode currentFocus = FocusScope.of(context);

                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        SocialCubit.get(context).pickCoverImage();
                                      },
                                      icon: Icon(
                                        IconBroken.Camera,
                                        size: 18,
                                      ),
                                    ),
                                    backgroundColor: Colors.blue.withOpacity(0.6),
                                    radius: 16,
                                  ),
                                )
                              ],
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: profileImage == null
                                          ? NetworkImage('${cubit.image}')
                                          : FileImage(profileImage),
                                      radius: 56,
                                    ),
                                    CircleAvatar(
                                      child: IconButton(
                                        onPressed: () {
                                          FocusScopeNode currentFocus = FocusScope.of(context);

                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          SocialCubit.get(context).pickProfileImage();
                                        },
                                        icon: Icon(
                                          IconBroken.Camera,
                                          size: 14,
                                        ),
                                      ),
                                      backgroundColor: Colors.blue.withOpacity(0.8),
                                      radius: 14,
                                    )
                                  ],
                                ),
                                backgroundColor: Theme.of(context).backgroundColor,
                                radius: 60,
                              ),
                            ],
                          ),
                        ],
                      ),
                      height: 240,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    if (SocialCubit.get(context).profileFile != null ||
                        SocialCubit.get(context).coverFile != null)
                      Row(
                        children: [
                          if (SocialCubit.get(context).profileFile != null)
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    SocialCubit.get(context).uploadProfileImage(bio: bioController.text,name: nameController.text,phone: phoneController.text);
                                    if (SocialCubit.get(context).CheckData ==null) {
                                      Fluttertoast.showToast(
                                          msg: 'Please wait',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }

                                  }, style: TextButton.styleFrom(backgroundColor: Colors.blue),
                                  child: Text('Update Profile',style: TextStyle(color: Colors.white,fontSize: 20),)),
                            ),
                          SizedBox(
                            width: 7,
                          ),
                          if (SocialCubit.get(context).coverFile != null)
                            Expanded(
                              child: TextButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.green),

                                  onPressed: () {

                                    SocialCubit.get(context).uploadCoverImage(bio: bioController.text,name: nameController.text,phone: phoneController.text);
                                    if (state is SocialSuccessState) {
                                      Fluttertoast.showToast(
                                          msg: 'Please wait',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Text('Update Cover',style: TextStyle(color: Colors.white,fontSize: 20),)),
                            ),
                        ],
                      ),
                    SizedBox(
                      height: 18,
                    ),
                    ReusableTextFiled(
                      validator: (value) {},
                      textController: nameController,
                      prefixIcon: Icon(IconBroken.User1),
                      labelText: 'Name',
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    ReusableTextFiled(
                      validator: (value) {},
                      textController: bioController,
                      prefixIcon: Icon(IconBroken.Paper),
                      labelText: 'Bio',
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    ReusableTextFiled(
                      validator: (value) {},
                      textController: phoneController,
                      prefixIcon: Icon(IconBroken.Call),
                      textInputType: TextInputType.phone,
                      labelText: 'Phone',
                    ),
                  ])),
            ),
          )),
   );
    }, listener: (context, state) {
      // if (state is SocialSuccessState) {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               SettingLayout())); // Update the state of the app.
      //
      // }
    });
  }
}
