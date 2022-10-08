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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
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
                                  // use your preferred colors
                                  Colors.red,
                                  Colors.yellow,
                                  Colors.green,
                                ],
                                // start at the top
                                // end at the bottom
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
          )
        ]
      ),
    );
  }
}