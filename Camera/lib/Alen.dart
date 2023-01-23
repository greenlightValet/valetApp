// Alen Ovalles
// Prototype of Valet Camera
// Edited: 20/01/2023
//
// Added dependencies:
//  image_picker: ^0.8.6
//
// Successful run through an android emulator
//

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPickImageScreen(title: 'Flutter Image Picker Screen'),
    );
  }
}

class MyPickImageScreen extends StatefulWidget {
  const MyPickImageScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyPickImageScreenState createState() => _MyPickImageScreenState();
}

class _MyPickImageScreenState extends State<MyPickImageScreen> {
  bool _load = false;
  late File imgFile;
  final imgPicker = ImagePicker();

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      _load = true;
    });
    Navigator.of(context).pop();
  }

  Future<void> showCamera(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        openCamera();
        return const AlertDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Code'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Camera'),
              onPressed: () {
                showCamera(context);
              },
            ),
            Row(
              children: [
                if (_load == true) ...[
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  ElevatedButton(
                    child: const Text('View Image'),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Taken Picture'),
                          content: Image.file(imgFile),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}
