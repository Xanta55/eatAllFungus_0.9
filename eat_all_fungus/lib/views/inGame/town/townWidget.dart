import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownWidget extends HookWidget {
  const TownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileStream = useProvider(mapTileStreamProvider);
    final townStream = useProvider(townStreamProvider);
    if (townStream != null) {
      return Container(
        child: Center(
          child: Text('$townStream'),
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text('Loading Town'),
        ),
      );
    }
  }
}
