import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/registration/register_cubit/state.dart';
import 'package:social/models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void register({String email, password, phone, name}) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user.email);
      createUser(phone: phone, email: email, name: name, uId: value.user.uid);
    }).catchError((error) {
      print(error);
      emit(RegisterErrorState(error: error));
    });
  }

  void createUser({String email, uId, phone, name}) {
    UserModel userModel = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      cover:'https://thumbs.dreamstime.com/b/kuwait-skyline-harbor-13450051.jpg' ,
      image: 'https://www.portmelbournefc.com.au/wp-content/uploads/2022/03/avatar-1.jpeg',
      bio: 'Bio..',
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(CreateUserSuccessState(uId));
    }).catchError((error) {
      print(error);
      emit(CreateUserErrorState(error: error));
    });
  }

  bool isVisibility = true;

  void visiblePassword() {
    isVisibility = !isVisibility;

    emit(RegisterVisibilityState());
  }
}
