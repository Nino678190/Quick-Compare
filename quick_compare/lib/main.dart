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
      appBar: AppBar(title: Text("Quick Compare")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(color: Colors.green,child: Text(""),width: MediaQuery.of(context).size.width/3,),
                    Container(color: Colors.yellow,child: Text(""),width: MediaQuery.of(context).size.width/3,),
                    Container(color: Colors.red,child: Text(""),width:MediaQuery.of(context).size.width/3,)
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