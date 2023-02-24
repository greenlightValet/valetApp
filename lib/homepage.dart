import 'package:flutter/material.dart';
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
              //  MaterialApp(
              //   debugShowCheckedModeBanner: false,
              //   theme: ThemeData.dark(),
              //   title: "Request Page",
              //   home: const Center(child: Request()),
              // ),
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
  String _name = '';
  String _number = '';
  String _brand = '';
  String _model = '';
  String _license = '';
  String _randNum = '';
  String _color = '';
  String _parking = '';
  int _selectedTime = 0;
  bool _nameCheck = false;
  bool _numCheck = false;
  bool _hasBeenPressed1 = false; //for confirmation button
  bool _hasBeenPressed2 = false; //for ticket button

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

// ***** FUNCTIONS *****

// twilio auth keys
  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC4142b9df47f01a20604e4ee1dc64757d',
        authToken: 'f38debcceb6a9f48c0f4e1387cd933e0',
        twilioNumber: '+13855264060');

    super.initState();
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

// random # generator (for ticket #)
  void getRandNum() {
    if (_randNum == '') {
      var rndnumber = "";
      var rnd = new Random();
      for (var i = 0; i < 6; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      _randNum = rndnumber;
    }
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
          'Ticket ID: $_randNum',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w700,
            height: 0.1,
          ),
        )));

    // client name
    formWidget.add(TextFormField(
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
          _nameCheck = true;
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _name = value.toString();
        });
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
        _numCheck = true;
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
          _number = value.toString();
        });
      },
    ));

// **** SEND CONFIRMATION (send SMS functionality + bottom popup) ****

    void smsPressedSubmit() {
      if (_nameCheck == true && _numCheck == true) {
        _hasBeenPressed1 = true;

        sendSMS(_number,
            "Thanks for using GreenValet $_name! Your ticket # is $_randNum");

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
        _formKey.currentState!.validate();
        _formKey.currentState?.save();
      } else {
        _formKey.currentState!.validate();
        _formKey.currentState?.save();
      }
    }

    // button designs
    final ButtonStyle style1 = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 17),
      backgroundColor: _hasBeenPressed1 ? Colors.green : Colors.blue,
    );
    final ButtonStyle style2 = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 17),
      backgroundColor: _hasBeenPressed2 ? Colors.green : Colors.blue,
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
      value: _selectedTime,
      onChanged: (value) {
        setState(() {
          _selectedTime = int.parse(value.toString());
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
      keyboardType: TextInputType.number,
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
      keyboardType: TextInputType.number,
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
          _nameCheck = true;
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
          _nameCheck = true;
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _parking = value.toString();
        });
      },
    ));

// ***** CAMERA IMPLEMENTATION *****

    Widget displayImage(File img, bool side) {
      if (side == true) {
        return Image.file(img, height: 200, width: 100);
      } else {
        return const Text("");
      }
    }

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

    formWidget.add(Container(
      margin: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          frontBuffer(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (_front == true) {
                return Colors.green;
              } else {
                return Colors.blue;
              }
            },
          ),
        ),
        child: const Text('Front'),
      ),
    ));

    formWidget.add(
      Container(
          child: _front ? displayImage(frontImg, _front) : const SizedBox()),
    );

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

    formWidget.add(Container(
      margin: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          backBuffer(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (_back == true) {
                return Colors.green;
              } else {
                return Colors.blue;
              }
            },
          ),
        ),
        child: const Text('Back'),
      ),
    ));

    formWidget.add(
      Container(child: _back ? displayImage(backImg, _back) : const SizedBox()),
    );

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

    formWidget.add(Container(
      margin: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          leftBuffer(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (_left == true) {
                return Colors.green;
              } else {
                return Colors.blue;
              }
            },
          ),
        ),
        child: const Text('Left Side'),
      ),
    ));

    formWidget.add(
      Container(child: _left ? displayImage(leftImg, _left) : const SizedBox()),
    );

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
      margin: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          rightBuffer(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (_right == true) {
                return Colors.green;
              } else {
                return Colors.blue;
              }
            },
          ),
        ),
        child: const Text('Right Side'),
      ),
    ));

    formWidget.add(
      Container(
          child: _right ? displayImage(rightImg, _right) : const SizedBox()),
    );

// ***** TICKET SUBMISSION *****

    void ticketPressedSubmit() {
      print(_brand);
      print(_model);
      print(_license);

      final Map<String, dynamic> receipt = {
        "brand": _brand,
        "license": _license,
        "model": _model,
      };
      // receipt["brand"] = _brand;
      //  "name": _name,
      //   "number": _number,
      //   "brand": _brand,
      //   "model": _model,
      //   "license": _license,
      //   "randNum": _randNum,
      //   "color": _color,
      //   "parking": _parking,

      // submit ticket functionality + bottom popup
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        _hasBeenPressed2 = true;
        final snackBar = SnackBar(
          content: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: const Padding(
                padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                child: Text('Ticket Created', style: TextStyle(fontSize: 20))),
          ),
        );
        print(receipt);

        addValue(receipt);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      ;
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
