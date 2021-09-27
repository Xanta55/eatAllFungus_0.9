import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingScreen extends HookWidget {
  final String loadingText;
  const LoadingScreen({Key? key, required this.loadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eat All Fungus',
          textAlign: TextAlign.center,
        ),
      ),
      body: LoadingWidget(loadingText: loadingText),
    );
  }
}
