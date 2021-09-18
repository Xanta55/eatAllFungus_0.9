import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class LoadingScreen extends StatelessWidget {
  final String loadingText;
  const LoadingScreen({Key? key, required this.loadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eat All Fungus'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Platform.isIOS
              ? CupertinoActivityIndicator()
              : CircularProgressIndicator(),
          Text(loadingText),
        ],
      ),
    );
  }
}
