import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/providers/inGameNavigationProvider.dart';
import 'package:eat_all_fungus/services/authRepository.dart';
import 'package:eat_all_fungus/views/inGame/overview/overviewWidget.dart';
import 'package:eat_all_fungus/views/widgets/buttons/logoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InGameScaffolding extends HookWidget {
  const InGameScaffolding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationState = useProvider(navStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(navigationState.toUpperCase()),
        actions: [
          buildLogoutButton(context),
          IconButton(
              onPressed: () {
                final profile =
                    context.read(profileControllerProvider).data?.value;
                if (profile != null) {
                  context
                      .read(worldControllerProvider.notifier)
                      .removePlayerFromWorld();
                } else {
                  print('LeaveWorldButton - no current profile found!');
                }
              },
              icon: Icon(Icons.warning))
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              _buildDrawerButton(context, 'Overview'),
              SizedBox(height: 16.0),
              _buildDrawerButton(context, 'Map'),
              SizedBox(height: 16.0),
              _buildDrawerButton(context, 'Town'),
              SizedBox(height: 16.0),
              _buildDrawerButton(context, 'Player'),
              SizedBox(height: 16.0),
              _buildDrawerButton(context, 'Radio'),
              SizedBox(height: 16.0),
              Divider(color: Colors.amber[200]),
              SizedBox(height: 16.0),
              _buildDrawerButton(context, 'World'),
              SizedBox(height: 16.0),
              _buildDrawerButton(context, 'Profile'),
              SizedBox(height: 16.0),
              Divider(color: Colors.amber[200]),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Sign Out'),
                onTap: () {
                  context.read(navStateProvider.notifier).setRoute('overview');
                  context.read(authRepositoryProvider).signOut();
                },
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(navigationState),
    );
  }

  ListTile _buildDrawerButton(BuildContext context, String navigation) {
    return ListTile(
      title: Text(navigation),
      onTap: () {
        context
            .read(navStateProvider.notifier)
            .setRoute(navigation.toLowerCase());
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody(String route) {
    switch (route) {
      case 'overview':
        return OverviewWidget();
      case 'player':
        return Container(
          child: Center(
            child: Text('Player'),
          ),
        );
      case 'map':
        return Container(
          child: Center(
            child: Text('Map'),
          ),
        );
      case 'town':
        return Container(
          child: Center(
            child: Text('Town'),
          ),
        );
      case 'radio':
        return Container(
          child: Center(
            child: Text('Radio'),
          ),
        );
      case 'world':
        return Container(
          child: Center(
            child: Text('World'),
          ),
        );
      case 'profile':
        return Container(
          child: Center(
            child: Text('Profile'),
          ),
        );
    }

    return Container(
      child: Center(
        child: Text('Huch'),
      ),
    );
  }
}
