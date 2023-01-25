import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SMS Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TwilioFlutter twilioFlutter;

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

  // TextEditingController textController = TextEditingController();
  String displayNum = "";
  String displayMes = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                // controller: textController,
                onChanged: (text) {
                  displayNum = text;
                },
                maxLines: null,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.blue),
                  hintText: "Enter the number",
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                // controller: textController,
                maxLines: 5,
                cursorColor: Colors.black,
                onChanged: (text) {
                  displayMes = text;
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.blue),
                  hintText: "Enter the message",
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendSms(displayNum, displayMes),
        tooltip: 'Send Sms',
        child: Icon(Icons.send),
      ),
    );
  }
}
