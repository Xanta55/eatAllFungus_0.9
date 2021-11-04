import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/tileInventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownBankTab extends HookWidget {
  const TownBankTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final townStream = useProvider(townStreamProvider);
    List<Widget> itemList =
        buildTileInventoryList(tileInventory: townStream?.inventory ?? [])
            .map((e) => SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: e,
                    ),
                  ),
                  width: 100.0,
                ))
            .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: ListView(
                children: [
                  Text(
                    'Bank:',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        children: itemList,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
