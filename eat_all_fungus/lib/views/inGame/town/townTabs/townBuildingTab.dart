import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TownBuildingTab extends HookWidget {
  const TownBuildingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Center(
            child: Text(
              'Buildings are not implemented (yet)',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: Theme.of(context).textTheme.headline6!.fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
