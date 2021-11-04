import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: child,
      ),
    );
  }
}
