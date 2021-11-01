//import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownWidget extends HookWidget {
  const TownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final tileStream = useProvider(mapTileStreamProvider);
    final townStream = useProvider(townStreamProvider);
    final playerStream = useProvider(playerStreamProvider);
    if (townStream != null) {
      if (townStream.members.contains(playerStream?.id)) {
        return Container(
          child: Center(
            child: Text('$townStream'),
          ),
        );
      } else {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'You are not a member of this town, but you can request access at any time.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
      }
    } else {
      return Container(
        child: Center(
          child: Text('Loading Town'),
        ),
      );
    }
  }
}
