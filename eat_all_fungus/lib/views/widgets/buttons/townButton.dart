import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/inGame/overview/overviewSubWidgets.dart';
import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownButton extends HookWidget {
  const TownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerStreamProvider);
    final townStream = useProvider(townStreamProvider);
    if (townStream != null && playerState != null) {
      return townStream.members.contains(playerState.id)
          ? EnterTownButton()
          : RequestJoinButton(
              canRequest: !townStream.requestsToJoin.contains(playerState.id!));
    } else {
      return LoadingWidget();
    }
  }
}

class EnterTownButton extends HookWidget {
  const EnterTownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('You have access to this town'),
        ),
      ),
    );
  }
}

class RequestJoinButton extends HookWidget {
  final bool canRequest;
  const RequestJoinButton({Key? key, required this.canRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('can this player still request: $canRequest');
    if (canRequest) {
      return Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.blue[600]),
          onPressed: () =>
              context.read(townStreamProvider.notifier).requestJoin(),
          child: Center(
            child: Text('Request to join town'),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.grey[colorIntensity],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Your request needs to be approved by an elder',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }
  }
}
