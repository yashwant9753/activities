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

// void retriveItem(User _user) {
//   CollectionReference users =
//       FirebaseFirestore.instance.collection("$_user.email");
//   users
//       .get()
//       .then((value) => value.docs.forEach((doc) {
//             print(doc.id);
//           }))
//       .catchError((error) => print("Failed to add user: $error"));
// }
// List<String> retriveItem(String mail, var d) {
//   List<String> docId = [];

//   FirebaseFirestore.instance
//       .collection("${mail}")
//       .get()
//       .then((QuerySnapshot querySnapshot) {
//     querySnapshot.docs.forEach((doc) {
//       print(docId);
//       docId.forEach((element) => docId.add(element));
//     });
//   });

// FirebaseFirestore.instance
//     .collection("${mail}")
//     .doc(d)
//     .get()
//     .then((DocumentSnapshot documentSnapshot) {
//   if (documentSnapshot.exists) {
//     print('Document data: ${documentSnapshot.data()}');
//   } else {
//     print('Document does not exist on the database');
//   }
// });

//   return docId;
// }
getData(_mail) {
  CollectionReference users = FirebaseFirestore.instance.collection('$_mail');
  users.get().then((QuerySnapshot querySnapshot) {
    List nana = [];
    querySnapshot.docs.forEach((doc) {
      nana.add(doc.id);
    });
  });
}
// getData(_mail) {
//   CollectionReference users = FirebaseFirestore.instance.collection('$_mail');
//   users.snapshots().listen((snapshot) {
//     List documents;
//     documents = snapshot.docs;
//     print(documents);
//   });
// }

Future getUsersList(_mail) async {
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
