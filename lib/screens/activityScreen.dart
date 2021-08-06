import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/database/database.dart';
import 'package:login/screens/activitiesPage.dart';
import 'package:login/screens/TestPage.dart';
import 'package:login/widgets/alert_dialog.dart';
import 'package:login/screens/rating.dart';
import 'package:login/screens/user_info_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with TickerProviderStateMixin {
  late bool _isEmailVerified;
  late User _user;
  var newDt = DateFormat.yMMMEd().format(DateTime.now());
  Map _messagecomp = {};
  List _messages = [];
  List updateList = [];
  List documentIdlist = [];
  String dropdown = DateFormat.yMMMEd().format(DateTime.now());
  bool update = false;
  var url;
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _verificationEmailBeingSent = false;
  bool _isSigningOut = false;

  bool _isComposing = false;
  bool checknetConnection = false;
  final TextEditingController _alertTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    fetchAcvtivity();
    checkUpdate();
    fetchDatabaseList();
    print(newDt.runtimeType);
    _user = widget._user;
    _isEmailVerified = _user.emailVerified;
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        checknetConnection = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        checknetConnection = true;
      });
    } else {
      checknetConnection = false;
    }
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

  void _handleClear() {
    setState(() {
      _messages.clear();
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;

      _messages.insert(0, text);
      _messagecomp[text] = false;
    });

    _focusNode.requestFocus();

    // _message.animationController.forward();
  }

  _displayDialog(BuildContext context) async {
    String currentDate = newDt;
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
                child: new Text('SAVE'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  fetchAcvtivity() async {
    dynamic result = await getUserActivity(widget._user.email, newDt);

    if (result == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        _messagecomp = result;
        _messagecomp.forEach((key, value) {
          _messages.add(key);
        });
      });
    }
  }

  checkUpdate() async {
    dynamic resultant = await updateApp();

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      updateList = resultant;
      update = updateList[0]["Update"];
      url = updateList[0]["Link"];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update Body
    Widget updatebody = Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Available",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Text(
                    "The New Version of this App is Available",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Uninstall old version and Download new Verson",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Your Data will be Saved after Uninstall",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 50,
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
                      launch(url);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.firebaseGrey,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );

    Widget noInternet = Scaffold(
      appBar: AppBar(
        title: Text(
          "No Internet",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Icon(
                    Icons.network_check,
                    size: 100,
                  ),
                  Text(
                    "Not Internet Connection",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "This App Store User Activity in Cloud",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "So Please Connect Your Internet",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 50,
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
                      setState(() {
                        checkConnectivity();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.firebaseGrey,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );

    // main Activity body
    Widget mainBody = Scaffold(
        backgroundColor: CustomColors.buttonColor,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                      color: CustomColors.firebaseGrey,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget._user.displayName!,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            widget._user.email!,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ]),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('All Activities'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllActivities(
                              user: _user,
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Account'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfoScreen(
                              user: _user,
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.rate_review),
                title: Text('Rate this App'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RateApp(user: _user)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.rate_review),
                title: Text('Test Page'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TesPage(user: _user)),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("${newDt}"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 20),
              icon: const Icon(Icons.clear_all, size: 30),
              tooltip: 'Clear all Activity',
              onPressed: () {
                setState(() {
                  _messages.clear();
                });
              },
            ),
            IconButton(
              padding: EdgeInsets.only(right: 30),
              icon: const Icon(
                Icons.save,
                size: 30,
              ),
              tooltip: 'Save Activity',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertMessage(
                        user: _user,
                        message: _messagecomp,
                      );
                    });
              },
            ),
          ],
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
              Flexible(
                child: _messages.isEmpty
                    ? Center(
                        child: CircleAvatar(
                        radius: 100,
                        child: Image.asset("assets/logo.png"),
                      ))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: _messagecomp[_messages[index]]
                                ? Colors.green
                                : Colors.grey[850],
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: ListTile(
                                title: Text('${_messages[index]}'),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  tooltip: 'Delete',
                                  onPressed: () {
                                    setState(() {
                                      _messagecomp.remove(_messages[index]);
                                      _messages.remove(_messages[index]);
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    _messagecomp[_messages[index]] =
                                        _messagecomp[_messages[index]]
                                            ? false
                                            : true;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const Divider(
                height: 2,
                color: Colors.white,
              ),
              _buildTextComposer(),
            ],
          ),
        ));
    return checknetConnection
        ? update
            ? updatebody
            : mainBody
        : noInternet;
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type Activity',
                ),
                focusNode: _focusNode,
              ),
            ),
          ),
          Container(
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                      child: const Text('Send'),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        size: 35,
                      ),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    ))
        ],
      ),
    );
    // );
  }

  @override
  void dispose() {
    for (var message in _messages) {}
    super.dispose();
  }
}
