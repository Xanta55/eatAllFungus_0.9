import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/constValues/helperFunctions.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/inGame/overview/overviewSubWidgets.dart';
import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Widget> townWidgetTabs = <Widget>[
  Container(child: Center(child: Text('Infos/Home'))),
  Container(child: Center(child: Text('Bank'))),
  Container(child: Center(child: Text('Stash'))),
  Container(child: Center(child: Text('Buildings'))),
  TownRequestTab(),
  TownMemberTab(),
];

class TownRequestTab extends HookWidget {
  const TownRequestTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final townState = useProvider(townStreamProvider);
    final requestList = townState?.requestsToJoin ?? [];
    final List<Future<String>> requestNameList = [];
    if (requestList.isNotEmpty) {
      requestNameList
          .addAll(requestList.map((e) => turnIDIntoName(e, context)));
    }
    print('Requests: ${requestList}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Container(
            color: Colors.grey[colorIntensity],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Request to join the town:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Panel(
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: FutureBuilder(
                                      future: requestNameList[index],
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data != null) {
                                          return Text(
                                            snapshot.data! as String,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          );
                                        } else {
                                          return Text(requestList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          print('TownSubWidget - Agree');
                                        },
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.lightGreen[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          print('TownSubWidget - Decline');
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),
                    itemCount: requestList.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TownMemberTab extends HookWidget {
  const TownMemberTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final townState = useProvider(townStreamProvider);
    final List<String> elderList = townState?.elders ?? [];
    final List<String> memberList = townState?.members ?? [];
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: Container(
                color: Colors.grey[colorIntensity],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Elders:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(elderList[index]),
                            ),
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[300],
                            ),
                        itemCount: elderList.length),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: Container(
                color: Colors.grey[colorIntensity],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Members:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(memberList[index]),
                            ),
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[300],
                            ),
                        itemCount: memberList.length),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
