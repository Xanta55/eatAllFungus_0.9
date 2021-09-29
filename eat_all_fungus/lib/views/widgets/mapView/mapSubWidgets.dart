import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MapTable extends HookWidget {
  final Map<int, Map<int, MapTile>> mapState;
  final World worldState;
  final Player playerState;

  final TransformationController controller = TransformationController();

  MapTable(this.mapState, this.worldState, this.playerState);

  @override
  Widget build(BuildContext context) {
    controllerReset();
    return InteractiveViewer(
      transformationController: controller,
      constrained: false,
      maxScale: 5.0,
      minScale: 0.05,
      boundaryMargin: EdgeInsets.all(10.0),
      child: Container(
        width: ((worldState.depth * 2) + 1) * 100,
        height: ((worldState.depth * 2) + 1) * 100,
        child: Table(
          children: _buildMapTable(mapState, worldState, playerState),
        ),
      ),
    );
  }

  void controllerReset() {
    double x = ((playerState.xCoord + worldState.depth) * 100 - 150) * -1;
    double y = ((playerState.yCoord + worldState.depth) * 100 - 150) * -1;
    controller.value = Matrix4.identity()..translate(y, x);
  }

  List<TableRow> _buildMapTable(Map<int, Map<int, MapTile>> mapState,
      World worldState, Player playerState) {
    List<TableRow> outputList = <TableRow>[];
    String matchThis = '${playerState.xCoord}-${playerState.yCoord}';

    for (int x = worldState.depth * (-1); x <= worldState.depth; x++) {
      final List<Widget> newRow = [];

      for (int y = worldState.depth * (-1); y <= worldState.depth; y++) {
        if ('${y}-${x * -1}' == matchThis) {
          newRow.add(UserTileWidget(mapState[y]![x * -1]!));
        } else if (mapState[y]![x * -1]!.isVisible) {
          newRow.add(MapTileWidget(mapState[y]![x * -1]!, true));
        } else {
          newRow.add(MapTileWidget(mapState[y]![x * -1]!, false));
        }
      }
      outputList.add(TableRow(children: newRow));
      //newRow.clear();
    }
    //print(outputList.length);
    return outputList;
  }
}

class UserTileWidget extends HookWidget {
  final MapTile tile;
  UserTileWidget(this.tile);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Colors.lightGreen[400],
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '${tile.xCoord}:${tile.yCoord}',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MapTileWidget extends HookWidget {
  final MapTile tile;
  final bool isVisible;

  MapTileWidget(this.tile, this.isVisible);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: isVisible
                ? (tile.sporeLevel >= 7
                    ? Colors.amber[900]
                    : (tile.sporeLevel >= 4 ? Colors.amber : Colors.amber[100]))
                : Colors.grey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '${tile.xCoord}:${tile.yCoord}',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
