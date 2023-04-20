import 'package:flutter/material.dart';

class CardViewTitle extends StatelessWidget {
  const CardViewTitle(
      {super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          Divider(
            thickness: 1.5,
            color: Theme.of(context).colorScheme.surfaceVariant,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: child,
          )
        ],
      ),
    );
  }
}
