import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/views/auth/login.dart';
import 'package:eat_all_fungus/views/various/loadingScreen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class EatAllFungus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat All Fungus',
      theme: ThemeData(
          //Colortheme: Amber
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
          brightness: Brightness.dark),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // getting/ setting up the provider
    final authControllerState = useProvider(authControllerProvider);

    // checking if provider is initialized
    if (authControllerState != null) {
      if (!authControllerState.isAnonymous) {
        return LoadingScreen(loadingText: 'TBD');
      } else {
        return Login();
      }

      // for now we just return a loading screen instead of splash
    } else {
      return LoadingScreen(loadingText: 'Loading Database Connection');
    }
  }
}
