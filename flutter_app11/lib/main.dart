import 'package:flutter/material.dart';
import 'package:flutter_app11/services/authentication.dart';
import 'package:flutter_app11/pages/root_page.dart';

import 'package:firebase_core/firebase_core.dart';
void main()  {


  runApp(new App());
  runApp(new MyApp());

}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
        future: _initialization

      // Check for errors
    );
  }
}
class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
