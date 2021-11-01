import 'package:eat_all_fungus/views/inGame/overview/overviewSubWidgets.dart';
import 'package:eat_all_fungus/views/inGame/player/playerSubWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PlayerWidget extends HookWidget {
  const PlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        staggeredTiles: _staggeredTiles,
        children: _playerViewTiles,
      ),
    );
  }
}

const List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
  StaggeredTile.count(1, 1), // AP
  StaggeredTile.count(3, 1), // Player-Status
  StaggeredTile.count(4, 1), // Player-Inventory
  StaggeredTile.count(4, 1), // Tile-Inventory
  StaggeredTile.count(4, 2), // Interactions
  StaggeredTile.count(4, 1), // Tile-Interactionbutton
];

const List<Widget> _playerViewTiles = <Widget>[
  PlayerActionPointsWidget(),
  OverviewPlayerStatus(),
  OverviewInventory(),
  PlayerTileInventoryWidget(),
  PlayerInteractionsWidget(),
  PlayerTileInteractionsWidget(),
];
