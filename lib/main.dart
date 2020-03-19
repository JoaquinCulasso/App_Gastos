import 'package:expenses/Views/AddPages.dart';
import 'package:flutter/material.dart';

import 'Views/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gastos Mensuales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/add': (BuildContext context) => AddPages(),
      },
    );
  }
}
