import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/models/news.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/newsStream.dart';
import 'package:eat_all_fungus/providers/tileStream.dart';
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

class _buildToDoList extends StatelessWidget {
  const _buildToDoList();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('ToDo'),
        ),
      ),
    );
  }
}

class _buildTilePreview extends HookWidget {
  const _buildTilePreview();

  @override
  Widget build(BuildContext context) {
    final tileController = useProvider(mapTileStreamProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: StreamBuilder(
            stream: tileController,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.active
                  ? TilePreview(tile: snapshot.data as MapTile)
                  : CircularProgressIndicator();
            },
          ),
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
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
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
    final tileController = useProvider(mapTileStreamProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: StreamBuilder(
            stream: tileController,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final itemWidgetList = buildTileInventoryList(
                    tileInventory: (snapshot.data as MapTile).inventory);
                return Padding(
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
          child: StreamBuilder(
            stream: newsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return MiniNewspaper(newsInput: snapshot.data as List<News>);
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
