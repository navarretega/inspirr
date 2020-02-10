import 'package:flutter/material.dart';
import 'package:inspirr/app/intro_page.dart';
import 'package:inspirr/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Montserrat'),
        home: IntroPage(),
      ),
    );
  }
}
