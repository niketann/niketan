import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
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
    if (UserCredential != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Future<GitHubSignInResult>SignInwithGithub()async{

    final GitHubSignIn githubSignIn=GitHubSignIn(
      clientId:"0449d0ce-55b4-4031-a744-8bbacd7d7c9a",
      clientSecret: "7cbfe0ca-2330-4353-a8cf-0c495a1480f5",
      redirectUrl:"https://fir-e-e1734.firebaseapp.com/__/auth/handler" ,
    );

    final result=await githubSignIn.signIn(context);
    final githubAuthCredentials=GithubAuthProvider.credential(result.token!);

    UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(githubAuthCredentials);
    print(userCredential.user?.displayName);
    return result;
   /* if(userCredential!=null){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }*/

  }

  Future<void> signInWithGitHub() async {
    try {
      final result = await FirebaseAuth.instance.signInWithPopup(GithubAuthProvider());
      if (result.user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      } else {
        print("Please Enter the correct !!");
      }
    } catch (e) {
      print('GitHub sign in error: $e');
    }
  }

  /*Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.token);

        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      }
    } catch (e) {
      print('Error during Facebook login: $e');
    }

    return null;
  }*/

  ///code
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
              InkWell(
                  onTap: () {
                    signInWithGitHub();
                    SignInwithGithub();
                  },
                  child: Text(("Login GitHub!")))
            ],
          ),
        ),
      )),
    );
  }
}
