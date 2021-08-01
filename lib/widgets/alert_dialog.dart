import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/database/database.dart';
import 'package:login/screens/activitiesPage.dart';
import 'package:intl/intl.dart';

class AlertMessage extends StatefulWidget {
  const AlertMessage({Key? key, required User user, required Map message})
      : _user = user,
        _message = message,
        super(key: key);

  final User _user;
  final Map _message;

  @override
  _AlertMessageState createState() => _AlertMessageState();
}

class _AlertMessageState extends State<AlertMessage> {
  late User _user;
  Map? _message;

  List documentIdlist = [];

  final TextEditingController _alertTextField = TextEditingController();
  String dropdown = DateFormat.yMMMEd().format(DateTime.now());
  @override
  void initState() {
    super.initState();
    print(_message);

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await getUserDate(widget._user.email);

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        documentIdlist = resultant;
        documentIdlist.add(DateFormat.yMMMEd().format(DateTime.now()));
      });
    }
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("SAVE AS"),
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
          child: new Text('SAVE'),
          onPressed: () {},
        )
      ],
    );
  }
}
