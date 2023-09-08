import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:roommates/Task/task.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:firebase_auth/firebase_auth.dart';



class messageController extends GetxController{
  //this will hold the data and update the ui
  final _db = Get.put(DBHelper());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ///
  /// This method sends a message to the specified user(s)
  /// writes a message in the database
  ///
  sendMessage()
  {

  }

  ///
  /// This method gets messages from user
  /// reads from database
  ///
  getMessages()
  {

  }

}