import 'package:eat_all_fungus/models/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MiniNewspaper extends HookWidget {
  final List<News> newsInput;

  MiniNewspaper({required this.newsInput});
  @override
  Widget build(BuildContext context) {
    final newspaperIndex = useState(0);
    if (newsInput.isEmpty) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        newspaperIndex.value = newspaperIndex.value + 1;
        if (newspaperIndex.value >= newsInput.length) {
          newspaperIndex.value = 0;
        }
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${newsInput[newspaperIndex.value].news}'),
      )),
    );
  }
}
