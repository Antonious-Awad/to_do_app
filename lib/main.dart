import 'package:flutter/material.dart';
// @dart=2.9
import 'package:to_do_app/layout/home_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
