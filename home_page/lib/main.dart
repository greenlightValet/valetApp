import 'dart:html';

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: const ValetForm(),
      ),
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

  String _name = '';
  String _number = '';
  String _brand = '';
  String _model = '';
  String _license = '';
  int _selectedTime = 0;
  bool _nameCheck = false;
  bool _numCheck = false;

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
  Widget build(BuildContext context) {
    loadTimeList();
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    formWidget.add(TextFormField(
      decoration:
          const InputDecoration(labelText: 'Enter Name', hintText: 'Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name';
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

    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 17));

    formWidget.add(Container(
        margin: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: onPressedSubmit,
            style: style,
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
            style: style,
            child: const Text('Create Ticket'))));

    // This is for the menu bar but not working

    // formWidget.add(
    //   BottomNavigationBar(
    //       items: const <BottomNavigationBarItem>[
    //         BottomNavigationBarItem(
    //             icon: Icon(Icons.home),
    //             label: 'Home',
    //             backgroundColor: Colors.blue),
    //         BottomNavigationBarItem(
    //             icon: Icon(Icons.search),
    //             label: 'Search',
    //             backgroundColor: Colors.blue),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.person),
    //           label: 'Profile',
    //           backgroundColor: Colors.blue,
    //         ),
    //         BottomNavigationBarItem(
    //             icon: Icon(Icons.folder),
    //             label: 'Folder',
    //             backgroundColor: Colors.blue),
    //       ],
    //       type: BottomNavigationBarType.shifting,
    //       selectedItemColor: Colors.black,
    //       iconSize: 40,
    //       elevation: 5),
    // );

    return formWidget;
  }
}
