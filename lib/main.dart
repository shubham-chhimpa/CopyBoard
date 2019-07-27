import 'package:flutter/material.dart';
import 'base_screen.dart';
import 'add_screen.dart';
import 'signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';
import 'image_text_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget currentWidget = SignInScreen();

  Future<dynamic> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('email').toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser().then((value) {
      if (value == 'null') {
        print('null' + value);
        setState(() {
          currentWidget = SignInScreen();
        });
      } else {
        print('not null' + value);
        setState(() {
          currentWidget = BaseScreen();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => currentWidget,
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/add_note': (context) => AddScreen(),
        '/base': (context) => BaseScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup' : (context) => SignUpScreen(),
        '/image_text' : (context) => ImageTextScreen(),

      },
    );
  }
}
