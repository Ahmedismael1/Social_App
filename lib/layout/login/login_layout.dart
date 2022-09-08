
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social/control/cubit.dart';
import 'package:social/layout/home_layout/home.dart';
import 'package:social/layout/registration/register_layout.dart';
import 'package:social/shared/constants.dart';
import 'package:social/shared/reusables/reusable_text_filed.dart';


import '../../shared/shared_preferences.dart';
import 'login_cubit/cubit.dart';
import 'login_cubit/state.dart';

class LoginLayout extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  String email, password;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {

              Fluttertoast.showToast(
                  msg: state.error.toString(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

          }
          if(state is LoginSuccessState)
          {
            CashHelper.saveData(

                value:state.uId ,
                key: 'uId')
                .then((value)  {
              uId=state.uId;
              SocialCubit.get(context).getUserData();
              SocialCubit.get(context).getAllPosts();
              SocialCubit.get(context).getUsers();
              SocialCubit.get(context).getMyPosts(state.uId);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeLayout()));



            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ReusableTextFiled(
                        onChange: (val) {
                          email = val;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Email address must not be empty";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email)) {
                            return "Email is not valid ";
                          }

                          return null;
                        },
                        hintText: "Example@example.com",
                        labelText: "Email",
                        textController: emailController,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        onChanged: (val) {
                          password = val;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: "password",
                            hintText: "********",
                            prefixIcon: const IconButton(
                              icon: Icon(Icons.lock),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: "verdana_regular",
                              fontWeight: FontWeight.w400,
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: "verdana_regular",
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                LoginCubit.get(context).visiblePassword();
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                              ),
                            )),
                         obscureText: LoginCubit.get(context).isVisibility,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Password Must Not be Empty";
                          } else if (value.length < 8) {
                            return "Password Length Short";
                          }
                          // else if(!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$.').hasMatch(password)){
                          //   return "password must have special character ";
                          // }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,

                        builder: (context) => TextButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              LoginCubit.get(context).login(
                                  email: emailController.text,
                                  password: passwordController.text);

                            }


                          },
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue.shade500,
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 60)),
                        ),
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () async {},
                          child: Text(
                            "Forget password",
                            style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Create a new account",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                            TextButton(
                              onPressed: () async {
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterLayout()));
                              },
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
