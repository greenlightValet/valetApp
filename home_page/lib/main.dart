import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'dart:math';

void main() {
  runApp(const FormApp());
}

class FormApp extends StatelessWidget {
  const FormApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket',
      theme: ThemeData.dark(),
      home: const FormPage(title: 'Ticket Home Page'),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

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
                  text: "Request",
                ),
                Tab(
                  icon: Icon(Icons.find_in_page_sharp),
                  text: "Logs",
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
              const MaterialApp(
                home: Center(child: Text("Add Logs")),
              ),
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

  String _name = '';
  String _number = '';
  String _brand = '';
  String _model = '';
  String _license = '';
  String _randNum = '';
  int _selectedTime = 0;
  bool _nameCheck = false;
  bool _numCheck = false;
  bool _hasBeenPressed1 = false; //for confirmation button
  bool _hasBeenPressed2 = false; //for ticket button

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

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC4142b9df47f01a20604e4ee1dc64757d',
        authToken: '84366f0bd9f306066f16cafa96aa5205',
        twilioNumber: '+13855264060');

    super.initState();
  }

  void sendSms(String number, String message) async {
    twilioFlutter.sendSMS(toNumber: '+1' + number, messageBody: message);
  }

  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);

    await twilioFlutter.getSMS('***************************');
  }

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

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];
    formWidget.add(Text(
      'Ticket ID: $_randNum',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w700,
        height: 2,
      ),
    ));

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

    void onPressedSubmit() {
      if (_nameCheck == true && _numCheck == true) {
        _hasBeenPressed1 = true;

        sendSms(_number, "Yo, testing sms feature with confirm button.");

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

    final ButtonStyle style1 = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 17),
      backgroundColor: _hasBeenPressed1 ? Colors.green : Colors.blue,
    );

    final ButtonStyle style2 = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 17),
      backgroundColor: _hasBeenPressed2 ? Colors.green : Colors.blue,
    );

    formWidget.add(Container(
        margin: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: onPressedSubmit,
            style: style1,
            child: const Text('Send Confirmation'))));

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

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          hintText: 'Brand', labelText: "Enter the car's brand"),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter the brand';
        }
        Pattern pattern = r'^[a-zA-Z]+$';
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

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          hintText: 'Model', labelText: "Enter the car's model"),
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

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          hintText: 'License', labelText: 'Enter the license number'),
      keyboardType: TextInputType.number,
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

    void onPressedSubmit1() {
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
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    formWidget.add(Container(
        margin: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: onPressedSubmit1,
            style: style2,
            child: const Text('Create Ticket'))));

    return formWidget;
  }
}
