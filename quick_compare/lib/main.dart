import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const List<String> languages = <String>[
  'Deutsch',
  'English',
  'Français',
  'Español'
];

void main() async {
  Future<bool> sumStream() async {
    try{
    var url = Uri.parse('http://94.45.226.208/');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    }on Exception{print("error");}
    return true;
  }
  const oneSec = Duration(seconds:1);
  Timer.periodic(oneSec, (Timer t) {
    sumStream();
  });
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
  String lang = languages.first;
  int navigationindex = 1;
  var raume = ["Default"];
  String raumwahl = "Default";
  var steckdosen = [[]];
  var steckdosenWerteProzent = [[]];
  var updateSockets = ValueNotifier<bool>(false);
  bool isEditRooms = false;
  bool isEditSockets = false;
  TextEditingController raumecontroller = TextEditingController();
  TextEditingController steckcontroller = TextEditingController();
  TextEditingController raumeeditcontroller = TextEditingController();
  TextEditingController steckeditcontroller = TextEditingController();

  Widget EditRooms() {
    return ListView.builder(
      itemCount: raume.length,
      itemBuilder: (context, index) {
        return Row(
          children: <Widget>[
            Text(raume[index]),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Column(
                        children: [
                          Text("Neue Raum Name:"),
                          TextField(
                            controller: raumeeditcontroller,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text("Abrechen"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              raume[index] = raumeeditcontroller.text;
                              raumeeditcontroller.text = "";
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text("Ok"),
                        )
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit),
              color: raume.length == 1 ? Colors.grey : Colors.black,
            ),
            IconButton(
              onPressed: () {
                if (raume.length > 1) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('${raume[index]} löschen?'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'Willst du den Raum "${raume[index]}" wirklich löschen?'),
                                const Text(
                                    'Alle sich in diesem Raum befindlichen Steckdosen werden auch gelöscht.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      child: const Text('Abbrechen'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Align(
                                    widthFactor: 0.5,
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        setState(() {
                                          steckdosen.removeAt(index);
                                          steckdosenWerteProzent
                                              .removeAt(index);
                                          raume.removeAt(index);
                                          raumwahl = raume[0];
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('${raume[index]} löschen?'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                  'Du kannst den Raum "${raume[index]}" nicht löschen.',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Align(
                                    widthFactor: 0.5,
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      });
                }
              },
              icon: Icon(Icons.delete),
              color: raume.length == 1 ? Colors.grey : Colors.black,
            ),
          ],
        );
      },
    );
  }

  Widget EditSocket() {
    return Column(
      children: [
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
        Expanded(
          child: ListView.builder(
            itemCount: steckdosen[raume.indexOf(raumwahl)].length,
            itemBuilder: (context, index) {
              return Row(
                children: <Widget>[
                  Text(steckdosen[raume.indexOf(raumwahl)][index]),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              children: [
                                Text("Neue Steckdosen Name:"),
                                TextField(
                                  controller: steckeditcontroller,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text("Abrechen"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    steckdosen[raume.indexOf(raumwahl)][index] =
                                        steckeditcontroller.text;
                                    steckeditcontroller.text = "";
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text("Ok"),
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  '${steckdosen[raume.indexOf(raumwahl)][index]} löschen?'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Willst du die Steckdose "${steckdosen[raume.indexOf(raumwahl)][index]}" wirklich löschen?'),
                                    const Text(
                                        'Diese Aktion kann nicht rückgängig gemacht werden.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          child: const Text('Abbrechen'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Align(
                                        widthFactor: 0.5,
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            steckdosen[raume.indexOf(raumwahl)]
                                                .removeAt(index);
                                            updateSockets.value =
                                                !updateSockets.value;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget Einstellungen() {
    return Column(
      children: [
        Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Theme",
                  style: TextStyle(fontSize: 20),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      value = !value;
                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sprache",
                  style: TextStyle(fontSize: 20),
                ),
                DropdownButton<String>(
                  value: lang,
                  onChanged: (String? value) {
                    setState(() {
                      lang = value!;
                    });
                  },
                  items:
                      languages.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isEditSockets = true;
                  });
                },
                child: const Text(
                  "Steckdosen bearbeiten",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isEditRooms = true;
                  });
                },
                child: const Text(
                  "Räume bearbeiten",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () {
                  raume = ["Default"];
                  raumwahl = "Default";
                  steckdosen = [[]];
                  steckdosenWerteProzent = [[]];
                },
                child: const Text(
                  "Alles Löschen",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ),
          ],
        )),
        BottomNavigationBar(
            showUnselectedLabels: false,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.auto_graph), label: "Graphen"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: "Dashboard"),
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
      appBar: AppBar(
        title: Text("Quick Compare"),
        leading: isEditRooms || isEditSockets
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isEditRooms = false;
                    isEditSockets = false;
                    navigationindex = 2;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        actions: isEditRooms
            ? [
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Add Raum"),
                            content: TextField(
                              controller: raumecontroller,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Abrechen")),
                              TextButton(
                                  onPressed: () {
                                    if (!steckcontroller.text
                                            .contains(RegExp('^[a-zA-Z]*')) ||
                                        raume.contains(raumecontroller.text)) {
                                      const snackBar = SnackBar(
                                        content: Text('Ungültiger Name'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      setState(() {
                                        raume.add(raumecontroller.text);
                                        raumwahl == raumecontroller.text;
                                        steckdosen.add([]);
                                        steckdosenWerteProzent.add([]);
                                        raumecontroller.text == "";
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  child: Text("Add"))
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add))
              ]
            : null,
      ),
      body: navigationindex == 2 && isEditRooms
          ? EditRooms()
          : navigationindex == 2 && isEditSockets
              ? EditSocket()
              : navigationindex == 2
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
                                                if (!steckcontroller.text
                                                        .contains(RegExp(
                                                            '^[a-zA-Z]*')) ||
                                                    steckdosen[raume
                                                            .indexOf(raumwahl)]
                                                        .contains(
                                                            steckcontroller
                                                                .text) ||
                                                    steckcontroller.text
                                                        .contains(RegExp(
                                                            r'^[ ]+$')) ||
                                                    steckcontroller.text ==
                                                        "") {
                                                  const snackBar = SnackBar(
                                                    content:
                                                        Text('Ungültiger Name'),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else {
                                                  steckdosen[raume
                                                          .indexOf(raumwahl)]
                                                      .add(
                                                          steckcontroller.text);
                                                  steckdosenWerteProzent[raume
                                                          .indexOf(raumwahl)]
                                                      .add(0);
                                                  steckcontroller.text = "";
                                                  updateSockets.value =
                                                      !updateSockets.value;
                                                  Navigator.of(context).pop();
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                colors: [
                                                  Colors.green,
                                                  Colors.yellow,
                                                  Colors.red,
                                                ],
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                            child: const Text(""),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: MediaQuery.of(context).size.width /
                                                        (100 /
                                                            steckdosenWerteProzent[
                                                                    raume.indexOf(
                                                                        raumwahl)]
                                                                [index]) <
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        3
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    (100 /
                                                        steckdosenWerteProzent[
                                                                raume.indexOf(
                                                                    raumwahl)]
                                                            [index])
                                                : MediaQuery.of(context).size.width - 3,
                                            child: Container(
                                              width: 3,
                                              height: 50,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      )
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
                                icon: Icon(Icons.auto_graph), label: "Graphen"),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.bar_chart),
                                label: "Dashboard"),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.settings),
                                label: "Einstellungen"),
                          ],
                          currentIndex: navigationindex,
                          onTap: (value) => setState(() {
                                navigationindex = value;
                              }))
                    ]),
    );
  }
}
