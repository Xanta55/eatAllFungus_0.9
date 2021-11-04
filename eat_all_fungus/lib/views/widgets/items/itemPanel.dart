import 'package:eat_all_fungus/services/imageRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemPanel extends HookWidget {
  final String item;
  final int? amount;

  const ItemPanel({required this.item, this.amount});

  @override
  Widget build(BuildContext context) {
    if (amount == null) {
      return ItemBox(item: item);
    } else {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: ItemBox(item: item)),
              Text(
                'x $amount',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      );
    }
  }
}

class ItemBox extends HookWidget {
  final String item;

  const ItemBox({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageProvider = useProvider(imageRepository);
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
