import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niketanstore/home.dart';
import 'package:niketanstore/login_page.dart';
import 'package:niketanstore/otp_page.dart';
import 'package:pinput/pinput.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController _phoneController = TextEditingController();

  FocusNode phoneFocusNode = FocusNode();

  void SendOtp() async {
    String phone = "+91" + _phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: phone,
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          log(ex.code.toString());
        },
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyOtp(verificationId: verificationId)));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Sign UP"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
        child: Container(
          width: 300,
          height: 400,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _phoneController,
                focusNode: phoneFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Number",
                    labelText: 'Phone Number:',
                    prefixIcon: Icon(Icons.phone)),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (_phoneController.text.isEmpty) {
                    print("Enter number");
                  } else {
                    SendOtp();
                  }
                },
                child: Text("send Otp"),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
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
