import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/views/widgets/items/inventory.dart';
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

class _buildTilePreview extends StatelessWidget {
  const _buildTilePreview();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('Tile Preview'),
        ),
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
                        children: buildInventoryList(),
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
        /*
        Column(
          children: [
            Text('Inventory: ${playerState.data!.value.Inventory.length}/${playerState.data!.value.inventorySize}'),
            Center(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: buildInventoryList(),
              ),
            ),
          ],
        ),
        */
      ),
    );
  }
}

class _buildTileInfo extends StatelessWidget {
  const _buildTileInfo();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('Tile Infos'),
        ),
      ),
    );
  }
}

class _buildPlayerStatus extends StatelessWidget {
  const _buildPlayerStatus();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('Player Status'),
        ),
      ),
    );
  }
}

class _buildNews extends StatelessWidget {
  const _buildNews();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('News'),
        ),
      ),
    );
  }
}