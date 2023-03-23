import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

class PersonalProfileTagSetting extends StatefulWidget {
  final List<Map<String, String>> tagTable;
  const PersonalProfileTagSetting({super.key, required this.tagTable});
  @override
  State<PersonalProfileTagSetting> createState() =>
      _PersonalProfileTagSettingState();

  List<Map<String, String>> get content => tagTable;
}

class _PersonalProfileTagSettingState extends State<PersonalProfileTagSetting> {
  late final Widget addButton;
  late final Widget editButton;
  late List<PersonalProileTagTextEditView> tagsWidgetList;
  bool editMode = false;
  void initTagsWidgetList() {
    tagsWidgetList = [];
    for (Map<String, String> tag in widget.tagTable) {
      tagsWidgetList.add(PersonalProileTagTextEditView(
        tagKey: tag['key']!,
        tagValue: tag['value']!,
        editable: editMode,
        deleteTag: deleteTag,
        editTag: updateTagTable,
      ));
    }
  }

  void createNewTag(Map<String, String> tag) {
    setState(() {
      widget.tagTable.add(tag);
    });
  }

  void updateTagTable() {
    setState(() {
      for (PersonalProileTagTextEditView tag in tagsWidgetList) {
        widget.tagTable[tagsWidgetList.indexOf(tag)] = {
          'key': tag.tagKey,
          'value': tag.tagValue
        };
      }
    });
  }

  void deleteTag(Map<String, String> tag) {
    debugPrint(tag.toString());
    setState(() {
      // debugPrint('${widget.tagTable.contains(tag)}');
      for (int index = 0; index < widget.tagTable.length; index++) {
        if (widget.tagTable[index]['key'] == tag['key'] &&
            widget.tagTable[index]['value'] == tag['value']) {
          widget.tagTable.removeAt(index);
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Colors.amber,
        onPressed: () async {
          setState(() {
            editMode = false;
            updateTagTable();
          });
          if (widget.tagTable.length == 4) {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      content: const Text("個人標籤數量已達上限"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('ok'),
                        ),
                      ],
                    ));
          } else {
            final result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  AddTagForm addTagForm = const AddTagForm();
                  return SimpleDialog(
                    title: const Text("新增個人標籤"),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    children: [addTagForm],
                  );
                });
            // debugPrint(result.toString());
            setState(() {
              if (result != null) {
                createNewTag(result);
                debugPrint(widget.tagTable.toString());
              }
            });
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              '新增標籤',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
    editButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Colors.amber)),
        color: Colors.white,
        onPressed: () {
          setState(() {
            editMode = !editMode;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.edit,
              color: Colors.amber,
            ),
            Text(
              '修改標籤',
              style: TextStyle(color: Colors.amber, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initTagsWidgetList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const HeadlineWithContent(
                headLineText: "個人標籤",
                content: "填寫名片資訊，可自由填寫 ，可選0 ~ 4項資訊自由填寫, ex 學校: 中央大學"),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: widget.tagTable.isNotEmpty
                    ? [addButton, editButton]
                    : [addButton])
          ],
        ),
        Column(children: tagsWidgetList),
      ],
    );
  }
}

class AddTagForm extends StatefulWidget {
  const AddTagForm({super.key});

  @override
  State<AddTagForm> createState() => _AddTagFormState();
}

class _AddTagFormState extends State<AddTagForm> {
  final _formKey = GlobalKey<FormState>();
  final keyTextController = TextEditingController();
  final valueTextController = TextEditingController();
  late final TextFormField keyEditForm;
  late final TextFormField valueEditForm;
  String keyText = "";
  String valueText = "";

  @override
  void initState() {
    super.initState();
    keyEditForm = TextFormField(
      maxLength: 10,
      controller: keyTextController
        ..addListener(() {
          setState(() {
            keyText = keyTextController.text;
          });
        }),
      decoration: const InputDecoration(
        label: Text("標籤名稱"),
        icon: Icon(Icons.label),
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return '請勿留空';
        } else {
          return null;
        }
      },
    );
    valueEditForm = TextFormField(
      maxLength: 15,
      controller: valueTextController
        ..addListener(() {
          setState(() {
            valueText = valueTextController.text;
          });
        }),
      decoration: const InputDecoration(
        label: Text("標籤內容"),
        icon: Icon(Icons.contact_emergency_outlined),
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return '請勿留空';
        } else {
          return null;
        }
      },
    );
  }

  @override
  void dispose() {
    keyTextController.dispose();
    valueTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        keyEditForm,
        valueEditForm,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context)
                      .pop({"key": keyText, "value": valueText});
                }
              },
              child: const Text('新增'),
            ),
          ],
        )
      ]),
    );
  }
}

class EditTagForm extends StatefulWidget {
  final String initKeyText;
  final String initValueText;
  const EditTagForm({
    super.key,
    required this.initKeyText,
    required this.initValueText,
  });

  @override
  State<EditTagForm> createState() => _EditTagFormState();
}

class _EditTagFormState extends State<EditTagForm> {
  final _formKey = GlobalKey<FormState>();
  final keyTextController = TextEditingController();
  final valueTextController = TextEditingController();
  late final TextFormField keyEditForm;
  late final TextFormField valueEditForm;
  String keyText = "";
  String valueText = "";
  @override
  void initState() {
    super.initState();
    keyEditForm = TextFormField(
      maxLength: 10,
      controller: keyTextController
        ..addListener(() {
          setState(() {
            keyText = keyTextController.text;
          });
        })
        ..text = widget.initKeyText,
      decoration: const InputDecoration(
        label: Text("標籤名稱"),
        icon: Icon(Icons.label),
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return '請勿留空';
        } else {
          return null;
        }
      },
    );
    valueEditForm = TextFormField(
      maxLength: 15,
      controller: valueTextController
        ..addListener(() {
          setState(() {
            valueText = valueTextController.text;
          });
        })
        ..text = widget.initValueText,
      decoration: const InputDecoration(
        label: Text("標籤內容"),
        icon: Icon(Icons.contact_emergency_outlined),
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return '請勿留空';
        } else {
          return null;
        }
      },
    );
  }

  @override
  void dispose() {
    keyTextController.dispose();
    valueTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        keyEditForm,
        valueEditForm,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context)
                      .pop({"key": keyText, "value": valueText});
                }
              },
              child: const Text('修改'),
            ),
          ],
        )
      ]),
    );
  }
}

class PersonalProileTagTextEditView extends StatefulWidget {
  String tagKey;
  String tagValue;
  bool editable;
  final Function deleteTag;
  final Function editTag;
  PersonalProileTagTextEditView({
    super.key,
    required this.tagKey,
    required this.tagValue,
    required this.editable,
    required this.deleteTag,
    required this.editTag,
  });

  @override
  State<PersonalProileTagTextEditView> createState() =>
      _PersonalProileTagTextEditViewState();
}

class _PersonalProileTagTextEditViewState
    extends State<PersonalProileTagTextEditView> {
  final TextStyle keyTextStyle = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber);
  final TextStyle valueTextStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]);
  // late final Widget tag;
  late final Widget editTool;
  late final Widget tag;
  @override
  void initState() {
    super.initState();
    editTool = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                            title: const Text('修改標籤'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            children: [
                              EditTagForm(
                                initKeyText: widget.tagKey,
                                initValueText: widget.tagValue,
                              )
                            ]));
                setState(() {
                  if (result != null) {
                    widget.tagKey = result['key'];
                    widget.tagValue = result['value'];
                    debugPrint('${widget.tagKey} | ${widget.tagValue}');
                    widget.editTag();
                  }
                });
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
              onPressed: () {
                debugPrint('delete ${widget.tagKey} | ${widget.tagValue}');
                widget.deleteTag(
                    {'key': widget.tagKey, 'value': widget.tagValue});
              },
              icon: const Icon(Icons.remove, color: Colors.grey)),
        ),
      ],
    );
    tag = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.tagKey, style: keyTextStyle),
                  Text(widget.tagValue, style: valueTextStyle),
                ],
              ),
              widget.editable ? editTool : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.editable
        ? ShakeWidget(
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tagKey, style: keyTextStyle),
                        Text(widget.tagValue, style: valueTextStyle),
                      ],
                    ),
                    widget.editable ? editTool : const SizedBox()
                  ],
                ),
              ],
            ),
          ))
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tagKey, style: keyTextStyle),
                        Text(widget.tagValue, style: valueTextStyle),
                      ],
                    ),
                    widget.editable ? editTool : const SizedBox()
                  ],
                ),
              ],
            ),
          );
  }
}

class ShakeWidget extends StatefulWidget {
  final Widget child;

  ShakeWidget({required this.child});

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.02, end: 0.02).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _animation.value,
          child: child,
        );
      },
    );
  }
}
