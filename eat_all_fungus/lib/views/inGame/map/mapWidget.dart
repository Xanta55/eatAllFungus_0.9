import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/controllers/tileMapController.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
import 'package:eat_all_fungus/views/widgets/buttons/digButton.dart';
import 'package:eat_all_fungus/views/widgets/items/inventory.dart';
import 'package:eat_all_fungus/views/widgets/mapView/mapSubWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final mapState = useProvider(tileMapControllerProvider);
    final worldState = useProvider(worldStreamProvider);
    final playerState = useProvider(playerStreamProvider);
    if (worldState != null && mapState != null && playerState != null) {
      return Container(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                color: Colors.grey[900],
                child: MapTable(mapState, worldState, playerState),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildControllerButtons(context),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 8.0, 8.0, 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                width: double.infinity,
                                child: DigButton(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 4.0, 8.0, 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                color: Colors.grey[800],
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text('On this Tile:'),
                                        Expanded(
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: buildItemTiles(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: LoadingWidget(
            loadingText: 'Loading Map',
          ),
        ),
      );
    }
  }

  List<Widget> buildItemTiles() {
    final tileState = useProvider(mapTileStreamProvider);
    if (tileState?.townOnTile.isEmpty ?? true) {
      print('should be getting inventory');
      return buildTileInventoryList(tileInventory: tileState?.inventory ?? []);
    } else {
      return [
        Center(
          child: Text('A Town obviously'),
        )
      ];
    }
  }

  Widget _buildControllerButtons(BuildContext context) {
    final playerState = useProvider(playerStreamProvider);
    final tileState = useProvider(mapTileStreamProvider);
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      color: Colors.red[400],
                      child: Center(
                        child: Text(
                          'Danger Level: \n${tileState?.buffShrooms ?? 0}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TestBox(
                Center(
                  child: IconButton(
                    onPressed: () => context
                        .read(playerControllerProvider.notifier)
                        .movePlayer(direction: 1),
                    icon: Icon(Icons.arrow_drop_up),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      color: Colors.green[400],
                      child: Center(
                        child: Text(
                          'Control Points: ${tileState?.controlPower ?? 0}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              TestBox(
                Center(
                  child: IconButton(
                    onPressed: () => context
                        .read(playerControllerProvider.notifier)
                        .movePlayer(direction: 4),
                    icon: Icon(Icons.arrow_left),
                  ),
                ),
              ),
              TestBox(
                Center(
                  child: Text(
                    'AP: ${playerState?.actionPoints ?? 0}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ),
              TestBox(
                Center(
                  child: IconButton(
                    onPressed: () => context
                        .read(playerControllerProvider.notifier)
                        .movePlayer(direction: 2),
                    icon: Icon(Icons.arrow_right),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              TestBox(
                Container(),
              ),
              TestBox(
                Center(
                  child: IconButton(
                    onPressed: () => context
                        .read(playerControllerProvider.notifier)
                        .movePlayer(direction: 3),
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              TestBox(
                Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget TestBox(Widget widget) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Colors.grey[800],
            child: widget,
          ),
        ),
      ),
    );
  }
}
