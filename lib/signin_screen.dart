import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatelessWidget {
  final emailController = TextEditingController();

  final passController = TextEditingController();

  void sign(email, pass, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.getString('email') != null) {
      } else {
        Firestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .snapshots()
            .listen((data) {
          if (passController.text == data.documents[0].data['pass']) {
            print('ok');
            prefs.setString('uid', data.documents[0].data['id']);
            prefs.setString('email', data.documents[0].data['email']);
            prefs.setString('name', data.documents[0].data['name']);
            Navigator.pushNamed(context, '/base');
          } else {
            print('some error');
          }
        });
      }
    } catch (e) {
      print('shared pref error ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('SignIn'),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(32),
          elevation: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16, left: 16, top: 32),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: emailController,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16, left: 16, top: 16),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: passController,
                  obscureText: true,
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 32),
                child: RaisedButton(
                  onPressed: () {
                    sign(emailController.text.toLowerCase().toString(),
                        passController.text.toString(), context);
                  },
                  elevation: 16,
                  child: Text(
                    'SignIn',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepOrange,
                ),
              ),
              Padding(
                  padding:
                  EdgeInsets.only(top: 16, bottom: 32, left: 16, right: 16),
                  child: Row(
                    children: <Widget>[
                      Text("Don't have a Account!"),
                      new GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/signup");
                          print("text clicked");
                        },
                        child: new Text(
                          "  SignUp",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
