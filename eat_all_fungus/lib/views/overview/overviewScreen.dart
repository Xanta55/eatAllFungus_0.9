import 'package:eat_all_fungus/views/widgets/buttons/logoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OverviewScreen extends HookWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final profileControllerState = useProvider(profileControllerProvider);
    // final authControllerState = useProvider(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('OVERVIEW'),
        actions: [
          buildLogoutButton(context),
        ],
      ),
      // 'displayName: ${profileControllerState.data?.value.name}\nUID: ${authControllerState.uid}'
      body: Center(),
    );
  }
}
