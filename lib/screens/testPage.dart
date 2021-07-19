import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/database/database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

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
  List userProfilesList = [];

  String dropdown = 'Choice';

  List activityList = [];
  void initState() {
    super.initState();
    fetchDatabaseList();

    // fetchAcvtivity();
  }

  fetchDatabaseList() async {
    dynamic resultant = await getUserDate(widget._user.email);

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultant;
        userProfilesList[0] = 'Choice';
      });
    }
  }

  // fetchAcvtivity() async {
  //   dynamic result = await getUserActivity(widget._user.email, newDt);

  //   if (result == null) {
  //     print('Unable to retrieve');
  //   } else {
  //     setState(() {
  //       activityList = result;
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
            DropdownButton(
                icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                iconSize: 30,
                elevation: 50,
                isExpanded: true,
                style: const TextStyle(color: Colors.black87),
                value: dropdown,
                items: userProfilesList.map((itemname) {
                  return DropdownMenuItem(
                      value: itemname,
                      child: Text(
                        itemname,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'PT_Sans'),
                      ));
                }).toList(),
                onChanged: (dynamic newValue) {
                  setState(() {
                    dropdown = newValue!;
                    print(newValue);
                  });
                }),
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
                print(userProfilesList);
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
            Text("${userProfilesList.runtimeType}")
          ],
        )),
      ),
    );
  }
}
