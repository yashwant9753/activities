import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/database/database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

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
  Map data = {};
  Map testList = {"name": true, "Sem": false, "nana": true};
  List k = [];
  var newDt = DateFormat.yMMMEd().format(DateTime.now());
  List userProfilesList = [];
  List documentIdlist = [];
  String dropdown = 'Choice';
  final TextEditingController _alertTextField = TextEditingController();

  void initState() {
    super.initState();
    fetchkey();
    fetchDatabaseList();
  }

  fetchkey() {
    testList.forEach((key, value) {
      k.add(key);
    });
    print(k);
  }

  fetchDatabaseList() async {
    dynamic resultant = await getUserDate(widget._user.email);

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        documentIdlist = resultant;
        documentIdlist.add('Choice');
      });
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Save As'),
            content: Container(
              height: MediaQuery.of(context).size.height / 8,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton(
                        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                        iconSize: 30,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black87),
                        value: dropdown,
                        items: documentIdlist.map((itemname) {
                          return DropdownMenuItem(
                              value: itemname,
                              child: Text(
                                itemname,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'PT_Sans'),
                              ));
                        }).toList(),
                        onChanged: (dynamic newValue) {
                          setState(() {
                            dropdown = newValue!;
                          });
                        }),
                    TextField(
                      controller: _alertTextField,
                      decoration: InputDecoration(hintText: "Save As"),
                    ),
                  ]),
            ),
            elevation: 50,
            actions: <Widget>[
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

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
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: k.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      color: testList[k[index]] ? Colors.green : null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: ListTile(
                          title: Text('${k[index]}'),
                          // title: Text('Yashwant Sahu'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                            ),
                            tooltip: 'Delete',
                            onPressed: () {
                              setState(() {
                                testList.remove(k[index]);
                                k.remove(k[index]);
                              });
                            },
                          ),

                          onLongPress: () {
                            setState(() {
                              testList[k[index]] =
                                  testList[k[index]] ? false : true;
                            });
                          },
                        ),
                      ));
                },
              ),
            ),
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
                print(MediaQuery.of(context).size.height);
                print(MediaQuery.of(context).size.width);
                _displayDialog(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'TEST',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.firebaseGrey,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            Text("Hello")
          ],
        )),
      ),
    );
  }
}
