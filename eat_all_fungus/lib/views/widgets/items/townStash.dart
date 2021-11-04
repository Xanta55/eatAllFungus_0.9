import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/stashStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/stashInventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TownStash extends HookWidget {
  final bool canWrap;
  const TownStash({Key? key, this.canWrap = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final townStream = useProvider(townStreamProvider);
    final playerStream = useProvider(playerStreamProvider);
    if (townStream?.members.contains(playerStream?.id) ?? false) {
      final stashState = useProvider(stashStreamProvider);
      final itemWidgetList = buildStashInventoryList(
          tileInventory: stashState ?? [], canTap: true);
      return Container(
        color: Colors.grey[colorIntensity],
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Items in Stash:'),
              Expanded(
                child: canWrap
                    ? Container(
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: [
                              ...itemWidgetList
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          width: 100,
                                          height: 100,
                                          child: Panel(child: e),
                                        ),
                                      ))
                                  .toList()
                            ],
                          ),
                        ),
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: itemWidgetList,
                      ),
              )
            ],
          ),
        )),
      );
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'You need to be a member of this town to access a personal item-stash',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
  }
}
