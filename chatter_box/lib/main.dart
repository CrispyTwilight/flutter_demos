import 'package:chatter_box/pages/login.dart';
import 'package:chatter_box/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:chatter_box/pages/chatterScreen.dart';
import 'package:chatter_box/pages/splash.dart'; // Corrected import path

void main() => runApp(ChatterApp());

class ChatterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatter',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ChatterHome(),
        '/login': (context) => ChatterLogin(),
        '/signup': (context) => ChatterSignUp(),
        '/chat': (context) => ChatterScreen(),
      },
    );
  }
}
