import 'package:flutter/material.dart';

typedef OnWillPopCallback = Future<bool> Function();

class SafePopScope extends StatelessWidget {
  final Widget child;
  final OnWillPopCallback onWillPop;
  final bool canPop;

  const SafePopScope({
    super.key,
    required this.child,
    required this.onWillPop,
    this.canPop = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).maybePop(result);
          }
        }
      },
      child: child,
    );
  }

}