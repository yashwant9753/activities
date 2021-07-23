import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/screens/sign_in_screen.dart';
import 'package:login/utils/authentication.dart';
import 'package:login/widgets/app_bar_title.dart';
import 'package:login/database/database.dart';
import 'package:login/screens/activitiesPage.dart';
import 'package:login/screens/TestPage.dart';
import 'package:login/screens/rating.dart';
import 'package:login/screens/user_info_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

String _name = 'Description';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late bool _isEmailVerified;
  late User _user;
  List _messages = [];
  List updateList = [];
  bool update = false;
  var url;
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _verificationEmailBeingSent = false;
  bool _isSigningOut = false;
  var newDt = DateFormat.yMMMEd().format(DateTime.now());
  bool _isComposing = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    fetchAcvtivity();
    checkUpdate();
    _user = widget._user;
    _isEmailVerified = _user.emailVerified;

    super.initState();
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
    });
    // var message = ChatMessage(
    //   text: text,
    //   animationController: AnimationController(
    //     duration: const Duration(milliseconds: 700),
    //     vsync: this,
    //   ),
    // );
    setState(() {
      _messages.insert(0, text);
    });
    _focusNode.requestFocus();
    // _message.animationController.forward();
  }

  fetchAcvtivity() async {
    dynamic result = await getUserActivity(widget._user.email, newDt);

    if (result == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        _messages = result;
      });
    }
  }

  checkUpdate() async {
    dynamic resultant = await updateApp();

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        updateList = resultant;
        update = updateList[0]["Update"];
        url = updateList[0]["Link"];
      });
    }
  }

  @override
  void dispose() {
    for (var message in _messages) {
      //   _message.animationController.dispose();
    }
    super.dispose();
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

    // main Activity body
    Widget mainBody = Scaffold(
      backgroundColor: CustomColors.buttonColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                widget._user.displayName!,
                style: TextStyle(color: Colors.white),
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
              leading: Icon(Icons.rule),
              title: Text('Test Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TesPage(
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
                  MaterialPageRoute(builder: (context) => RateApp(user: _user)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Test'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TesPage(user: _user)),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 50),
                  child: RichText(
                      text: TextSpan(
                          text: 'Activity',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 5,
                              fontFamily: 'PT_Sans'))),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 50),
                  child: RichText(
                      text: TextSpan(
                          text: "- ${newDt}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PT_Sans',
                          ))),
                ),
              ]),
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
              addItem(widget._user.email, newDt, _messages);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                children: [Icon(Icons.thumb_up)],
              )));
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
                      child: RichText(
                          text: TextSpan(
                              text: '''Today's Activities''',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  letterSpacing: 10,
                                  fontFamily: 'PT_Sans'))),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: ListTile(
                            title: Text('${_messages[index]}'),
                            subtitle: Text(_name),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                              ),
                              tooltip: 'Delete',
                              onPressed: () {
                                setState(() {
                                  _messages.remove(_messages[index]);
                                });
                              },
                            ),
                          ),
                        ));
                      },
                    ),
            ),
            const Divider(height: 2),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 8.0),
            //   decoration: BoxDecoration(
            //     color: const Color(0xff7c94b6),
            //     border: Border.all(
            //       color: Colors.white,
            //       width: 2,
            //     ),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child:
            _buildTextComposer(),
          ],
        ),
      ),
    );
    return update ? updatebody : mainBody;
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
              // decoration: BoxDecoration(
              //     color: const Color(0xff7c94b6),
              //     border: Border.all(
              //       color: Colors.white,
              //       width: 2,
              //     ),
              //     borderRadius: BorderRadius.all(Radius.circular(20))),
              // margin: const EdgeInsets.symmetric(horizontal: 0),
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
}
