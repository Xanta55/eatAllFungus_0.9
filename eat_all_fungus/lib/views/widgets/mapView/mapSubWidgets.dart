import 'dart:math';

import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const double TileSize = 100;

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
        width: ((worldState.depth * 2) + 1) * TileSize,
        height: ((worldState.depth * 2) + 1) * TileSize,
        child: Table(
          children: _buildMapTable(mapState, worldState, playerState),
        ),
      ),
    );
  }

  void controllerReset() {
    double x = (((playerState.yCoord * -1) + worldState.depth) * TileSize -
            (TileSize * (1.5))) *
        -1;
    double y = ((playerState.xCoord + worldState.depth) * TileSize -
            (TileSize * (1.5))) *
        -1;
    controller.value = Matrix4.identity()..translate(y, x);
  }

  List<TableRow> _buildMapTable(Map<int, Map<int, MapTile>> mapState,
      World worldState, Player playerState) {
    List<TableRow> outputList = <TableRow>[];
    String matchThis = '${playerState.xCoord}-${playerState.yCoord}';

    for (int x = worldState.depth * (-1); x <= worldState.depth; x++) {
      final List<Widget> newRow = [];

      for (int y = worldState.depth * (-1); y <= worldState.depth; y++) {
        // Player is on Tile
        if ('${y}-${x * -1}' == matchThis) {
          newRow.add(UserTileWidget());

          // Check if Tiles exist in loaded Map
        } else if (mapState.containsKey(y) &&
            (mapState[y]?.containsKey(x * -1) ?? false)) {
          newRow.add(MapTileWidget(mapState[y]![x * -1]!));

          // adds a hidden Tile
        } else {
          newRow.add(EmptyMapTileWidget(y, x * -1));
          //newRow.add(MapTileWidget(mapState[y]![x * -1]!, false));
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
  UserTileWidget();

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    if (tileState != null) {
      return AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              color: Colors.lightGreen[400],
              child: Container(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${tileState.xCoord}:${tileState.yCoord}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PlayerIconStack(
                          tileState.playersOnTile, tileState.buffShrooms),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class MapTileWidget extends HookWidget {
  final MapTile tile;

  MapTileWidget(this.tile);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: tile.sporeLevel >= 7
                ? Colors.amber[900]
                : (tile.sporeLevel >= 5
                    ? Colors.amber[600]
                    : (tile.sporeLevel >= 1
                        ? Colors.amber[300]
                        : Colors.amber[100])),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${tile.xCoord}:${tile.yCoord}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    PlayerIconStack(tile.playersOnTile, tile.buffShrooms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyMapTileWidget extends HookWidget {
  final int xCoord;
  final int yCoord;

  EmptyMapTileWidget(this.xCoord, this.yCoord);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Colors.grey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${xCoord}:${yCoord}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerIconStack extends HookWidget {
  final int playersOnTile;
  final int buffshroomsOnTile;
  PlayerIconStack(this.playersOnTile, this.buffshroomsOnTile);
  @override
  Widget build(BuildContext context) {
    print(buffshroomsOnTile);
    Random rng = Random();
    if (playersOnTile == 0 && buffshroomsOnTile == 0) {
      return Container();
    } else {
      List<Widget> icons = <Widget>[];

      for (int i = 0; i < playersOnTile; i++) {
        double x = (rng.nextInt((TileSize - TileSize * 0.25).round())) * 1 - 5;
        double y = (rng.nextInt((TileSize - TileSize * 0.25).round())) * 1 - 5;
        icons.add(Positioned(
          left: x,
          top: y,
          child: Image(
            image: AssetImage('assets/images/playerIcon.png'),
            filterQuality: FilterQuality.none,
          ),
        ));
      }
      for (int i = 0;
          i < (buffshroomsOnTile > 9 ? 9 : buffshroomsOnTile);
          i++) {
        double x = (rng.nextInt((TileSize - TileSize * 0.25).round())) * 1 - 5;
        double y = (rng.nextInt((TileSize - TileSize * 0.25).round())) * 1 - 5;
        icons.add(Positioned(
          left: x,
          top: y,
          child: Image(
            image: AssetImage('assets/images/buffshroomIcon.png'),
            filterQuality: FilterQuality.none,
          ),
        ));
      }
      return Stack(
        clipBehavior: Clip.none,
        children: icons,
      );
    }
  }
}
