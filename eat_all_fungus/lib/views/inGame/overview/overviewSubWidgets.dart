import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/models/news.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/streams/newsStream.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/views/widgets/items/inventory.dart';
import 'package:eat_all_fungus/views/widgets/newspaper/miniNewspaper.dart';
import 'package:eat_all_fungus/views/widgets/status/statusWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const List<Widget> overviewTiles = <Widget>[
  _buildToDoList(),
  _buildTilePreview(),
  _buildTileInfo(),
  _buildInventory(),
  _buildPlayerStatus(),
  _buildNews()
];

const int colorIntensity = 900;

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: child,
      ),
    );
  }
}

class _buildToDoList extends HookWidget {
  const _buildToDoList();

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerStreamProvider);
    if (playerState != null) {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'To-Do:',
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: buildTodoWidget(todoList: playerState.todoList),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    }
  }

  Widget buildTodoWidget({required List<String> todoList}) {
    if (todoList.isEmpty) {
      return ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'All done for today!',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    }
    return ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.crop_square),
              title: Text(todoList[index]),
            ),
          );
        });
  }
}

class _buildTilePreview extends HookWidget {
  const _buildTilePreview();

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: tileState != null
              ? TilePreview(tile: tileState)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget TilePreview({required MapTile tile}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('X: ${tile.xCoord} - Y: ${tile.yCoord}'),
          Text('${tile.description}')
        ],
      ),
    );
  }
}

class _buildInventory extends HookWidget {
  const _buildInventory();

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerControllerProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: playerState.when(
            data: (player) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                        'Inventory: ${player.Inventory.length}/${player.inventorySize}'),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: buildPlayerInventoryList(),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => Container(),
            error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                )),
      ),
    );
  }
}

class _buildTileInfo extends HookWidget {
  const _buildTileInfo();

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    if (tileState != null) {
      final itemWidgetList =
          buildTileInventoryList(tileInventory: tileState.inventory);
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Items on Tile:'),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: itemWidgetList,
                  ),
                )
              ],
            ),
          )),
        ),
      );
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    }
  }
}

class _buildPlayerStatus extends HookWidget {
  const _buildPlayerStatus();

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerControllerProvider.notifier);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: StreamBuilder(
            stream: playerState.getPlayerStream(),
            builder: (context, player) {
              if (player.connectionState == ConnectionState.active) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Current Statuseffects:'),
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: buildPlayerStatusList(
                              statusEffects:
                                  (player.data as Player).statusEffects),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _buildNews extends HookWidget {
  const _buildNews();

  @override
  Widget build(BuildContext context) {
    final newsStream = useProvider(newsStreamProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: MiniNewspaper(newsInput: newsStream),
        ),
      ),
    );
  }
}
