import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/controllers/craftingController.dart';
import 'package:eat_all_fungus/controllers/townController.dart';
import 'package:eat_all_fungus/models/craftingRecipe.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
import 'package:eat_all_fungus/views/widgets/buttons/townButton.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/stashInventory.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/tileInventory.dart';
import 'package:eat_all_fungus/views/widgets/items/itemPanel.dart';
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
        final itemWidgetList = buildTileInventoryList(
            tileInventory: tileState.inventory, canTap: true);
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
        return Panel(child: TownStash());
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
  // Not to mention all the ideas... oh the ideas!

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerStreamProvider);
    return playerState != null
        ? Panel(
            child: Container(
              color: Colors.grey[colorIntensity],
              child: Center(
                child: ListView(
                  children: _buildCraftingTiles(playerState.inventory),
                ),
              ),
            ),
          )
        : Container(
            child: LoadingWidget(),
          );
  }

  List<Widget> _buildCraftingTiles(List<String> itemsInInventory) {
    final craftingRecipes = useProvider(craftingControllerProvider);
    final List<Widget> out = [];
    final List<Recipe> matchingRecipes = [];
    for (Recipe r in craftingRecipes) {
      if (r.input.keys.any((element) => itemsInInventory.contains(element))) {
        matchingRecipes.add(r);
      }
    }
    for (Recipe r in matchingRecipes) {
      out.add(Container(
          child: CraftingTileWidget(
              r.input.entries
                  .map((rec) => ItemPanel(item: rec.key, amount: rec.value))
                  .toList(),
              r.output.entries
                  .map((rec) => ItemPanel(item: rec.key, amount: rec.value))
                  .toList())));
    }
    return out;
  }

  Widget CraftingTileWidget(
      List<ItemPanel> inputItems, List<ItemPanel> outputItems) {
    return Panel(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Panel(
                child: Container(
                  color: Colors.grey[850],
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children:
                        inputItems.map((e) => Container(child: e)).toList(),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Icon(Icons.arrow_right_alt_outlined),
              ),
            ),
            Expanded(
              child: Panel(
                child: Container(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children:
                        outputItems.map((e) => Container(child: e)).toList(),
                  ),
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () => print('Button works, duh!'),
                child: Icon(Icons.handyman),
              ),
            ),
          ],
        ),
      ),
    ));
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
            return interactPanel(
                buttonDesc: 'Construct a Town',
                needsToComplete: {'plank': 15, 'rock': 5},
                onTap: () {
                  context
                      .read(townControllerProvider.notifier)
                      .constructTown(name: 'Bobby Town');
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
        return Panel(child: TownButton());
      }
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    }
  }

  Widget interactPanel(
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
