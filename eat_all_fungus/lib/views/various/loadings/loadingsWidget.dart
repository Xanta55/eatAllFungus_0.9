import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingWidget extends HookWidget {
  final String? loadingText;
  const LoadingWidget({Key? key, this.loadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Platform.isIOS
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                loadingText ?? '',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
