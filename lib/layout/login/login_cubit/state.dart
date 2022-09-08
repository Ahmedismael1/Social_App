
abstract class LoginStates{}
class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{
  final String uId;
  LoginSuccessState(this.uId,);
}
class LoginErrorState extends LoginStates{
   var error;
  LoginErrorState({this.error});
}
class LoginVisibilityState extends LoginStates{}
