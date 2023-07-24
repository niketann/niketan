import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
Future<void> backgroundhandler(RemoteMessage message)async{


}
class NotoficationServices{

 static Future<void>intialize()async{
   final String FCMToken;

 NotificationSettings notificationSettings= await FirebaseMessaging.instance.requestPermission();
 if(notificationSettings.authorizationStatus==AuthorizationStatus.authorized){
   log("Notification Intializedd!!!!!!!");
  FCMToken=(await FirebaseMessaging.instance.getToken())!;
  log("srjsr${FCMToken}");
   FirebaseMessaging.onBackgroundMessage(backgroundhandler);
   /*FirebaseMessaging.onMessage.listen((message) {
    log("Messaaage recived!!${message.notification!.title}");
   });*/
 }


  }
}