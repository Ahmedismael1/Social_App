import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/cubit.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/login/login_layout.dart';
import 'package:social/layout/my_profile/my_profile_layout.dart';
import 'package:social/layout/search/search_test.dart';

import '../../shared/IconBrocen.dart';
import '../../shared/shared_preferences.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

             return BlocConsumer<SocialCubit, SocialStates>(
               listener: (context, state) {},
               builder: (context, state) {
                 var cubit = SocialCubit.get(context);
                 return SafeArea(
                     child: Scaffold(
                       drawer: Drawer(
                         elevation: 10,
                         child: Container(
                           color: Colors.white,
                           child: Column(
                             children: [
                               const SizedBox(
                                 height: 0,
                               ),
                               Container(
                                 color: Colors.white,
                                 child: ListTile(
                                   title: Center(
                                       child: Text(
                                         'Setting',
                                         style: TextStyle(color: Colors.grey, fontSize: 25),
                                       )),
                                   onTap: () {
                                     // Navigator.push(
                                     //     context,
                                     //     MaterialPageRoute(
                                     //         builder: (context) =>
                                     //             MyProfileLayout())); // Update the state of the app.
                                   },
                                 ),
                               ),
                               Card(
                                 elevation: 5,
                                 child: Container(
                                   color: Colors.white38,
                                   child: ListTile(
                                     title: Text('About us'),
                                     trailing: Icon(
                                       Icons.arrow_forward_ios,
                                       size: 15,
                                     ),
                                     leading: Icon(Icons.info),
                                     onTap: () {
                                       //  Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));                        // Update the state of the app.
                                       // ...
                                     },
                                   ),
                                 ),
                               ),
                               Card(
                                 elevation: 5,
                                 child: Container(
                                   color: Colors.white38,
                                   child: ListTile(
                                     title: Text('Terms & Conditions'),
                                     trailing: Icon(
                                       Icons.arrow_forward_ios,
                                       size: 15,
                                     ),
                                     leading: Icon(Icons.receipt_long),
                                     onTap: () {
                                       //  Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndCondition()));                        // Update the state of the app.
                                       // Update the state of the app.
                                       // ...
                                     },
                                   ),
                                 ),
                               ),
                               Card(
                                 elevation: 5,
                                 child: ExpansionTile(
                                   leading: Icon(Icons.recommend_outlined),
                                   collapsedTextColor: Colors.black,
                                   textColor: Colors.black,
                                   iconColor: Colors.black,
                                   title: Text('Join our community',
                                       style: TextStyle(
                                         fontSize: 15,
                                       )),
                                   children: [
                                     Row(
                                       children: [
                                         IconButton(
                                             padding: EdgeInsets.all(0),
                                             icon: Icon(
                                               Icons.facebook,
                                               color: Colors.blue,
                                               size: 40,
                                             )),
                                         //   CircleAvatar(backgroundImage: NetworkImage('$instagram'),radius: 19,),SizedBox(width: 7,),
                                         // CircleAvatar(backgroundImage: NetworkImage('$tiktok',),radius: 19,),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                               Card(
                                 elevation: 5,
                                 child: Container(
                                   color: Colors.white38,
                                   child: ListTile(
                                     title: Text('Logout'),
                                     leading: Icon(Icons.logout),
                                     onTap: () {
                                       CashHelper.removeData(key: 'uId').then((value) {
                                         if (value) {
                                           cubit.myPost.clear();
                                           cubit.post.clear();
                                           cubit.users.clear();
                                           cubit.userModel.toMap().clear();

                                           Navigator.pushAndRemoveUntil(
                                               context,
                                               MaterialPageRoute(
                                                   builder: (context) => LoginLayout()),(route)=>false);

                                         }
                                       });
                                       // Update the state of the app.
                                       // ...
                                     },
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                       backgroundColor: Colors.white,
                       appBar: AppBar(
                         actions: [
                           IconButton(onPressed: (){
                             SocialCubit.get(context).getUsers();
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => SearchPage()));

                           }, icon: Icon(IconBroken.Search,color: Colors.black,))
                         ],
                         leading: Builder(
                           builder: (BuildContext context) {
                             return IconButton(
                               icon: const Icon(
                                 IconBroken.Setting,
                                 color: Colors.black,
                               ),
                               onPressed: () {
                                 Scaffold.of(context).openDrawer();
                               },
                               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                             );
                           },
                         ),
                         titleSpacing: 10,
                         backgroundColor: Colors.white,
                         elevation: 1,
                         title: Text(cubit.titles[cubit.currentIndex],
                             style: TextStyle(
                                 color: Colors.black, fontWeight: FontWeight.bold)),
                       ),
                       body: cubit.bottomScreens[cubit.currentIndex],
                       bottomNavigationBar: BottomNavigationBar(
                         onTap: (index) {
                           cubit.changeScreen(index);
                         },
                         currentIndex: cubit.currentIndex,
                         items: const [
                           BottomNavigationBarItem(
                               icon: Icon(
                                 IconBroken.Home,
                               ),
                               label: "Feeds",
                               backgroundColor: Colors.blue),
                           BottomNavigationBarItem(
                             icon: Icon(
                               IconBroken.Chat,
                             ),
                             label: "Chat",
                             backgroundColor: Colors.white,
                           ),
                           BottomNavigationBarItem(
                               icon: Icon(
                                 Icons.person_outline_rounded,
                                 size: 28,
                               ),
                               label: "Profile",
                               backgroundColor: Colors.white),
                         ],
                       ),
                     ));
               },
             );


  }
}
