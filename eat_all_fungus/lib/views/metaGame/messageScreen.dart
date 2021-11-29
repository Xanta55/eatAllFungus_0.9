import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/providers/streams/messageStream.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final messageListState = useProvider(messageStreamProvider);
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Messages',
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: Container(
                color: Colors.grey[colorIntensity],
                child: messageListState != null
                    ? ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Panel(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            messageListState[index].sender,
                                            style: TextStyle(
                                                color: Colors.amber[700],
                                                fontSize: 20.0),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 15.0, 0.0, 15.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                messageListState[index].header,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    '${messageListState[index].sentAt.hour.toString().padLeft(2, '0')}:${messageListState[index].sentAt.minute.toString().padLeft(2, '0')}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption),
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    '${messageListState[index].sentAt.day}-${messageListState[index].sentAt.month}-${messageListState[index].sentAt.year}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 2.0,
                          );
                        },
                        itemCount: messageListState.length)
                    : Container(
                        child: Center(
                          child: Text('Loading Messages',
                              style: Theme.of(context).textTheme.headline6),
                        ),
                      ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
