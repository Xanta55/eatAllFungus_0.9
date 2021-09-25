import 'package:eat_all_fungus/views/inGame/overview/overviewSubWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OverviewWidget extends HookWidget {
  const OverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: StaggeredGridView.count(
        crossAxisCount: 6,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        staggeredTiles: _staggeredTiles,
        children: overviewTiles,
      ),
    );
  }
}

const List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
  StaggeredTile.count(4, 5), // Todo-List
  StaggeredTile.count(2, 2), // Tile-Preview
  StaggeredTile.count(2, 5), // Tile-Info
  StaggeredTile.count(4, 2), // Player-Inventory
  StaggeredTile.count(3, 2), // Player-Status
  StaggeredTile.count(3, 2), //News for Towns
];
