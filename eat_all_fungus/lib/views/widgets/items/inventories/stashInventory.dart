import 'package:eat_all_fungus/constValues/helperFunctions.dart';
import 'package:eat_all_fungus/controllers/townController.dart';
import 'package:eat_all_fungus/views/widgets/items/itemPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Widget> buildStashInventoryList(
    {required List<String> tileInventory, bool canTap = false}) {
  List<Widget> outputList = <Widget>[];
  for (String item in [
    ...{...tileInventory} // ... dont question the power of DART
  ]) {
    canTap
        ? outputList.add(Container(
            child: StashPickUpWrapper(
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

class StashPickUpWrapper extends HookWidget {
  final String item;
  final Widget child;

  const StashPickUpWrapper({Key? key, required this.child, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context
              .read(townControllerProvider.notifier)
              .withdrawItem(item: item);
        },
        child: child,
      ),
    );
  }
}
