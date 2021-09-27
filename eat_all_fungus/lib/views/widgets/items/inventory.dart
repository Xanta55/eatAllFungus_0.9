import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/services/imageRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Widget> buildPlayerInventoryList() {
  final playerState = useProvider(playerControllerProvider);
  final outputList = <Widget>[];
  playerState.when(
      data: (data) {
        for (int i = 0; i < data.inventorySize; i++) {
          if (i < data.Inventory.length) {
            outputList.add(ItemBox(item: data.Inventory[i]));
          } else {
            outputList.add(ItemBox(item: ''));
          }
        }
      },
      loading: () {
        outputList.add(ItemBox(item: ''));
      },
      error: (error, st) => outputList.add(CircularProgressIndicator()));
  return outputList;
}

List<Widget> buildTileInventoryList({required List<String> tileInventory}) {
  List<Widget> outputList = <Widget>[];
  for (String item in tileInventory) {
    outputList.add(ItemBox(item: item));
  }
  return outputList;
}

class ItemBox extends HookWidget {
  final String item;

  const ItemBox({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageProvider = useProvider(imageRepository);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: item != ''
            ? FutureBuilder(
                future: imageProvider.getItemImageUrl(itemImageName: item),
                builder: (context, futureImage) {
                  if (futureImage.connectionState == ConnectionState.done) {
                    return Container(
                      child: Image.network(
                        futureImage.data.toString(),
                        filterQuality: FilterQuality.none,
                        fit: BoxFit.contain,
                      ),
                    );
                  } else {
                    return Container(child: CircularProgressIndicator());
                  }
                })
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.amber)),
              ),
      ),
    );
  }
}
