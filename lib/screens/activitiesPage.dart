import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/database/database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllActivities extends StatefulWidget {
  const AllActivities({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  State<AllActivities> createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
  late User _user;

  List _messages = [];
  var newDt = DateFormat.yMMMEd().format(DateTime.now());
  List documentIdlist = [];
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
        documentIdlist = resultant;
        documentIdlist.add('Choice');
      });
    }
  }

  fetchAcvtivity(value) async {
    dynamic result = await getUserActivity(widget._user.email, value);

    if (result == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        _messages = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Activities",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: Theme.of(context).platform == TargetPlatform.iOS //new
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              )
            : null,
        child: Column(
          children: [
            DropdownButton(
                icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                iconSize: 30,
                elevation: 50,
                isExpanded: true,
                style: const TextStyle(color: Colors.black87),
                value: dropdown,
                items: documentIdlist.map((itemname) {
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
                    if (newValue == "Choice") {
                    } else {
                      fetchAcvtivity(newValue);
                    }
                  });
                }),
            Flexible(
              child: _messages.isEmpty
                  ? Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Add Some Activity\n   or Choice Date",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  letterSpacing: 5,
                                  fontFamily: 'PT_Sans'))),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: ListTile(
                            title: Text('${_messages[index]}'),
                            subtitle: Text("Yashwant"),
                          ),
                        ));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
