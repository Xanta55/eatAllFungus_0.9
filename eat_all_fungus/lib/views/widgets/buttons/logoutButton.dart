import 'package:eat_all_fungus/services/authRepository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// This is an IconButton, mostly for Appbars
IconButton buildLogoutButton(BuildContext context) {
  return IconButton(
      onPressed: () => context.read(authRepositoryProvider).signOut(),
      icon: Icon(Icons.logout));
}
