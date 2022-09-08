
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/cubit.dart';
import 'package:social/control/states.dart';
import 'package:social/layout/login/login_layout.dart';
import 'package:social/layout/my_profile/my_profile_layout.dart';
import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/constants.dart';
import 'package:social/shared/shared_preferences.dart';

import 'layout/chats/home_page.dart';
import 'layout/home_layout/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CashHelper.init();

  Widget widget;
  uId = CashHelper.getData(key: 'uId');

  if (uId != null) {
   widget=HomeLayout();
  } else {
    widget = LoginLayout();
  }


  BlocOverrides.runZoned(
        () {
          runApp( MyApp(startWidget: widget,));
        },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {

  final Widget startWidget;

  MyApp({this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:
            (context) => SocialCubit()..getUserData()..getAllPosts()..getUsers()..getMyPosts(uId))

      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Social',

            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue,backgroundColor: Colors.white,
              drawerTheme: DrawerThemeData( ),
              bottomNavigationBarTheme:
              BottomNavigationBarThemeData(backgroundColor: Colors.white,selectedItemColor: Colors.blueAccent,elevation: 10,)
                ,),
            home: startWidget,
          );
        },
      ),
    );


  }
}
