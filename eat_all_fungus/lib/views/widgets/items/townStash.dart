import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/inGame/overview/overviewSubWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownStash extends HookWidget {
  const TownStash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final townStream = useProvider(townStreamProvider);
    final playerStream = useProvider(playerStreamProvider);
    if (townStream?.members.contains(playerStream?.id) ?? false) {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'You need to be a member of this town to access a personal item-stash',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
  }
}
