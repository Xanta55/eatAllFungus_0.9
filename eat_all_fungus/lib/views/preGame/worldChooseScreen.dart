import 'package:eat_all_fungus/constValues/constSizes.dart';
import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/controllers/worldListController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/views/loadings/loadingScreen.dart';
import 'package:eat_all_fungus/views/loadings/loadingsWidget.dart';
import 'package:eat_all_fungus/views/widgets/buttons/logoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorldChooseScreen extends HookWidget {
  const WorldChooseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // getting/ setting up the provider
    final worldListControllerState = useProvider(worldListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('CHOOSE A WORLD'),
        actions: [buildLogoutButton(context)],
      ),
      body: ProviderListener(
          provider: worldListExceptionProvider,
          onChange: (BuildContext context,
              StateController<CustomException?> customException) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red[400],
                content: Text(customException.state!.message!)));
          },
          child: worldListControllerState.data == null
              ? LoadingWidget(loadingText: 'Loading Worlds')
              : WorldList()),
    );
  }
}

/// To save some space in the build function above, we export the List to external Widget
class WorldList extends HookWidget {
  const WorldList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final worldListState = useProvider(worldListControllerProvider);
    return worldListState.when(
        data: (worlds) => worlds.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Seems like there are no worlds (yet or just at the moment...)'),
                    SizedBox(height: spacingSize),
                    NewWorldButton()
                  ],
                ),
              )
            : ListView.builder(
                itemCount: worlds.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == worlds.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NewWorldButton(),
                    );
                  }
                  final world = worlds[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WorldCard(world: world),
                  );
                }),
        loading: () => LoadingScreen(loadingText: 'loading Worlds'),
        error: (error, _) => WorldListError(
            message: error is CustomException
                ? error.message!
                : 'Something went wrong!'));
  }
}

/// Each Card holds a few values and can be exported aswell
/// This Widget may be interesting for the 'onTap' function
class WorldCard extends HookWidget {
  final World world;
  const WorldCard({Key? key, required this.world}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Entering Round')));
          //await context.read(profileControllerProvider.notifier).getProfile();
          await context
              .read(worldControllerProvider.notifier)
              .insertPlayer(world: world);
        },
        child: ListTile(
          key: ValueKey(world.id),
          title: Text(world.name),
          subtitle: Text(world.description),
        ),
      ),
    );
  }
}

/// This will probably be removed later on
/// Nonetheless, here is a button, which creates a new empty world
class NewWorldButton extends HookWidget {
  const NewWorldButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => context
            .read(worldListControllerProvider.notifier)
            .createEmptyWorld(
                world: World(
                    name: 'Tester',
                    description:
                        'A wholly golly World where nothing goes wrong',
                    depth: 1,
                    isOpen: true,
                    currentPlayers: 0,
                    mapTiles: [
                  MapTile(
                      description: 'Empty Tile',
                      inventory: ['plank', 'plank'],
                      timesDug: 0,
                      xCoord: 0,
                      yCoord: 0)
                ])),
        child: const Text('Create Empty World'));
  }
}

class WorldListError extends StatelessWidget {
  final String message;
  const WorldListError({Key? key, required this.message}) : super(key: key);

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
                  .read(worldListControllerProvider.notifier)
                  .getWorlds(isRefreshing: true),
              child: const Text('Retry'))
        ],
      ),
    );
  }
}
