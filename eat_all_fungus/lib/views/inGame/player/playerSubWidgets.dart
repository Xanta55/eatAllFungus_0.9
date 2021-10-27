import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/views/inGame/overview/overviewSubWidgets.dart';
import 'package:eat_all_fungus/views/widgets/items/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerActionPointsWidget extends HookWidget {
  const PlayerActionPointsWidget();

  @override
  Widget build(BuildContext context) {
    final playerAP = useProvider(playerStreamProvider)?.actionPoints;
    if (playerAP != null) {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Current AP: '),
                  TextSpan(
                      text: '$playerAP', style: TextStyle(color: Colors.amber)),
                  TextSpan(text: ' / 10'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class PlayerTileInventoryWidget extends HookWidget {
  const PlayerTileInventoryWidget();

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    if (tileState != null) {
      if (tileState.townOnTile.isEmpty) {
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
                      scrollDirection: Axis.horizontal,
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
          child: Center(
            child: Text('Town'),
          ),
        );
      }
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    }
  }
}

class PlayerInteractionsWidget extends HookWidget {
  const PlayerInteractionsWidget();
  // TODO pretty much loading all item interactions

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('WIP'),
        ),
      ),
    );
  }
}

class PlayerTileInteractionsWidget extends HookWidget {
  const PlayerTileInteractionsWidget();

  /* 
    The Interactions should be loaded from somewhere else.
    Still WIP, as this may be outsourced to the database.
    Keys are the Tiledescription (as every kind of tile should only have 1 Option)
    Value should be a collection of:
      1 - Map of required Ressources (AP should be viable too)
      2 - A Function, which can be loaded
  */

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    if (tileState != null) {
      if (tileState.townOnTile.isEmpty) {
        switch (tileState.description) {
          case 'Empty Tile':
            return InteractPanel(
                buttonDesc: 'Construct a Town',
                needsToComplete: {'plank': 15, 'rock': 5},
                onTap: () {
                  print('Button worked, duh!');
                });
          default:
            return Panel(
              child: ElevatedButton(
                onPressed: () => print('Button works, duh!'),
                child: Text('Not an Empty Tile'),
              ),
            );
        }
      } else {
        return Panel(
            child: ElevatedButton(
          onPressed: () => print('There is a Town on this Tile'),
          child: Text('Tile with a Town'),
        ));
      }
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    }
  }

  Widget InteractPanel(
      {Map<String, int>? needsToComplete,
      required String buttonDesc,
      required Function onTap}) {
    final List<Widget> itemRequirements = <Widget>[];
    if (needsToComplete != null) {
      for (String s in needsToComplete.keys) {
        itemRequirements.add(
          Container(
            child: Row(
              children: [
                ItemBox(item: s),
                Text('x ${needsToComplete[s]}'),
              ],
            ),
          ),
        );
      }
    } else {
      itemRequirements.add(Text(' Nothing really'));
    }
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Panel(
                    child: ElevatedButton(
                      onPressed: () {
                        onTap();
                      },
                      child: Text('$buttonDesc'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('This requires:'), ...itemRequirements],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
