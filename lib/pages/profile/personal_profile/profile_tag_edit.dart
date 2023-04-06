import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/profile/personal_profile/inherited_profile.dart';

class PersonalProfileTagSetting extends StatefulWidget {
  const PersonalProfileTagSetting({super.key});
  @override
  State<PersonalProfileTagSetting> createState() =>
      _PersonalProfileTagSettingState();
}

class _PersonalProfileTagSettingState extends State<PersonalProfileTagSetting> {
  bool editMode = false;

  void createNewTag(ProfileTag tag) {
    final ProfileModel profile = InheritedProfile.of(context)!.profile;
    final List<ProfileTag>? tagTable = profile.tags;
    InheritedProfile.of(context)!.updateProfile(
      profile.copyWith(
        tags: tagTable!..add(tag),
      ),
    );
  }

  List<Widget> createToolBar() {
    final tagTable = InheritedProfile.of(context)!.profile.tags;
    final addButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Colors.amber,
        onPressed: () async {
          setState(() {
            editMode = false;
          });
          if (tagTable!.length == 4) {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("個人標籤數量已達上限"),
                ),
              );
            });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  AddTagForm addTagForm = const AddTagForm();
                  return SimpleDialog(
                    title: const Text("新增個人標籤"),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    children: [addTagForm],
                  );
                }).then((value) {
              if (value is ProfileTag) {
                createNewTag(value);
                // debugPrint(widget.tagTable.toString());
              }
            }).catchError((error) {
              debugPrint(error.toString());
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
    final editButton = Padding(
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
    return tagTable!.isNotEmpty ? [addButton, editButton] : [addButton];
  }

  @override
  Widget build(BuildContext context) {
    final tagTable = InheritedProfile.of(context)!.profile.tags;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const HeadlineWithContent(
            headLineText: "個人標籤",
            content: "填寫名片資訊，可自由填寫 ，可選0 ~ 4項資訊自由填寫, ex 學校: 中央大學"),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: createToolBar()),
        Flexible(
          child: ListView.builder(
              clipBehavior: Clip.hardEdge,
              itemCount: tagTable!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return PersonalProileTagTextEditView(
                  tag: tagTable[index],
                  editable: editMode,
                  deleteTag: () {
                    InheritedProfile.of(context)!.updateProfile(
                      InheritedProfile.of(context)!.profile.copyWith(
                            tags: tagTable..removeAt(index),
                          ),
                    );
                  },
                  editTag: (tag) {
                    InheritedProfile.of(context)!.updateProfile(
                      InheritedProfile.of(context)!.profile.copyWith(
                            tags: tagTable..[index] = tag,
                          ),
                    );
                  },
                );
              }),
        )
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
                      .pop(ProfileTag(tag: keyText, content: valueText));
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
  final ProfileTag tag;
  const EditTagForm({
    super.key,
    required this.tag,
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
        ..text = widget.tag.tag,
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
        ..text = widget.tag.content,
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
                      .pop(ProfileTag(tag: keyText, content: valueText));
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
  final ProfileTag tag;
  final bool editable;
  final Function deleteTag;
  final void Function(ProfileTag) editTag;
  const PersonalProileTagTextEditView({
    super.key,
    required this.tag,
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
  Widget createTag() {
    final editTool = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
              onPressed: () {
                showDialog(
                        context: context,
                        builder: (BuildContext context) => SimpleDialog(
                            title: const Text('修改標籤'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            children: [EditTagForm(tag: widget.tag)]))
                    .then((value) {
                  if (value != null && value is ProfileTag) {
                    debugPrint('${value.tag} | ${value.content}');
                    widget.editTag(value);
                  }
                }).onError((error, stackTrace) => null);
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
                debugPrint('delete ${widget.tag.tag} | ${widget.tag.content}');
                widget.deleteTag();
              },
              icon: const Icon(Icons.remove, color: Colors.grey)),
        ),
      ],
    );
    final tag = Padding(
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
                  Text(widget.tag.tag, style: keyTextStyle),
                  Text(widget.tag.content, style: valueTextStyle),
                ],
              ),
              widget.editable ? editTool : Container()
            ],
          ),
        ],
      ),
    );
    return widget.editable
        ? ShakeWidget(
            child: tag,
          )
        : tag;
  }

  @override
  Widget build(BuildContext context) {
    return createTag();
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
