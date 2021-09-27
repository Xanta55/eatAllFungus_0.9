import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownWidget extends HookWidget {
  const TownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    return Container();
  }
}
