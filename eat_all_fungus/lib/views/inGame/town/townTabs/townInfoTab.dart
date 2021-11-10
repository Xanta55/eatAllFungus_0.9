import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TownInfoTab extends HookWidget {
  const TownInfoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Center(
            child: Text(
              'Infos are not implemented (yet)',
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
