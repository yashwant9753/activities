import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login/screens/activityScreen.dart';
import 'package:login/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// final DatabaseReference = FirebaseDatabase.instance.reference().child('test');
// final databaseRef = FirebaseDatabase.instance.reference();
// void writeData(List _message) {
//   databaseRef.child('1').set({'id': 'ID1', 'data': _message});
// }

// void readData() {
//   databaseRef.once().then((DataSnapshot dataSnapShot) {
//     print(dataSnapShot.value);
//   });
// }

// void updateData(List _message) {
//   databaseRef.child("1").update({"data": _message});
// }

// void deleteData() {
//   databaseRef.child("1").remove();
// }

// Create a CollectionReference called users that references the firestore collection

void addItem() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users
      .add({
        'full_name': "yash", // John Doe
        'company': 'nana', // Stokes and Sons
        'age': 21 // 42
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
