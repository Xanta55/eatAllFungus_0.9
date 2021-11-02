import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/constValues/helperFunctions.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/views/inGame/overview/overviewSubWidgets.dart';
import 'package:eat_all_fungus/views/various/loadings/loadingsWidget.dart';
import 'package:eat_all_fungus/views/widgets/items/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Widget> townWidgetTabs = <Widget>[
  TownInfoTab(),
  TownBankTab(),
  TownStashTab(),
  TownBuildingTab(),
  TownRequestTab(),
  TownMemberTab(),
];

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

class TownBankTab extends HookWidget {
  const TownBankTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final townStream = useProvider(townStreamProvider);
    List<Widget> itemList =
        buildTileInventoryList(tileInventory: townStream?.inventory ?? [])
            .map((e) => SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: e,
                    ),
                  ),
                  width: 100.0,
                ))
            .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Panel(
              child: ListView(
                children: [
                  Text(
                    'Bank:',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        children: itemList,
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
  }
}

class TownStashTab extends HookWidget {
  const TownStashTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Center(
            child: Text(
              'Stashes are not implemented (yet)',
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

class TownRequestTab extends HookWidget {
  const TownRequestTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestList = useProvider(townStreamProvider)?.requestsToJoin ?? [];
    return NameList(
      header: 'Request to Join Town',
      idList: requestList,
      hasButtons: true,
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
          child: NameList(
            header: 'Elders',
            idList: elderList,
          ),
        ),
        Expanded(
          flex: 2,
          child: NameList(
            header: 'Members',
            idList: memberList,
          ),
        ),
      ],
    );
  }
}

class NameList extends HookWidget {
  final bool hasButtons;
  final List<String> idList;
  final String header;
  const NameList(
      {Key? key,
      required this.header,
      required this.idList,
      this.hasButtons = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Future<String>> nameList = [];
    if (idList.isNotEmpty) {
      nameList.addAll(idList.map((e) => turnIDIntoName(e, context)));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    header,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                child: Panel(
                  child: Container(
                    color: Colors.grey[850],
                    child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Panel(
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: FutureBuilder(
                                          future: nameList[index],
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
                                              return Text(idList[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    ...hasButtons
                                        ? [
                                            Expanded(
                                              child: Panel(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      context
                                                          .read(
                                                              townStreamProvider
                                                                  .notifier)
                                                          .acceptRequestToJoin(
                                                              playerIDToAccept:
                                                                  idList[
                                                                      index]);
                                                    },
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Expanded(
                                              child: Panel(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      context
                                                          .read(
                                                              townStreamProvider
                                                                  .notifier)
                                                          .removeRequestToJoin(
                                                              playerIDToRemove:
                                                                  idList[
                                                                      index]);
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                          ]
                                        : [],
                                    // ...?extraWidgets,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                              child: Divider(
                                color: Colors.grey[300],
                              ),
                            ),
                        itemCount: idList.length),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
