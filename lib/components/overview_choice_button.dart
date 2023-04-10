import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OverViewChoiceButton extends StatefulWidget {
  final String labelText;
  final int numberText;
  final String iconPath;
  final void Function() onTap;
  final bool isSelected;

  const OverViewChoiceButton({
    super.key,
    required this.labelText,
    required this.iconPath,
    required this.numberText,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<OverViewChoiceButton> createState() => _OverViewChoiceButtonState();
}

class _OverViewChoiceButtonState extends State<OverViewChoiceButton> {
  final Color labelColor = const Color(0XFF5C5C5C);
  final Color iconColor = const Color(0XFF5C5C5C);
  final Color numberColor = const Color(0XFFFCBF49);
  final Color backgroundColor = const Color(0XFFFFFDF9);
  final Color selectedLabelColor = const Color(0XFFFFFDF9);
  final Color selectedIconColor = const Color(0XFFFFFDF9);
  final Color selectedNumberColor = const Color(0XFFFFFDF9);
  final Color selectedBackgroundColor = const Color(0XFFFCBF49);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                widget.isSelected ? selectedBackgroundColor : backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: const Color(0XFF000000).withOpacity(0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0)
            ]
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(widget.iconPath, width: 25, height: 25,
                    colorFilter: ColorFilter.mode(
                        widget.isSelected ? selectedIconColor : iconColor,
                        BlendMode.srcIn)),
                Text(
                  widget.numberText.toString(),
                  style: TextStyle(
                      color:
                          widget.isSelected ? selectedNumberColor : numberColor,
                      fontSize: MediaQuery.of(context).size.width / 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              widget.labelText,
              style: TextStyle(
                  color: widget.isSelected ? selectedLabelColor : labelColor,
                  fontSize: MediaQuery.of(context).size.width / 30,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
