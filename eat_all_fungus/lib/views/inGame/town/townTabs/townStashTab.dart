import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:eat_all_fungus/views/widgets/items/townStash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TownStashTab extends HookWidget {
  const TownStashTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: TownStash(
          canWrap: true,
        ),
      ),
    );
  }
}
