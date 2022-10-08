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
  int navigationindex = 1;
  var raume = ["Deafault"];
  String raumwahl = "Deafault";
  var steckdosen = [
    []
  ];
  var steckdosenWerteProzent = [
    []
  ];

  TextEditingController steckcontroller = TextEditingController();

  Widget EditRooms(){
    return ListView.builder(
      itemCount: raume.length,
      itemBuilder: (context, index) {
        return Row(
          children: <Widget>[
            Text(raume[index]),
            IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
            IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
          ],
        );
      },
    );
  }

  Widget Einstellungen() {
    return Column(
      children: [
        Expanded(child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Theme",style: TextStyle(fontSize: 20),),
                Switch(value: false, onChanged:(value) {
                setState(() {
                  value=!value;
                  });
                },)
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: (){

                },
                child: Text("Räume bearbeiten",style: TextStyle(fontSize: 20, color: Colors.red),),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: (){
                  raume = ["Deafault"];
                  raumwahl = "Deafault";
                  var steckdosen = [
                    []
                  ];
                  var steckdosenWerteProzent = [
                    []
                  ];
                },
                child: Text("Alles Löschen",style: TextStyle(fontSize: 20, color: Colors.red),),
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
                                            content: Text('Ungültiger Name'),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }else{
                                          steckdosen[raume.indexOf(raumwahl)].add(steckcontroller.text);
                                          steckdosenWerteProzent[raume.indexOf(raumwahl)].add(100);
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
                                    left: MediaQuery.of(context).size.width/(100/steckdosenWerteProzent[raume.indexOf(raumwahl)][index])<MediaQuery.of(context).size.width-3 ? MediaQuery.of(context).size.width/(100/steckdosenWerteProzent[raume.indexOf(raumwahl)][index]) : MediaQuery.of(context).size.width-3,
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
                      icon: Icon(Icons.bar_chart), label: "Dashboard"),
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
