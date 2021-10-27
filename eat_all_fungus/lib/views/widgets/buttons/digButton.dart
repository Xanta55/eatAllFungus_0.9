import 'package:eat_all_fungus/controllers/functionsController.dart';
import 'package:eat_all_fungus/providers/streams/digTaskStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DigButton extends HookWidget {
  const DigButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final digTaskStream = useProvider(digTaskStreamProvider);
    if (DateTime.now()
        .isAfter(digTaskStream ?? DateTime.now().add(Duration(hours: 1)))) {
      print('Able to dig! Last Timestamp: $digTaskStream');
      return Container(
        child: ElevatedButton(
          child: Container(
            child: Text('Dig on this Tile!'),
          ),
          onPressed: () {
            print('Trying to call dig-function');
            context.read(functionControllerProvider).callDigFunction();
          },
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text(
            'You have dug here not so long ago. Try again at ${digTaskStream?.hour ?? "00"}:${digTaskStream?.minute ?? "00"}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
