import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/playerInventory.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/stashInventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TownStashTab extends HookWidget {
  const TownStashTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: PlayerInventory(
              canTap: true,
              isBank: false,
            ),
          ),
          Expanded(
            flex: 4,
            child: Panel(
              child: TownStash(
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
