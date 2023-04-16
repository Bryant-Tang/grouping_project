import 'package:flutter/material.dart';

class ColorTagChip extends StatelessWidget {
  const ColorTagChip(
      {Key? key, required this.tagString, this.color = Colors.amber})
      : super(key: key);
  final Color color;
  final String tagString;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 6, 4),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(20),
            color: color.withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Center(
            child: Text(tagString,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 10)),
          ),
        ),
      ),
    );
  }
}
