import 'package:flutter/material.dart';

class GroupingInputField extends StatefulWidget {
  final String labelText;
  final IconData boxIcon;
  final Color boxColor;
  final String? Function(String? value) validator;
  final textController = TextEditingController();
  final int maxLength;
  final int maxLines;
  // final String inputText = "";
  // final void Function() callBack;
  GroupingInputField({
    super.key,
    required this.labelText,
    required this.boxIcon,
    required this.boxColor,
    required this.validator,
    this.maxLength = -1,
    this.maxLines = -1,
  });
  set validator(String? Function(String? value) validator) {
    this.validator = validator;
  }

  get text => textController.text;

  @override
  State<GroupingInputField> createState() => _GroupingInputFieldState();

  setText(String groupDescription) {
    textController.text = groupDescription;
  }
}

class _GroupingInputFieldState extends State<GroupingInputField> {
  // final textController = TextEditingController();
  String inputText = "";
  late final TextFormField inputFied;
  @override
  void initState() {
    super.initState();
    inputText = widget.textController.text;
    // Start listening to changes.
    inputFied = TextFormField(
        controller: widget.textController..text = inputText,
        validator: widget.validator,
        maxLength: widget.maxLength == -1 ? null : widget.maxLength,
        maxLines: widget.maxLines == -1 ? null : widget.maxLines,
        decoration: InputDecoration(
            // isDense 為必要, contentPadding 越大，則 textfield 越大
            contentPadding: const EdgeInsets.all(15),
            isDense: true,
            border: const OutlineInputBorder(
                gapPadding: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(widget.boxIcon, color: widget.boxColor),
                const SizedBox(width: 10),
                Text(
                  widget.labelText,
                  style: TextStyle(
                    color: widget.boxColor,
                    fontFamily: "NotoSansTC",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                )
              ],
            )));
    widget.textController.addListener(
        () => setState(() => inputText = widget.textController.text));
  }

  @override
  void dispose() {
    widget.textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      child: inputFied,
    );
  }
}
