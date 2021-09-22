import 'package:eat_all_fungus/constValues/constSizes.dart';
import 'package:eat_all_fungus/controllers/worldListController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:eat_all_fungus/views/loadings/loadingScreen.dart';
import 'package:eat_all_fungus/views/loadings/loadingsWidget.dart';
import 'package:eat_all_fungus/views/widgets/buttons/logoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorldChooseScreen extends HookWidget {
  const WorldChooseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // getting/ setting up the provider
    final worldListControllerState = useProvider(worldListControllerProvider);

    // checking if provider is initialized
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
                    ElevatedButton(
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
                                      isHidden: false,
                                      xCoord: 0,
                                      yCoord: 0)
                                ])),
                        child: const Text('Create Empty World'))
                  ],
                ),
              )
            : ListView.builder(
                itemCount: worlds.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == worlds.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
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
                                        isHidden: false,
                                        xCoord: 0,
                                        yCoord: 0)
                                  ])),
                          child: const Text('Create Empty World')),
                    );
                  }
                  final world = worlds[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        key: ValueKey(world.id),
                        title: Text(world.name),
                        subtitle: Text(world.description),
                      ),
                    ),
                  );
                }),
        loading: () => LoadingScreen(loadingText: 'loading Worlds'),
        error: (error, _) => WorldListError(
            message: error is CustomException
                ? error.message!
                : 'Something went wrong!'));
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
