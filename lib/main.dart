import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niketanstore/firebase_options.dart';
import 'package:niketanstore/home.dart';
import 'package:niketanstore/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ///for getting whole array or whole data
/*  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("user").get();
  for (var doc in snapshot.docs) {
    log(doc.data().toString());
  }*/

  ///for getting particular data pass the id
  /*DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection("user").doc("miqYTiDIa3fMdhCaWBPQ").get();
  log(snapshot.data().toString());*/

  ///for writing dsata in firestore
  /*Map<String,dynamic>newUserData = {
    "name":"Vikram",
    "email":"vikram@gmail.com"
  };
  await FirebaseFirestore.instance.collection("user").add(newUserData);
  log("new user save");*/

  ///For craete own id fr add data
  /* Map<String,dynamic>newUserData1 = {
    "name":"Ashwed",
    "email":"ashwed@gmail.com"
  };
  await FirebaseFirestore.instance.collection("user").doc("Id-boy-here").set(newUserData1);
  log("new user save");*/

  ///Update the data
  /* Map<String,dynamic>newUserData1 = {
    "name":"Ashwed",
    "email":"ashwed@gmail.com"
  };
  await FirebaseFirestore.instance.collection("user").doc("Id-here").update({
    "email":"as@gmail.com"
  });
  log("user update save");*/

  ///for delete data
  /* await FirebaseFirestore.instance.collection("user").doc("Id-boy-here").delete();
  log("user deleted");*/

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null) {
                return const LoginScreen();
              } else {
                return const HomeScreen();
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
        /*(FirebaseAuth.instance.currentUser != null)
          ? HomeScreen()
          : LoginScreen(),*/
        );
  }
}
