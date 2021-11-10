import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townMemberTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownRequestTab extends HookWidget {
  const TownRequestTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestList = useProvider(townStreamProvider)?.requestsToJoin ?? [];
    return NameList(
      header: 'Request to Join Town',
      idList: requestList,
      hasButtons: true,
    );
  }
}
