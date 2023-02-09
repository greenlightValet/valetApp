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
  @override
  Widget build(BuildContext context) {
    //var appBar = AppBar();

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
                child: const RespondScreen(),
              ),
              Container(
                height: (MediaQuery.of(context).size.height - 115) / 2,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 201, 228, 250),
                child: const WaitingScreen(),
              ),
            ],
          )),
    );
  }
}

class RespondScreen extends StatefulWidget {
  const RespondScreen({super.key});

  @override
  State<RespondScreen> createState() => _RespondScreenState();
}

class _RespondScreenState extends State<RespondScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
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
            SingleChildScrollView(
              child: Column(
                children: List.generate(
                  respondList.length,
                  (index) {
                    //maybe leave out the Container cuz i wont need borders
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                respondList[index]["name"],
                                style: const TextStyle(fontSize: 24),
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
                                style: const TextStyle(fontSize: 12),
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
                                            BorderRadius.circular(40)),
                                    elevation: 16,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        const SizedBox(height: 20),
                                        const Center(
                                            child: Text('Select Time')),
                                        const SizedBox(height: 20),
                                        Column(
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Accept(index);
                                                },
                                                child: const Text("now")),
                                            TextButton(
                                                onPressed: () {
                                                  Accept(index);
                                                },
                                                child: const Text("5 min")),
                                            TextButton(
                                                onPressed: () {
                                                  Accept(index);
                                                },  
                                                child: const Text("10 min")),
                                            TextButton(
                                                onPressed: () {
                                                  Accept(index);
                                                },
                                                child: const Text("15 min")),
                                            TextButton(
                                                onPressed: () {
                                                  Accept(index);
                                                },
                                                child: const Text("20 min")),
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
            //a list with requests goes after title
          ],
        ),
      ),
    );
  }
}

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
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
            //a list with requests goes after title
            SingleChildScrollView(
              child: Column(
                children: List.generate(
                  waitingList.length,
                  (index) {
                    //maybe leave out the Container cuz i wont need borders
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                                    ', ' +
                                    '${waitingList[index]["model"]}' +
                                    ', ' +
                                    waitingList[index]["color"],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          //timer
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
    );
  }
}

void Accept(int index) {
  Map map = {
    "name": '',
    "id": '',
    "model": '',
    "make": '',
    "color": '',
    "location": '',
  };
  map["name"] = respondList[index]["name"];
  map["id"] = respondList[index]["id"];
  map["model"] = respondList[index]["model"];
  map["make"] = respondList[index]["make"];
  map["color"] = respondList[index]["color"];
  map["location"] = respondList[index]["location"];
  waitingList.add(map);
  respondList.removeAt(index);
}
