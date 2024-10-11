import 'package:flutter/material.dart';
import 'basescaffold.dart';

class food extends StatefulWidget {
  const food({super.key});

  @override
  State<food> createState() => _foodState();
}

class _foodState extends State<food> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Food",
      body: Center(
        child: Text("This is the Food screen"),
      ),
    );
  }
}
