import 'package:basics/camera.dart';
import 'package:flutter/material.dart';
import 'sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

//first page

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String buttonName = "Click";
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("App Bar"),
        backgroundColor: Color(0xff155932),
      ),
      body: Center(
        child: currentIndex == 0
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Color(0xff155932),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonName = "clicked";
                        });
                      },
                      child: Text(buttonName),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Camera();
                        }));
                      },
                      child: Text(buttonName),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 163, 134, 32)),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return sms();
                        }));
                      },
                      child: Text(buttonName),
                    ),
                  ],
                ),
              )
            : Image.network(
                "https://images.unsplash.com/photo-1674908204018-26162dccf7f9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2370&q=80"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Color(0xff155932),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

// //Check page
// class Check extends StatefulWidget {
//   const Check({super.key});

//   @override
//   State<Check> createState() => _CheckState();
// }

// class _CheckState extends State<Check> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//     );
//   }
// }

// class sms extends StatefulWidget {
//   const sms({super.key});

//   @override
//   State<sms> createState() => _smsState();
// }

// class _smsState extends State<sms> {
//   @override
//   Widget build(BuildContext context) {
//     return sms();
//   }
// }
