import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuickCompare(),
    );
  }
}

class QuickCompare extends StatefulWidget {
  const QuickCompare({super.key});

  @override
  State<QuickCompare> createState() => _QuickCompareState();
}

class _QuickCompareState extends State<QuickCompare> {
  int navigationindex = 0;
  var raume = ["Schlafzimmer"];
  String raumwahl = "Schlafzimmer";
  var steckdosen = [
    ["Steckdose 1"]
  ];
  var steckdosenWerteProzent = [
    [25]
  ];

  TextEditingController steckcontroller = TextEditingController();

  Widget Einstellungen() {
    return Column(
      children: [
        //hier kommt einstellungegn
        Expanded(child: Text("abc")),
        BottomNavigationBar(
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.auto_graph), label: "Dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: "Graphen"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Einstellungen"),
          ],
          currentIndex: navigationindex,
          onTap: (value) => setState(() {
                navigationindex = value;
        }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quick Compare")),
      body: navigationindex == 2
          ? Einstellungen()
          : Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              children: <Widget>[
                                TextField(
                                  controller: steckcontroller,
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (!steckcontroller.text.contains(RegExp('^[a-zA-Z]*')) || steckdosen[raume.indexOf(raumwahl)].contains(steckcontroller.text) || steckcontroller.text.contains(RegExp(r'^[ ]+$')) || steckcontroller.text==""){
                                          const snackBar = SnackBar(
                                            content: Text('Yay! A SnackBar!'),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }else{
                                          steckdosen[raume.indexOf(raumwahl)].add(steckcontroller.text);
                                          steckcontroller.text="";
                                        }
                                      });
                                    },
                                    child: const Text("Add"))
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      )),
                  DropdownButton<String>(
                    items: raume
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    value: raumwahl,
                    onChanged: (val) {
                      setState(() {
                        raumwahl = val as String;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: steckdosen[raume.indexOf(raumwahl)].length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          steckdosen[raume.indexOf(raumwahl)][index],
                          style: TextStyle(fontSize: 25.0),
                        ),
                        const Divider(
                          height: 5.0,
                          color: Colors.transparent,
                        ),
                        Stack(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        colors: [
                                          Colors.red,
                                          Colors.yellow,
                                          Colors.green,
                                        ],
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                    child: const Text(""),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: MediaQuery.of(context).size.width/(100/steckdosenWerteProzent[0][0]),
                                    child: Container(
                                      width: 10,
                                      height: 50,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              )
                              //////



                            ],
                          ),
                        ]),
                        const Divider(
                          height: 40.0,
                          color: Colors.transparent,
                        ),
                      ],
                    );
                  },
                ),
              ),
              BottomNavigationBar(
                showUnselectedLabels: false,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.auto_graph), label: "Dashboard"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart), label: "Graphen"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Einstellungen"),
                ],
                currentIndex: navigationindex,
                onTap: (value) => setState(() {
                      navigationindex = value;
                    }))
            ]),
    );
  }
}
