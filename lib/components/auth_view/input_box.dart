import 'package:flutter/material.dart';

class GroupingInputField extends StatefulWidget {
  final String labelText;
  final IconData boxIcon;
  final Color boxColor;
  final String? Function(String? value) validator;
  final textController = TextEditingController();
  // final String inputText = "";
  // final void Function() callBack;
  GroupingInputField({
    super.key,
    required this.labelText,
    required this.boxIcon,
    required this.boxColor,
    required this.validator,
  });

  set validator(String? Function(String? value) validator) {
    this.validator = validator;
  }

  get text => textController.text;

  @override
  State<GroupingInputField> createState() => _GroupingInputFieldState();
}

class _GroupingInputFieldState extends State<GroupingInputField> {
  // final textController = TextEditingController();
  String inputText = "";
  @override
  void initState() {
    super.initState();
    // Start listening to changes.
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
      child: TextFormField(
          controller: widget.textController,
          validator: widget.validator,
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
              ))),
    );
  }
}
