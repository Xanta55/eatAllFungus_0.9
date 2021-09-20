import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/controllers/profileController.dart';
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
    final profileControllerState = useProvider(profileControllerProvider);

    // checking if provider is initialized
    if (authControllerState != null) {
      return LoadingScreen(
          loadingText:
              'displayName: ${profileControllerState.data?.value.name}\nUID: ${authControllerState.uid}');
      // for now we just return a loading screen instead of splash
    } else {
      return Login();
    }
  }
}
