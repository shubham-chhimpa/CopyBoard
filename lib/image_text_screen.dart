import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageTextScreen extends StatefulWidget {
  @override
  ImageTextScreenState createState() {
    // TODO: implement createState
    return ImageTextScreenState();
  }
}

class ImageTextScreenState extends State<ImageTextScreen> {
  File _image;
  String _text;
  final _imageToTextController = TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer =
    FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
    await textRecognizer.processImage(visionImage);
    String text = visionText.text;
    //print('detected  vision text : ' +text);

    String mytext = '';
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;
      //rint('detected  block text : ' +text);

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
          mytext = mytext + ' ' + element.text.toString();
        }
        mytext = mytext + '\n';
      }
      mytext = mytext + '\n';
    }

    print(mytext);
    setState(() {
      _image = image;
      _text = mytext;
      _imageToTextController.text = _text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Image to Text"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _text == null
                  ? Container()
                  : Padding(
                padding: EdgeInsets.only(
                    top: 16, bottom: 16, left: 8, right: 8),
                child: TextFormField(
                  maxLines: 18,
                  cursorColor: Colors.deepOrangeAccent,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(4)))),
                  controller: _imageToTextController,
                ),
              ),
              _image == null
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Text(
                    'Select a Image/screenshot to grab Text',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
                  : Image.file(_image),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
