import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/services/imageRepository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Widget> buildInventoryList() {
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

Widget ItemBox({required String item}) {
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
                  print(futureImage);
                  return Container(
                    child: Image.network(
                      futureImage.data.toString(),
                      filterQuality: FilterQuality.none,
                      fit: BoxFit.contain,
                    ),
                  );
                } else {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber)),
                      child: CircularProgressIndicator());
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
