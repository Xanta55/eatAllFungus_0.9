import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/views/auth/loginScreen.dart';
import 'package:eat_all_fungus/views/preGame/getIntoGameWrapper.dart';
import 'package:eat_all_fungus/views/loadings/loadingScreen.dart';
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
      return ProviderListener(
          provider: userProfileExceptionProvider,
          onChange: (BuildContext context,
              StateController<CustomException?> customException) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red[400],
                content: Text(customException.state!.message!)));
          },
          child: profileControllerState.data == null
              ? LoadingScreen(loadingText: 'Loading Profile')
              : GetIntoGameWrapper());
      // for now we just return a loading screen instead of splash

    } else {
      return LoginScreen();
    }
  }
}
