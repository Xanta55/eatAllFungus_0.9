import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/widgets/items/itemPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Widget> buildPlayerInventoryList({bool canTap = false}) {
  final playerState = useProvider(playerStreamProvider);
  final outputList = <Widget>[];
  if (playerState != null) {
    for (int i = 0; i < playerState.inventorySize; i++) {
      if (i < playerState.inventory.length) {
        if (canTap) {
          outputList.add(
            PlayerDropWrapper(
              item: playerState.inventory[i],
              child: ItemPanel(item: playerState.inventory[i]),
            ),
          );
        } else {
          outputList.add(
            ItemPanel(item: playerState.inventory[i]),
          );
        }
      } else {
        outputList.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: ItemPanel(item: ''),
        ));
      }
    }
  }
  return outputList;
}

class PlayerDropWrapper extends HookWidget {
  final String item;
  final Widget child;

  const PlayerDropWrapper({Key? key, required this.child, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerStreamProvider);
    final tileState = useProvider(mapTileStreamProvider);
    final townState = useProvider(townStreamProvider);
    if (playerState != null && tileState != null) {
      if (tileState.townOnTile.isEmpty) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context
                  .read(playerControllerProvider.notifier)
                  .dropItem(item: item);
            },
            child: child,
          ),
        );
      } else if (townState != null) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context
                  .read(playerControllerProvider.notifier)
                  .dropItem(item: item);
            },
            child: child,
          ),
        );
      } else {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: child,
          ),
        );
      }
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: child,
        ),
      );
    }
  }
}
