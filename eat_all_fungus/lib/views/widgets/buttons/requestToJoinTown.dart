import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

ElevatedButton RequestToJoinButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () => context.read(townStreamProvider.notifier).requestJoin(),
    child: Center(
      child: Text('Request to join Town'),
    ),
  );
}
