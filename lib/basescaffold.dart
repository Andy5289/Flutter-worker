import 'package:flutter/material.dart';
import 'navdrawer.dart'; // Import your navigation drawer

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const SideNavigationBar(), // Navigation drawer
      body: body,
    );
  }
}
