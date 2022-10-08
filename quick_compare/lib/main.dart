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

  int navigationindex=0;
  
  Widget EinStellungen(){
    return Column(
      children: [
        //hier kommt einstellungegn
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Quick Compare")),
      body: navigationindex==2?EinStellungen():Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.add,size: 30,))
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Steckdose ${index+1}",style: TextStyle(fontSize: 25.0),),
                    Divider(height: 5.0,color: Colors.transparent,),
                    Stack(
                      children:<Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(child: Text(""),width: MediaQuery.of(context).size.width,height: 50,decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                colors: [
                                  Colors.red,
                                  Colors.yellow,
                                  Colors.green,
                                ],
                                end: Alignment.centerRight,
                              ),
                            ),),
                          ],
                        ),
                      ]
                    ),
                    Divider(height: 40.0,color: Colors.transparent,),
                  ],
                );
              },
            ),
          ),
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.auto_graph),label: "Dashboard"),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart),label: "Graphen"),
              BottomNavigationBarItem(icon: Icon(Icons.settings),label:"Einstellungen"),
            ],

            currentIndex: navigationindex,
            onTap: (value) => setState(() {
               navigationindex=value;
            })
           )
        ]
      ),
    );
  }
}