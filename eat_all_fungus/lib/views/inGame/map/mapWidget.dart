import 'package:eat_all_fungus/controllers/tileMapController.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
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
                      child: Container(
                        color: Colors.green[200],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 8.0, 8.0, 4.0),
                            child: Container(
                              color: Colors.yellow[200],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 4.0, 8.0, 8.0),
                            child: Container(
                              color: Colors.red[200],
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
}
