
abstract class RegisterStates{}
class RegisterLoadingState extends RegisterStates{}
class RegisterSuccessState extends RegisterStates{


}
class RegisterInitialState extends RegisterStates{}
class RegisterErrorState extends RegisterStates{
  var error;

  RegisterErrorState({this.error});
}
class RegisterVisibilityState extends RegisterStates{}
class CreateUserSuccessState extends RegisterStates{  final String uId;

  CreateUserSuccessState(this.uId);

}
class CreateUserErrorState extends RegisterStates{
  var error;
  CreateUserErrorState({this.error});
}
