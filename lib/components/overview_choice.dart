import 'package:flutter/material.dart';

class OverViewChoice extends StatelessWidget {
  const OverViewChoice(
      {super.key,
      required this.textColor,
      required this.backgroundColor,
      required this.total,
      required this.inform,
      required this.icon});

  final Color backgroundColor;
  final Color textColor;
  final String inform;
  final IconData icon;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: 100,
      height: 60,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 7))
          ]),
      child: Stack(
        children: [
          Positioned(
            top: 1,
            left: 0,
            child: Icon(
              icon,
              color: textColor,
              size: 30,
            ),
          ),
          Positioned(
            top: 1,
            right: 0,
            child: Text(
              total.toString(),
              style: TextStyle(
                  color: (textColor == Colors.black
                      ? const Color(0xFFFCBF49)
                      : textColor),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 5,
            child: Text(
              inform,
              style: TextStyle(
                  color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
