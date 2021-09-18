import 'package:eat_all_fungus/views/auth/login.dart';
import 'package:eat_all_fungus/views/various/loadingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Get the google-services.json
// Run "pub get" after every pull

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat All Fungus',
      theme: ThemeData(
          //Colortheme: Amber
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
          brightness: Brightness.dark),
      home: FutureBuilder(
          future: _firebaseApp,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Login();
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return LoadingScreen(loadingText: '${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen(
                  loadingText: 'Getting connection to Database');
            } else {
              return LoadingScreen(
                  loadingText: 'Seems like we shouldnt be here...');
            }
          }),
    );
  }
}
