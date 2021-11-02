import 'package:eat_all_fungus/constValues/helperFunctions.dart';
import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/controllers/tileController.dart';
import 'package:eat_all_fungus/controllers/tileMapController.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/services/imageRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read(playerControllerProvider.notifier).dropItem(item: item);
        },
        child: child,
      ),
    );
  }
}

List<Widget> buildTileInventoryList(
    {required List<String> tileInventory, bool canTap = false}) {
  List<Widget> outputList = <Widget>[];
  for (String item in [
    ...{...tileInventory} // ... dont question the power of DART
  ]) {
    canTap
        ? outputList.add(Container(
            child: TilePickUpWrapper(
              item: item,
              child: ItemPanel(
                  item: item, amount: countAmountOfItems(tileInventory, item)),
            ),
          ))
        : outputList.add(Container(
            child: ItemPanel(
                item: item, amount: countAmountOfItems(tileInventory, item)),
          ));
  }
  return outputList;
}

class TilePickUpWrapper extends HookWidget {
  final String item;
  final Widget child;

  const TilePickUpWrapper({Key? key, required this.child, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read(tileControllerProvider.notifier).pickUpItem(item: item);
        },
        child: child,
      ),
    );
  }
}

class ItemPanel extends HookWidget {
  final String item;
  final int? amount;

  const ItemPanel({required this.item, this.amount});

  @override
  Widget build(BuildContext context) {
    if (amount == null) {
      return ItemBox(item: item);
    } else {
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: ItemBox(item: item)),
            Text(
              'x $amount',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }
  }
}

class ItemBox extends HookWidget {
  final String item;

  const ItemBox({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageProvider = useProvider(imageRepository);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: item != ''
            ? FutureBuilder(
                future: imageProvider.getItemImageUrl(itemImageName: item),
                builder: (context, futureImage) {
                  if (futureImage.connectionState == ConnectionState.done) {
                    return Container(
                      child: Image.network(
                        futureImage.data.toString(),
                        filterQuality: FilterQuality.none,
                        fit: BoxFit.contain,
                      ),
                    );
                  } else {
                    return Container(child: CircularProgressIndicator());
                  }
                })
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.amber)),
              ),
      ),
    );
  }
}
