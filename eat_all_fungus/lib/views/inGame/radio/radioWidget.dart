import 'package:eat_all_fungus/models/radio/forum.dart';
import 'package:eat_all_fungus/models/radio/thread.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/views/inGame/radio/radioSubWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentForumProvider =
    StateProvider<Forum>((ref) => Forum(id: '', title: ''));
final currentThreadProvider =
    StateProvider<Thread>((ref) => Thread(id: '', title: ''));

class RadioWidget extends HookWidget {
  const RadioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = useProvider(playerStreamProvider)!;
    final currentForum = useProvider(currentForumProvider).state;
    final currentThread = useProvider(currentThreadProvider).state;
    final forums = [
      'Global',
      ...player.member,
    ];
    if (currentForum.id?.isNotEmpty ?? false) {
      if (currentThread.id?.isNotEmpty ?? false) {
        return ThreadSubWidget();
      } else {
        return ForumSubWidget();
      }
    } else {
      return RadioSubWidget(
        forums: forums,
      );
    }
  }
}
