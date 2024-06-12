import 'package:flutter/material.dart';

abstract class Popup {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, __, ___) {
        final Widget body = Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: child,
          ),
        );

        return SafeArea(
          child: Material(type: MaterialType.transparency, child: body),
        );
      },
    );
  }
}
