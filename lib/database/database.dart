// import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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

// void addItem() {
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   users
//       .get()
//       .then((value) => value.docs.forEach((doc) {
//             print(doc.data());
//           }))
//       .catchError((error) => print("Failed to add user: $error"));
// }

FirebaseFirestore firestore = FirebaseFirestore.instance;

void addItem(mail, var d, List _messages) {
  CollectionReference users = FirebaseFirestore.instance.collection("${mail}");
  users.doc('$d').set({"activity": _messages});
}

Future getUserDate(_mail) async {
  CollectionReference profileList =
      FirebaseFirestore.instance.collection('$_mail');
  List itemsList = [];

  try {
    await profileList.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        itemsList.add(element.id);
      });
    });
    return itemsList;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future getUserActivity(_mail, String date) async {
  List list = ["Yashwant Sahu"];
  CollectionReference user = FirebaseFirestore.instance.collection('$_mail');

  try {
    user.doc(date).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data().runtimeType}');
      } else {
        print('Document does not exist on the database');
      }
    });
    return list;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
