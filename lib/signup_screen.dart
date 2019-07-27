import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() {
    // TODO: implement createState
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();

  final passController = TextEditingController();
  final nameController = TextEditingController();

  void signUp(context) async {
    List users = [];

    Firestore.instance
        .collection('users')
        .getDocuments()
        .then((QuerySnapshot docs) {
      print(docs.documents);
      docs.documents.forEach((DocumentSnapshot document) {
        users.add(document.data['email'].toString());
      });
    }).then((val) {
      if (users.contains(emailController.text.toLowerCase().toString())) {
        print('already resgistered');
        Toast.show("Already Registered", context, duration: Toast.LENGTH_LONG);
        print(users);
      } else {
        print('not registered');
        print(users);

        DocumentReference userDoc =
        Firestore.instance.collection('users').document();
        userDoc.setData({
          'id': userDoc.documentID,
          'name': nameController.text.toString(),
          'email': emailController.text.toLowerCase().toString(),
          'pass': passController.text.toString()
        }).then((val){
          Toast.show("Succesfully Registered", context, duration: Toast.LENGTH_LONG);

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
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
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: nameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16, left: 16, top: 16),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: passController,
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 32),
                child: RaisedButton(
                  onPressed: () {
                    signUp(context);
                  },
                  elevation: 16,
                  child: Text(
                    'SignUp',
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
                      Text("Already have a Account!"),
                      new GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/signin");
                          print("text clicked");
                        },
                        child: new Text(
                          "  SignIn",
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
