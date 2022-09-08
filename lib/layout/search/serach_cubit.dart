import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/control/cubit.dart';
import 'package:social/layout/search/search_state.dart';
import 'package:social/models/user_model.dart';

class SearchCubit extends Cubit<SearchState>{
  SearchCubit ():super (InitialSearchState());

  static SearchCubit get(context)=>BlocProvider.of(context);

 List<Map> searchData=[];
QuerySnapshot querySnapshot;
  Future getSearchUsers(String query) {
emit(SearchLoadingState());
   return FirebaseFirestore.instance.collection('users')

        .where('name',isGreaterThanOrEqualTo: query).get()
    .then((value) {
      querySnapshot=value;
       value.docs.forEach((element) {
         searchData.add(element.data());
       });
       print(searchData);
      emit(SearchSuccessState());

    })
    .catchError((error){});


  }
}