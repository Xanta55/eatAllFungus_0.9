import 'package:eat_all_fungus/views/various/eatAllFungus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Get the google-services.json
// Run "pub get" after every pull

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: EatAllFungus()));
}
