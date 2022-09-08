import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social/control/cubit.dart';
import 'package:social/layout/login/login_layout.dart';
import 'package:social/layout/registration/register_cubit/cubit.dart';
import 'package:social/layout/registration/register_cubit/state.dart';
import 'package:social/shared/IconBrocen.dart';
import 'package:social/shared/reusables/reusable_text_filed.dart';

import '../../shared/shared_preferences.dart';
import '../home_layout/home.dart';

class RegisterLayout extends StatelessWidget {
  String name, phone, email, password;
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>
        (listener: (context,state){
        if (state is RegisterErrorState) {

          Fluttertoast.showToast(
              msg: state.error.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

        }
        if(state is CreateUserSuccessState)
        {
          CashHelper.saveData(
              value:state.uId ,
              key: 'uId')
              .then((value) async{


            SocialCubit.get(context).getUserData();
            SocialCubit.get(context).getAllPosts();
            SocialCubit.get(context).getUsers();
            SocialCubit.get(context).getMyPosts(state.uId);
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeLayout()));

          });
        }
      },
        builder:(context,state){
        return  Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,

          ),
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "SignUp",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 40
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    ReusableTextFiled(
                      textController: nameController,
                      labelText: "name",
                      hintText: "Enter your name",
                      validator: (value){
                        if (value.isEmpty) {
                          return "Email address must not be empty";
                        }
                        return null;

                      },
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      onChange: (val) {
                        name = val;
                      },textInputType: TextInputType.name,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ReusableTextFiled(
                      textController: emailController,
                      onChange: (val) {
                        email = val;
                      },
                      validator: (value){
                        if (value.isEmpty) {
                          return "Email address must not be empty";
                        }else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email)) {
                          return "Email is not valid ";
                        }

                        return null;
                      },
                      hintText: "Example@example.com",
                      labelText: "Email",
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value){
                        if (value.isEmpty) {
                          return "Email address must not be empty";
                        }
                        else if (value.length < 8) {
                          return "Password Length Short";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        password = val;
                      },keyboardType: TextInputType.visiblePassword,
                      obscureText: RegisterCubit.get(context).isVisibility,
                      decoration: InputDecoration(
                          labelText: "password",
                          hintText: "*********",
                          prefixIcon: const  Icon(Icons.lock),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
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
                            onPressed: () {RegisterCubit.get(context).visiblePassword();},
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ReusableTextFiled(
                      textController: phoneController,
                      validator: (value){
                        if (value.isEmpty) {
                          return "Email address must not be empty";
                        }
                        return null;

                      },
                      onChange: (val) {
                        phone = val;
                      },
                      hintText: "01*********",
                      labelText: "phone",textInputType: TextInputType.phone,
                      prefixIcon: const Icon(
                        Icons.add_call,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ConditionalBuilder(
                      condition: state is! RegisterLoadingState,

                      builder: (context) =>  TextButton(
                        onPressed: () async{

                          if (formKey.currentState.validate()) {
                            RegisterCubit.get(context).register(
                                email: emailController.text,
                                name: nameController.text.toLowerCase(),
                                password: passwordController.text,
                                phone:phoneController.text

                            );
                          }


                        }

                        ,child: const Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize:  Size(MediaQuery.of(context).size.width, 60)),
                      ),
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          TextButton(
                            onPressed: () async{

                              Navigator.pop(context);

                            },
                            child: const Text(
                              "Log in",
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
              )
            ],
          ),)
        );

      } ,),

    );


  }
}
