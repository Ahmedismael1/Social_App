
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/login/login_cubit/state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  void login({String email, password}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user.email);
      print(value.user.uid);

      emit(LoginSuccessState( value.user.uid));

    })
        .catchError((error){
      print("$error");
      emit(LoginErrorState(error: error));

    });

  }

  bool isVisibility = true;

  void visiblePassword() {
    isVisibility = !isVisibility;

    emit(LoginVisibilityState());
  }
}
