import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}
