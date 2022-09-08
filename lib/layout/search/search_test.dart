import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/cubit.dart';
import 'package:social/layout/chats/chats_layout.dart';
import 'package:social/layout/search/search_state.dart';
import 'package:social/layout/search/serach_cubit.dart';
import 'package:social/layout/user_profile/user_profile.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/my_widget.dart';

class SearchPage extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>SearchCubit(),
    child:

      BlocConsumer<SearchCubit,SearchState>(builder: (context, state){

        return SafeArea(
            child: Scaffold(
              body:
              Column(children: [

                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.6)),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            keyboardType: TextInputType.text,

                            controller: textController,
                            onChanged: (val){
                              SearchCubit.get(context).searchData=[];

                              SearchCubit.get(context).getSearchUsers(textController.text);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search..',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                if (state is SearchLoadingState)
                  const LinearProgressIndicator(),

                    (state is SearchSuccessState)?
                    buildSearchList(context):
Expanded(child:         ListView.separated(
    itemBuilder: (context, index) =>
        buildChatItem(SocialCubit.get(context).users[index], context),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: SocialCubit.get(context).users.length)   )
              ],)

            ));

      }, listener: (context, state){})


);

  }

  Widget buildSearchList(context) {
    var data =SearchCubit.get(context).searchData;

   return Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) =>Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data[index]['image']),
                      radius: 27,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${data[index]['name']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            separatorBuilder: (context, index) => myDivider(),
            itemCount:
            SearchCubit.get(context).searchData.length));


  }


  Widget buildSearch( context,index) {

    var data =SearchCubit.get(context).searchData;

    InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             UserProfileLayout(
        //
        //               userModel: userModel,
        //             ))); // Update the state of the app.
      },
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data[index]['image']),
                radius: 27,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data[index]['name']}',
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
  }
}

