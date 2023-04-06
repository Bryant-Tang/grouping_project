import 'package:flutter/material.dart';

class OverViewChoice extends StatelessWidget {
  const OverViewChoice(
      {super.key,
      required this.textColor,
      required this.backgroundColor,
      required this.totalNumber,
      required this.inform,
      required this.icon});

  final Color backgroundColor;
  final Color textColor;
  final String inform;
  final Widget icon;
  final Widget totalNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 5))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                totalNumber,
              ],
            ),
            Text(
              inform,
              style: TextStyle(
                  color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
