import 'package:eat_all_fungus/views/inGame/town/townTabs/townBankTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townBuildingTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townInfoTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townMemberTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townRequestTab.dart';
import 'package:eat_all_fungus/views/inGame/town/townTabs/townStashTab.dart';
import 'package:flutter/material.dart';

List<Widget> townWidgetTabs = <Widget>[
  TownInfoTab(),
  TownBankTab(),
  TownStashTab(),
  TownBuildingTab(),
  TownRequestTab(),
  TownMemberTab(),
];
