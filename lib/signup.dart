import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:niketanstore/home.dart';
import 'package:niketanstore/login_page.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> _obsecurePassword1 = ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmpasswordFocusNode = FocusNode();

  void createAccount() async{
    String email=_emailController.text.trim();
    String password=_passwordController.text.trim();
    String confirmpassword=_confirmpasswordController.text.trim();
    if(email=="" || password=="" || confirmpassword==""){
      log("please fill all details");
    }
    else if(password!=confirmpassword){
      log("password and confirm password does not match");
    }
    else{
      try{
        //craete account
        UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        print("user created");
        if(userCredential.user!=null){
          //print("wronggggggggg");
          Navigator.pop(context);
        }
      }on FirebaseAuthException catch(ex){
        log(ex.code.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
            child: Container(
              width: 300,
              height: 400,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.black),
                  borderRadius: BorderRadius.circular(25)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_sharp)),
                  ),
                  ValueListenableBuilder(
                      valueListenable: _obsecurePassword,
                      builder: (context, value, child) {
                        return TextFormField(
                          obscureText: _obsecurePassword.value,
                          focusNode: passwordFocusNode,
                          keyboardType: TextInputType.text,
                          obscuringCharacter: '^',
                          controller: _passwordController,
                          decoration: InputDecoration(
                              hintText: "Password",
                              labelText: 'Password',
                              suffixIcon: InkWell(
                                  onTap: () {
                                    _obsecurePassword.value = !_obsecurePassword.value;
                                  },
                                  child: _obsecurePassword.value
                                      ? Icon(Icons.visibility_off_outlined)
                                      : Icon(Icons.visibility)),
                              prefixIcon: Icon(Icons.password)),
                        );
                      }),
                  ValueListenableBuilder(
                      valueListenable: _obsecurePassword1,
                      builder: (context, value, child) {
                        return TextFormField(
                          obscureText: _obsecurePassword1.value,
                          focusNode: confirmpasswordFocusNode,
                          keyboardType: TextInputType.text,
                          obscuringCharacter: '^',
                          controller: _confirmpasswordController,
                          decoration: InputDecoration(
                              hintText: "Password",
                              labelText: 'Password',
                              suffixIcon: InkWell(
                                  onTap: () {
                                    _obsecurePassword1.value = !_obsecurePassword1.value;
                                  },
                                  child: _obsecurePassword1.value
                                      ? Icon(Icons.visibility_off_outlined)
                                      : Icon(Icons.visibility)),
                              prefixIcon: Icon(Icons.password)),
                        );
                      }),
                  InkWell(
                    onTap: (){
                      if (_emailController.text.isEmpty) {
                       print("Enter Email");
                      } else if (_passwordController.text.isEmpty) {
                        print("Enter password");
                      } else if (_passwordController.text.length < 6) {
                        print("Enter 6 digit password");
                      } else {
                        createAccount();
                      }
                    },
                    child: Text("SignUP"),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                      },
                      child: Text(("Already have an Account? Login ")),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
