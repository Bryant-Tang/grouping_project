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
  Color getTextColor(BuildContext context) {
    return widget.isSelected 
      ? Theme.of(context).colorScheme.onPrimaryContainer 
      : Theme.of(context).colorScheme.onSurface;
  }
  Color getBackgroundColor(BuildContext context) {
    return widget.isSelected
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surface;
  }
  Color getNumberColor(BuildContext context) {
    return widget.isSelected
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: getBackgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(0),
        elevation: 4
      ),
      onPressed: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(widget.iconPath,
                    width: 25,
                    height: 25,
                    colorFilter: ColorFilter.mode(
                        getTextColor(context),
                        BlendMode.srcIn)),
                Text(
                  widget.numberText.toString(),
                  style: TextStyle(
                      color: getNumberColor(context),
                      fontSize: MediaQuery.of(context).size.width / 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              widget.labelText,
              style: TextStyle(
                  color: getTextColor(context),
                  fontSize: MediaQuery.of(context).size.width / 35,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
