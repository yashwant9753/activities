import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:login/res/custom_colors.dart';

import 'package:intl/intl.dart';

class AllActivities extends StatelessWidget {
  const AllActivities({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _user.displayName!,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DisplayActivity(),
    );
  }
}

class DisplayActivity extends StatefulWidget {
  const DisplayActivity({Key? key}) : super(key: key);

  @override
  State<DisplayActivity> createState() => _DisplayActivityState();
}

/// This is the private State class that goes with DisplayActivity.
class _DisplayActivityState extends State<DisplayActivity> {
  String dropdownValue = 'One';
  final List<String> _messages = ["Yashwant sahu", "Senpai"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Theme.of(context).platform == TargetPlatform.iOS //new
          ? BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            )
          : null,
      child: Column(
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            iconSize: 30,
            elevation: 50,
            isExpanded: true,
            style: const TextStyle(color: Colors.black87),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
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
    );
  }
}
