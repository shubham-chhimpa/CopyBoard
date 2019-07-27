import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddScreen extends StatefulWidget {
  @override
  AddScreenState createState() {
    // TODO: implement createState
    return AddScreenState();
  }
}

class AddScreenState extends State<AddScreen> {
  final addNoteController = TextEditingController();

  void addNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DocumentReference noteDoc = Firestore.instance
        .collection('users')
        .document(prefs.get('uid'))
        .collection('copyboard')
        .document();
    noteDoc.setData({
      'id': noteDoc.documentID,
      'text' : addNoteController.text,
      'timestamp' : FieldValue.serverTimestamp()
    });
     Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Copy Board'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  addNote();
                },
              ),
            ),
          ],
          actionsIconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextFormField(
              maxLines: 10,
              cursorColor: Colors.deepOrangeAccent,
              autofocus: true,
              style: TextStyle(fontSize: 18),
              controller: addNoteController,
              onEditingComplete: () {
                print('onedit');
              },
              onSaved: (val) {
                print('onsave');
              },
            ),
          ),
        ));
  }
}
