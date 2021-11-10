import 'package:eat_all_fungus/constValues/constSizes.dart';
import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/controllers/worldListController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/worldListStream.dart';
import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
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
          provider: worldListStreamExceptionProvider,
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
    //final worldListState = useProvider(worldListControllerProvider);
    final worldList = useProvider(worldListStreamProvider);
    if (worldList != null && worldList.isNotEmpty) {
      return ListView.builder(
        itemCount: worldList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == worldList.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: NewWorldButton(),
            );
          }
          final world = worldList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: WorldCard(world: world),
          );
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Seems like there are no worlds (yet or just at the moment...)'),
            SizedBox(height: spacingSize),
            NewWorldButton()
          ],
        ),
      );
    }
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
            .createTestWorld(depth: 12),
        child: const Text('Create Test World'));
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
