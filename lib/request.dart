import 'dart:async';

import 'package:flutter/material.dart';
import 'data.dart';

void main(List<String> args) {
  runApp(const RequestPage());
}

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Request(),
    );
  }
}

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  Duration duration = const Duration(); //(minutes: widget.minutes);
  Timer? timer;

  void reduceTime() {
    const int reduceSecond = 1;
    setState(() {
      final seconds = duration.inSeconds - reduceSecond;

      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => reduceTime());
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    //var appBar = AppBar();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int time;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Page'),
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              // RespondScreen(),
              // WaitingScreen(),
              Container(
                //height is -115 because the app bar is 115. For Android may be different. Still figuring it out
                //var height = Scaffold.of(context).appBarMaxHeight;
                //maybe move Align(...) into a new widget?function? and use^^
                height: (MediaQuery.of(context).size.height - 115) / 2,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 225, 223),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: const Color.fromARGB(255, 248, 157, 151),
                    // decoration: BoxDecoration(
                    //   border: Border.all(width: 6.0, color:Colors.black,),
                    // ),

                    child: Column(
                      children: [
                        //title
                        Container(
                          height: 40,
                          width: width,
                          color: const Color.fromARGB(255, 245, 113, 104),
                          child: const Text(
                            'Respond for Requests',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        //make it scrollable!!!
                        //list of requests
                        SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              respondList.length,
                              (index) {
                                //maybe leave out the Container cuz i wont need borders
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            respondList[index]["name"],
                                            style:
                                                const TextStyle(fontSize: 24),
                                          ),
                                          Text(
                                            respondList[index]["location"] +
                                                ', ' +
                                                '${respondList[index]["id"]}' +
                                                ', ' +
                                                respondList[index]["make"] +
                                                ', ' +
                                                '${respondList[index]["model"]}' +
                                                ', ' +
                                                respondList[index]["color"],
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                elevation: 16,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: <Widget>[
                                                    const SizedBox(height: 20),
                                                    const Center(
                                                        child: Text(
                                                            'Select Time')),
                                                    const SizedBox(height: 20),
                                                    Column(
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              time = 0;
                                                              Accept(
                                                                  index, time);
                                                                  duration = Duration(minutes: time);
                                                              startTimer();
                                                            },
                                                            child: const Text(
                                                                "now")),
                                                        TextButton(
                                                            onPressed: () {
                                                              time = 5;
                                                              Accept(
                                                                  index, time);
                                                                  duration = Duration(minutes: time);
                                                              startTimer();
                                                            },
                                                            child: const Text(
                                                                "5 min")),
                                                        TextButton(
                                                            onPressed: () {
                                                              time = 10;
                                                              Accept(
                                                                  index, time);
                                                                  duration = Duration(minutes: time);
                                                              startTimer();
                                                            },
                                                            child: const Text(
                                                                "10 min")),
                                                        TextButton(
                                                            onPressed: () {
                                                              time = 15;
                                                              Accept(
                                                                  index, time);
                                                                  duration = Duration(minutes: time);
                                                              startTimer();
                                                            },
                                                            child: const Text(
                                                                "15 min")),
                                                        TextButton(
                                                            onPressed: () {
                                                              time = 20;
                                                              Accept(
                                                                  index, time);
                                                                  duration = Duration(minutes: time);
                                                              startTimer();
                                                            },
                                                            child: const Text(
                                                                "20 min")),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: const Text('Accept'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height - 115) / 2,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 201, 228, 250),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: height,
                    width: width,
                    color: const Color.fromARGB(255, 137, 199, 249),
                    // decoration: BoxDecoration(
                    //   border: Border.all(width: 6.0, color:Colors.black,),
                    // ),

                    //make a scrollable list with a title

                    child: Column(
                      children: [
                        Container(
                            height: 40,
                            width: width,
                            color: const Color.fromARGB(255, 86, 170, 240),
                            child: const Text(
                              'Waiting for Requests',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        //list of accepted requests
                        SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              waitingList.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            waitingList[index]["name"],
                                            style:
                                                const TextStyle(fontSize: 24),
                                          ),
                                          Text(
                                            waitingList[index]["location"] +
                                                ', ' +
                                                '${waitingList[index]["id"]}' +
                                                ', ' +
                                                waitingList[index]["make"] +
                                                ', ' +
                                                '${waitingList[index]["model"]}' +
                                                ', ' +
                                                waitingList[index]["color"] +
                                                ', ' +
                                                '${waitingList[index]["time"]}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      //timer
                                      // BuildTime(duration: Duration(minutes: waitingList[index]["time"]))
                                      Text(
                                        '$minutes:$seconds',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

void Accept(int index, int time) {
  Map map = {
    "name": '',
    "id": '',
    "model": '',
    "make": '',
    "color": '',
    "location": '',
    "time": 0,
  };
  map["name"] = respondList[index]["name"];
  map["id"] = respondList[index]["id"];
  map["model"] = respondList[index]["model"];
  map["make"] = respondList[index]["make"];
  map["color"] = respondList[index]["color"];
  map["location"] = respondList[index]["location"];
  map["time"] = time;
  waitingList.add(map);
  respondList.removeAt(index);
}
