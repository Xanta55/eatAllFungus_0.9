import 'package:eat_all_fungus/services/imageRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Widget> buildPlayerStatusList({required List<String> statusEffects}) {
  final List<Widget> outputList = <Widget>[];
  for (String status in statusEffects) {
    outputList.add(StatusBox(status: status));
  }
  return outputList;
}

class StatusBox extends HookWidget {
  final String status;

  const StatusBox({required this.status});

  @override
  Widget build(BuildContext context) {
    final imageProvider = useProvider(imageRepository);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: status != ''
            ? FutureBuilder(
                future:
                    imageProvider.getStatusImageUrl(statusImageName: status),
                builder: (context, futureStatus) {
                  if (futureStatus.connectionState == ConnectionState.done) {
                    return Container(
                      child: Image.network(
                        futureStatus.data.toString(),
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
