import 'package:flutter/material.dart';
import 'package:login/screens/sign_in_screen.dart';
import 'package:flutter/services.dart';
import 'package:login/res/custom_colors.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Activity App',
      debugShowCheckedModeBanner: false,
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: SignInScreen(),
    );
  }
}
