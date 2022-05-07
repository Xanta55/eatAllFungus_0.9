import 'package:eat_all_fungus/views/inGame/town/townTabs/townBankTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townBuildingTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townInfoTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townMemberTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townRequestTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townStashTab.dart';
import 'package:flutter/material.dart';

final List<Widget> townWidgetTabs = <Widget>[
  TownInfoTab(),
  TownBankTab(),
  TownStashTab(),
  TownBuildingTab(),
  TownRequestTab(),
  TownMemberTab(),
];

final List<Widget> iconList = const [
  const Tab(icon: Icon(Icons.list_alt)),
  const Tab(icon: Icon(Icons.account_balance)),
  const Tab(icon: Icon(Icons.business_center)),
  const Tab(icon: Icon(Icons.carpenter)),
  const Tab(icon: Icon(Icons.markunread_mailbox)),
  const Tab(icon: Icon(Icons.people)),
];
