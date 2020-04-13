import 'package:flutter/material.dart';
import 'package:ipawa/Screens/pawa_list.dart';
import 'package:ipawa/Screens/pawa_detail.dart';

void main() {
  runApp(PawaApp());
}

class PawaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawaList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PawaList(),
    );
  }
}
