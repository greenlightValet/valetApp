import 'dart:async';

import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //title
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Waiting List",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  height: 2,
                ),
              ),
            ),
            //List
            Column(
              children: List.generate(
                waitingList.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        //name, location, etc.
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                waitingList[index]["name"],
                                style: const TextStyle(fontSize: 24),
                              ),
                              Text(
                                waitingList[index]["location"] +
                                    ', ' +
                                    '${waitingList[index]["id"]}' +
                                    ', ' +
                                    waitingList[index]["make"] +
                                    ' ' +
                                    '${waitingList[index]["model"]}' +
                                    ', ' +
                                    waitingList[index]["color"],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        //shows time
                        const Expanded(
                          flex: 1,
                          child: /*Text("time"), */Timers(),
                        ),
                        //done button
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              //Done prompt
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        const SizedBox(height: 20),
                                        const Center(
                                            child: Text(
                                                'Checking Out or Returning')),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    waitingList.removeAt(index);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    const Text("Checking Out")),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    waitingList.removeAt(index);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Returning")),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text("Accept"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//Timer
class Timers extends StatefulWidget {
  const Timers({super.key});

  @override
  State<Timers> createState() => _TimersState();
}

class _TimersState extends State<Timers> {
  Duration duration = const Duration(); 
  Timer? timer;

  void addTime() {
    const int addSecond = 1;
    setState(() {
      final seconds = duration.inSeconds + addSecond;

      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }
   @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text("${duration.inMinutes} min",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: getColor(duration.inMinutes),
        ));
  }
}

//determine color based on time
Color getColor(int time) {
  if (time < 5) {
    return Colors.green;
  } else if (time < 10) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

//waiting list
List<Map> waitingList = [
  {
    "name": 'Mimi',
    "id": 123495,
    "make": "toyota",
    "model": "111",
    "color": "gray",
    "location": "xavier",
  },
  {
    "name": 'Ryan',
    "id": 137425,
    "make": "audi",
    "model": "222",
    "color": "white",
    "location": "bel",
  },
  {
    "name": 'Haashim',
    "id": 337545,
    "make": "bmw",
    "model": "333",
    "color": "black",
    "location": "campion",
  },
  {
    "name": 'Jay',
    "id": 4252523,
    "make": "honda",
    "model": "444",
    "color": "red",
    "location": "murphy",
  },
  {
    "name": 'Alen',
    "id": 642754,
    "make": "hyundai",
    "model": "555",
    "color": "blue",
    "location": "home",
  },
];
