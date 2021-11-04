import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

int countAmountOfItems(List<String> input, String toCount) {
  return input.isNotEmpty
      ? input.where((element) => element == toCount).length
      : 0;
}

Future<String> turnIDIntoName(String playerID, BuildContext context) async {
  return await context
      .read(profileControllerProvider.notifier)
      .getNameFromID(playerID: playerID);
}
