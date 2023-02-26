import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import "firestore.dart";
import 'dart:math';
import 'dart:io';
import 'request.dart';

void main() async {
  runApp(const Homepage());
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket',
      theme: ThemeData.dark(),
      home: const FormPage(title: 'GreenLight Solutions'),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

// top navbar (with link to each page )
class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.add_circle),
                  text: "Ticket",
                ),
                Tab(
                  icon: Icon(Icons.find_in_page_sharp),
                  text: "Requests",
                ),
                Tab(
                  icon: Icon(Icons.home),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(Icons.settings),
                  text: "Settings",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const ValetForm(),
              ),
              const Request(),
              const MaterialApp(
                home: Center(child: Text("Add Home")),
              ),
              const MaterialApp(
                home: Center(child: Text("Add Settings")),
              ),
            ],
          )),
    );
  }
}

class ValetForm extends StatefulWidget {
  const ValetForm({super.key});

  @override
  _ValetFormState createState() => _ValetFormState();
}

class _ValetFormState extends State<ValetForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();
  late TwilioFlutter twilioFlutter;

//***** VARIABLES *****

// ticket
  String _ticketID = '';
  String _name = '';
  String _phoneNumber = '';
  String _brand = '';
  String _model = '';
  String _license = '';
  String _color = '';
  String _parkingSpot = '';
  int _shiftPeriod = 0;
  bool _nameValidation = false;
  bool _phoneNumValidation = false;
  bool _sendConfirmationBtnPressed = false; //for confirmation button
  bool _createTicketBtnPressed = false; //for ticket button

// camera
  bool _front = false;
  bool _back = false;
  bool _left = false;
  bool _right = false;
  late File frontImg = File('');
  late File backImg = File('');
  late File leftImg = File('');
  late File rightImg = File('');
  final frontPicker = ImagePicker();
  final backPicker = ImagePicker();
  final leftPicker = ImagePicker();
  final rightPicker = ImagePicker();
  late BuildContext original;

// ***** FUNCTIONS *****

// twilio auth keys
  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC4142b9df47f01a20604e4ee1dc64757d',
        authToken: '23a6f52b34b4802dfb052949e0512d13',
        twilioNumber: '+13855264060');

    super.initState();
  }

// random # generator (for ticket #)
  void getRandNum() {
    if (_ticketID == '') {
      var rndnumber = "";
      var rnd = new Random();
      for (var i = 0; i < 6; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      _ticketID = rndnumber;
    }
  }

// twilio SEND sms command
  void sendSMS(String number, String message) async {
    twilioFlutter.sendSMS(toNumber: '+1' + number, messageBody: message);
  }

// twilio GET sms command
  void getSMS() async {
    var data = await twilioFlutter.getSmsList();
    print(data);

    await twilioFlutter.getSMS('***************************');
  }

// ***** WIDGETS *****

// dropdown menu for hours
  List<DropdownMenuItem<int>> TimeList = [];
  void loadTimeList() {
    TimeList = [];
    TimeList.add(const DropdownMenuItem(
      child: Text('Hourly'),
      value: 0,
    ));
    TimeList.add(const DropdownMenuItem(
      child: Text('Overnight'),
      value: 1,
    ));
  }

  Widget build(BuildContext context) {
    loadTimeList();
    getRandNum();
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(),
        ));
  }

// all ticket inputs
  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];
    formWidget.add(Padding(
        padding: const EdgeInsets.only(bottom: 15),

        // top bar, with receipt #
        child: Text(
          'Ticket ID: $_ticketID',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w700,
            height: 0.1,
          ),
        )));

    // client name
    formWidget.add(TextFormField(
      keyboardType: TextInputType.name,
      decoration:
          const InputDecoration(labelText: 'Enter Name', hintText: 'Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name';
        }

        Pattern pattern = r'^[a-zA-Z ]+$';
        RegExp regex = RegExp(pattern.toString());

        if (!regex.hasMatch(value.toString())) {
          return 'Enter a valid name';
        } else {
          _nameValidation = true;
          return null;
        }
      },
      onSaved: (value) {
        _name = value.toString();
        setState(() {});
      },
    ));

    // phone number VALIDATOR
    validateNumber(String? value) {
      if (value!.isEmpty) {
        return 'Please enter phone number';
      }
      Pattern pattern = r'^[0-9]{10}$';
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value.toString())) {
        return 'Enter Valid Number';
      } else {
        _phoneNumValidation = true;
        return null;
      }
    }

    // client phone number
    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          labelText: 'Enter Phone Number', hintText: 'Number'),
      keyboardType: TextInputType.number,
      validator: validateNumber,
      onSaved: (value) {
        setState(() {
          _phoneNumber = value.toString();
        });
      },
    ));

// **** SEND CONFIRMATION (send SMS functionality + bottom popup) ****

    void smsPressedSubmit() {
      if (_nameValidation == true && _phoneNumValidation == true) {
        _sendConfirmationBtnPressed = true;

        sendSMS(_phoneNumber,
            "Thanks for using GreenValet $_name! Your ticket # is $_ticketID");

        final snackBar = SnackBar(
          content: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: const Padding(
                padding: EdgeInsets.fromLTRB(105, 0, 0, 0),
                child:
                    Text('Confirmation Sent', style: TextStyle(fontSize: 20))),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _formKey.currentState?.validate();
        _formKey.currentState?.save();
      } else {
        _formKey.currentState!.validate();
        _formKey.currentState?.save();
      }
    }

    // button designs
    final ButtonStyle style1 = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 17),
      backgroundColor: _sendConfirmationBtnPressed ? Colors.green : Colors.blue,
    );
    final ButtonStyle style2 = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 17),
      backgroundColor: _createTicketBtnPressed ? Colors.green : Colors.blue,
    );

    // send confirmation button
    formWidget.add(Container(
        margin: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: smsPressedSubmit,
            style: style1,
            child: const Text('Send Confirmation'))));

    // **** TIME DROPDOWN ****
    formWidget.add(DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Select Time'),
      hint: const Text('Select Time'),
      items: TimeList,
      value: _shiftPeriod,
      onChanged: (value) {
        setState(() {
          _shiftPeriod = int.parse(value.toString());
        });
      },
      isExpanded: true,
      menuMaxHeight: 800,
    ));

// **** VEHICLE & PARKING INFO ****

    // vehicle brand
    formWidget.add(TextFormField(
      decoration:
          const InputDecoration(hintText: 'Brand', labelText: "Enter Brand"),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter the brand';
        }
        Pattern pattern = r'^[a-zA-Z ]+$';
        RegExp regex = RegExp(pattern.toString());

        if (!regex.hasMatch(value.toString())) {
          return 'Enter a valid brand';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _brand = value.toString();
        });
      },
    ));

    // vehicle model
    formWidget.add(TextFormField(
      decoration:
          const InputDecoration(hintText: 'Model', labelText: "Enter Model"),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter model';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _model = value.toString();
        });
      },
    ));

    // vehicle license plate #
    formWidget.add(TextFormField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          hintText: 'License', labelText: 'Enter License Number'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter license number';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _license = value.toString();
        });
      },
    ));

    // vehicle color
    formWidget.add(TextFormField(
      keyboardType: TextInputType.text,
      decoration:
          const InputDecoration(labelText: 'Enter Color', hintText: 'Color'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter color of the car';
        }

        Pattern pattern = r'^[a-zA-Z]+$';
        RegExp regex = RegExp(pattern.toString());

        if (!regex.hasMatch(value.toString())) {
          return 'Enter a valid color';
        } else {
          // _nameValidation = true;
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _color = value.toString();
        });
      },
    ));

    // parking spot
    formWidget.add(TextFormField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: 'Enter Parking Spot', hintText: 'Parking'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a parking spot';
        }

        Pattern pattern = r'^[a-zA-Z0-9]+$';
        RegExp regex = RegExp(pattern.toString());

        if (!regex.hasMatch(value.toString())) {
          return 'Enter a valid parking spot';
        } else {
          // _nameValidation = true;
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _parkingSpot = value.toString();
        });
      },
    ));

// ***** CAMERA IMPLEMENTATION *****

    // FRONT
    void frontCamera() async {
      var imgCamera = await frontPicker.getImage(source: ImageSource.camera);
      setState(() {
        frontImg = File(imgCamera!.path);
        _front = true;
      });
      Navigator.of(context).pop();
    }

    Future<void> frontBuffer(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          frontCamera();
          return const AlertDialog();
        },
      );
    }

    // BACK
    void backCamera() async {
      var imgCamera = await backPicker.getImage(source: ImageSource.camera);
      setState(() {
        backImg = File(imgCamera!.path);
        _back = true;
      });
      Navigator.of(context).pop();
    }

    Future<void> backBuffer(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          backCamera();
          return const AlertDialog();
        },
      );
    }

    // LEFT
    void leftCamera() async {
      var imgCamera = await leftPicker.getImage(source: ImageSource.camera);
      setState(() {
        leftImg = File(imgCamera!.path);
        _left = true;
      });
      Navigator.of(context).pop();
    }

    Future<void> leftBuffer(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          leftCamera();
          return const AlertDialog();
        },
      );
    }

    // RIGHT
    void rightCamera() async {
      var imgCamera = await rightPicker.getImage(source: ImageSource.camera);
      setState(() {
        rightImg = File(imgCamera!.path);
        _right = true;
      });
      Navigator.of(context).pop();
    }

    Future<void> rightBuffer(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          rightCamera();
          return const AlertDialog();
        },
      );
    }

    formWidget.add(Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20),
        child: const Text('Damages', style: TextStyle(fontSize: 30))));

    formWidget.add(Row(
      children: [
        if (_front == false) ...[
          Container(
            width: 140,
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                frontBuffer(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Front'),
            ),
          ),
        ],
        if (_front == true) ...[
          Container(
            width: 140,
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                original = context;
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Front Side'),
                    content: Image.file(
                      frontImg,
                      height: 400,
                      width: 500,
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: const Text('Retake Image'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Future.delayed(
                            const Duration(seconds: 2),
                            (() {
                              frontBuffer(original);
                            }),
                          );
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Exit'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Front - [View]'),
            ),
          ),
        ],
        if (_back == false) ...[
          Container(
            margin: const EdgeInsets.all(15.0),
            width: 140,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () {
                backBuffer(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Back'),
            ),
          ),
        ],
        if (_back == true) ...[
          Container(
            width: 140,
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                original = context;
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Back Side'),
                    content: Image.file(
                      backImg,
                      height: 400,
                      width: 500,
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: const Text('Retake Image'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Future.delayed(
                            const Duration(seconds: 2),
                            (() {
                              backBuffer(original);
                            }),
                          );
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Exit'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Back - [View]'),
            ),
          ),
        ],
      ],
    ));
    formWidget.add(Row(
      children: [
        if (_left == false) ...[
          Container(
            width: 140,
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () {
                leftBuffer(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Left'),
            ),
          ),
        ],
        if (_left == true) ...[
          Container(
            width: 140,
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                original = context;
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Left Side'),
                    content: Image.file(
                      leftImg,
                      height: 400,
                      width: 500,
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: const Text('Retake Image'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Future.delayed(
                            const Duration(seconds: 2),
                            (() {
                              leftBuffer(original);
                            }),
                          );
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Exit'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Left - [View]'),
            ),
          ),
        ],
        if (_right == false) ...[
          Container(
            width: 140,
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () {
                rightBuffer(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Right'),
            ),
          ),
        ],
        if (_right == true) ...[
          Container(
            width: 140,
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                original = context;
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Right Side'),
                    content: Image.file(
                      rightImg,
                      height: 400,
                      width: 500,
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: const Text('Retake Image'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Future.delayed(
                            const Duration(seconds: 2),
                            (() {
                              rightBuffer(original);
                            }),
                          );
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Exit'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Right - [View]'),
            ),
          ),
        ],
      ],
    ));

// ***** TICKET SUBMISSION *****

    void ticketPressedSubmit() {
      // submit ticket functionality + bottom popup
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        _createTicketBtnPressed = true;
        final snackBar = SnackBar(
          content: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: const Padding(
                padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                child: Text('Ticket Created', style: TextStyle(fontSize: 20))),
          ),
        );

        final Map<String, dynamic> receipt = {
          "ticketID": _ticketID,
          "name": _name,
          "phoneNum": _phoneNumber,
          "shift": _shiftPeriod,
          "brand": _brand,
          "model": _model,
          "license": _license,
          "color": _color,
          "parkingSpot": _parkingSpot
        };

        addValue(_ticketID, receipt);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    // submit ticket button
    formWidget.add(Container(
        margin: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: ticketPressedSubmit,
            style: style2,
            child: const Text('Create Ticket'))));

    return formWidget;
  }
}
