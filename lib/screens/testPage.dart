import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/database/database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TesPage extends StatefulWidget {
  const TesPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _TesPageState createState() => _TesPageState();
}

class _TesPageState extends State<TesPage> {
  late User _user;
  var newDt = DateFormat.yMMMEd().format(DateTime.now());
  // List userProfilesList = [];
  // void initState() {
  //   super.initState();

  //   fetchDatabaseList();
  // }

  // fetchDatabaseList() async {
  //   dynamic resultant = await getUsersList(widget._user.email);

  //   if (resultant == null) {
  //     print('Unable to retrieve');
  //   } else {
  //     setState(() {
  //       userProfilesList = resultant;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._user.displayName!,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
            child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  CustomColors.firebaseOrange,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                // print(userProfilesList.runtimeType);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.firebaseGrey,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            Text("data")
          ],
        )),
      ),
    );
  }
}
