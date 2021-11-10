import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/bankInventory.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/playerInventory.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/tileInventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownBankTab extends HookWidget {
  const TownBankTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final townStream = useProvider(townStreamProvider);
    List<Widget> itemList = buildBankInventoryList(
      bankInventory: townStream?.inventory ?? [],
      canTap: true,
    )
        .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.grey)),
                width: 100,
                height: 100,
                child: Panel(child: e),
              ),
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: PlayerInventory(
              canTap: true,
              isBank: true,
            ),
          ),
          Expanded(
            flex: 4,
            child: Panel(
              child: TownBank(
                inputStyle: Theme.of(context).textTheme.headline5,
                canWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
