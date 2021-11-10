import 'package:eat_all_fungus/constValues/helperFunctions.dart';
import 'package:eat_all_fungus/controllers/tileController.dart';
import 'package:eat_all_fungus/views/widgets/items/itemPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
