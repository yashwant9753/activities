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
  dynamic dropdownValue = "One";
  late User _user;

  final List<dynamic> _messages = ["Yashwant sahu", "Senpai"];
  var newDt = DateFormat.yMMMEd().format(DateTime.now());
  List userProfilesList = [];
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await getUserDate(widget._user.email);

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultant;
      });
    }
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
        decoration: Theme.of(context).platform == TargetPlatform.iOS //new
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              )
            : null,
        child: Column(
          children: [
            DropdownButton<dynamic>(
              value: dropdownValue,
              hint: Text("Choice"),
              icon: const Icon(Icons.arrow_drop_down_circle_outlined),
              iconSize: 30,
              elevation: 50,
              isExpanded: true,
              style: const TextStyle(color: Colors.black87),
              onChanged: (dynamic? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <dynamic>['One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PT_Sans'),
                    ),
                  ),
                );
              }).toList(),
            ),
            Flexible(
              child: _messages.isEmpty
                  ? Center(
                      child: RichText(
                          text: TextSpan(
                              text: '''Activities''',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  letterSpacing: 10,
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
