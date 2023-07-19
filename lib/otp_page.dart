import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:niketanstore/home.dart';
import 'package:pinput/pinput.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationId;

  const VerifyOtp({super.key, required this.verificationId});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController _otpcntl = TextEditingController();

  verifyOtp() async {
    String otp = _otpcntl.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (t) {
      log(t.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP"),
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
              Pinput(
                length: 6,
                controller: _otpcntl,
                autofocus: true,
                onCompleted: (value) {
                  verifyOtp();
                  print("OTP doner");
                },
              ),
              /*TextFormField(
                controller: _otpcntl,
                //focusNode: otpfocous,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                    hintText: "OTP",
                    labelText: 'Enter Otp:',
                    prefixIcon: Icon(Icons.verified)),
              ),*/
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (_otpcntl.text.isEmpty) {
                    print("Enter Email");
                  }
                },
                child: Text("Verify Otp"),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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
