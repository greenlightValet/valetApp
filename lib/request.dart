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
            const SizedBox(
              width: double.infinity,
              //height: 30,
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
            Column(
              children: List.generate(
                respondList.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
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
                                    ' ' +
                                    '${respondList[index]["model"]}' +
                                    ', ' +
                                    respondList[index]["color"],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: showTime(index),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                respondList.removeAt(index);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text("Done"),
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

Widget showTime(int index) {
  return Text("${(index + 1) * 5} min",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: getColor(index),
      ));
}

Color getColor(int index) {
  if (index < 2) {
    return Colors.green;
  } else if (index < 4) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

List<Map> respondList = [
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
