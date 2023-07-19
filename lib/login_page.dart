import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:niketanstore/home.dart';
import 'package:niketanstore/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'phone_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  void Login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      if (_emailController.text.trim() == "" ||
          _passwordController.text.trim() == "") {
        log("please fill all details");
      } else if (userCredential.user != null) {
        print("Login Successful");
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        print("errrrooorrrrrrrrr");
      }
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
    }
  }

  void SignInwithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(25)),
          height: 400,
          width: 300,
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
                      /* onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },*/
                      keyboardType: TextInputType.text,
                      obscuringCharacter: '^',
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: "Password",
                          labelText: 'Password',
                          suffixIcon: InkWell(
                              onTap: () {
                                _obsecurePassword.value =
                                    !_obsecurePassword.value;
                              },
                              child: _obsecurePassword.value
                                  ? Icon(Icons.visibility_off_outlined)
                                  : Icon(Icons.visibility)),
                          prefixIcon: Icon(Icons.password)),
                    );
                  }),
              SizedBox(
                height: 11,
              ),
              InkWell(
                onTap: () {
                  if (_emailController.text.isEmpty) {
                    log("Enter Email");
                  } else if (_passwordController.text.isEmpty) {
                    log("Enter password");
                  } else if (_passwordController.text.length < 6) {
                    log("Enter 6 digit password");
                  } else {
                    Login();
                    print("API Hit");
                  }
                },
                child: Text("LogIn"),
              ),
              SizedBox(
                height: height * .05,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text(("Don't have an Account? Sign Up?"))),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PhoneScreen()));
                  },
                  child: Text(("Sign Up with Phone"))),
              InkWell(
                  onTap: () {
                    SignInwithGoogle();
                  },
                  child: Text(("Login with email"))),
            ],
          ),
        ),
      )),
    );
  }
}
