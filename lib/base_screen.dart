import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_screen.dart';

class BaseScreen extends StatefulWidget {
  @override
  BaseScreenState createState() {
    // TODO: implement createState
    return BaseScreenState();
  }
}

class BaseScreenState extends State<BaseScreen> {
  List<Map<String, dynamic>> notes = [];

  Future<String> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('base ' + prefs.getString('email').toString());
    return prefs.getString('uid').toString();
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('uid');
    prefs.remove('name');
    Navigator.pushReplacementNamed(context, "/signin");
  }

  void deleteNote(String nid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Firestore.instance
        .collection('users')
        .document(prefs.get('uid'))
        .collection('copyboard')
        .document(nid)
        .delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession().then((data) {
      print(data);
      Firestore.instance
          .collection('users')
          .document(data)
          .collection('copyboard')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((docdata) {
        notes = [];
        docdata.documents.forEach((doc) {
          notes.add(doc.data);
        });
        setState(() {
          notes = notes;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text('CopyBoard'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/image_text");

            },
            icon: Icon(Icons.camera_alt),
          )
          ,
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];

            return Card(
              elevation: 16,
              margin: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        note['text'].toString(),
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Divider(
                      height: 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditScreen(note),
                                ),
                              );
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteNote(note['id']);
                            }),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_note');
        },
        child: new IconTheme(
          data: new IconThemeData(color: Colors.white),
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}
