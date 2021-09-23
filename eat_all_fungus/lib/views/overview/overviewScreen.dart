import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/views/widgets/buttons/logoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OverviewScreen extends HookWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileControllerState = useProvider(profileControllerProvider);
    final worldControllerState = useProvider(worldControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('OVERVIEW'),
        actions: [
          buildLogoutButton(context),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('World: ${worldControllerState.data?.value.name}'),
            Text('Player: ${profileControllerState.data?.value.name}')
          ],
        ),
      ),
    );
  }
}
