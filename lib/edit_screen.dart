import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditScreen extends StatefulWidget {
  final Map<String, dynamic> note;

  EditScreen(this.note);

  @override
  EditScreenState createState() {
    // TODO: implement createState
    return EditScreenState(note);
  }
}

class EditScreenState extends State<EditScreen> {
  Map<String, dynamic> note;
  final editNoteController = TextEditingController();

  EditScreenState(this.note);


  void updateNote() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Firestore.instance.collection('users').document(prefs.get('uid')).collection('copyboard').document(note['id'])
        .updateData({ 'text' : editNoteController.text });
    Navigator.pop(context);

  }

  @override
  void initState() {
    editNoteController.text = note['text'];
    super.initState();
  }

  @override
  void dispose() {
    // other dispose methods
    editNoteController.dispose();
    super.dispose();
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
                  updateNote();
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
              controller: editNoteController,
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
