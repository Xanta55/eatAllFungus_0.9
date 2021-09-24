import 'package:eat_all_fungus/constValues/constSizes.dart';
import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/views/overview/overviewScreen.dart';
import 'package:eat_all_fungus/views/preGame/worldChooseScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GetIntoGameWrapper extends HookWidget {
  const GetIntoGameWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileControllerState = useProvider(profileControllerProvider);
    if (profileControllerState.data!.value.currentWorld.isEmpty) {
      return WorldChooseScreen();
    } else {
      return OverviewScreen();
    }
  }
}

class WorldError extends StatelessWidget {
  final String message;
  const WorldError({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(fontSize: 20.0)),
          SizedBox(height: spacingSize),
          ElevatedButton(
              onPressed: () => context
                  .read(worldControllerProvider.notifier)
                  .getWorld(isRefreshing: true),
              child: const Text('Retry'))
        ],
      ),
    );
  }
}
