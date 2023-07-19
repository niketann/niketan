import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:niketanstore/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void SignOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void SaveUserData() {
    String name = _namecontroller.text.trim();
    String email = _emailcontroller.text.trim();

    _namecontroller.clear();
    _emailcontroller.clear();

    Map<String, dynamic> d1 = {"name": name, "email": email};
    if (email != "" || name != "") {
      FirebaseFirestore.instance.collection("user").add(d1);
      log("user created!!");
    } else {
      log("Please enter the all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  SignOut();
                },
                icon: Icon(Icons.logout))
          ],
          title: Text("Home"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              Container(
                width: 350,
                height: 250,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _namecontroller,
                      decoration: InputDecoration(hintText: "Name"),
                    ),
                    TextField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(hintText: "Email"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        SaveUserData();
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Actual Data"),
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("user").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListTile(
                                title: Text(userMap["name"]),
                                subtitle: Text(userMap["email"]),
                                trailing: IconButton(
                                  onPressed: () {
                                    //userMap[index].delete();
                                    // FirebaseFirestore.instance.collection("user").doc("f7fpn4t8GkyO1kjk4SEQ").delete();
                                    log("user deleted");
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            );
                          },
                        ),
                      );

                      if (snapshot.hasData && snapshot.data != null) {
                      } else {
                        return Text("No Data!");
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        )));
  }
}
