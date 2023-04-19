import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPageView extends StatefulWidget {
  final ProfileEditViewModel model;
  const ProfileEditPageView({super.key, required this.model});
  @override
  State<ProfileEditPageView> createState() => _ProfileEditPageViewState();
}

class _ProfileEditPageViewState extends State<ProfileEditPageView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileEditViewModel>.value(
      value: widget.model,
      child: Consumer<ProfileEditViewModel>(
        builder: (context, model, child) => Builder(builder: (context) {
          return model.isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 150),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: PageView(
                              onPageChanged: model.onPageChange,
                              children: const [
                                ProfileSetting(),
                                PersonalProfileTagSetting(),
                                ProfileImageUpload(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 60.0,
                            child: Center(
                              child: TabPageSelector(
                                controller:
                                    TabController(length: 3, vsync: this)
                                      ..index = model.currentPageIndex,
                                color: Theme.of(context).colorScheme.surface,
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                indicatorSize: 16,
                              ),
                            ),
                          ),
                          NavigationToggleBar(
                              goBackButtonText: "Cancel",
                              goToNextButtonText: "Save",
                              goToNextButtonHandler: () async {
                                model.upload;
                                Navigator.of(context).pop();
                              },
                              goBackButtonHandler: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }
}

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  // final _formKey = GlobalKey<FormState>();
  final headLineText = "個人資訊設定";
  final contextText = "新增全名、暱稱、自我介紹與心情小語，讓大家更快認識你";

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditViewModel>(
      builder: (context, model, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          HeadlineWithContent(headLineText: headLineText, content: contextText),
          const SizedBox(height: 35),
          Form(
            // key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextFormField(
                  initialValue: model.userName,
                  decoration: const InputDecoration(
                    label: Text("使用者名稱 / User Name"),
                    icon: Icon(Icons.person_pin_outlined),
                  ),
                  onChanged: model.updateUserName,
                ),
                TextFormField(
                  initialValue: model.realName,
                  decoration: const InputDecoration(
                    label: Text("本名 / Real Name"),
                    icon: Icon(Icons.person_pin_outlined),
                  ),
                  onChanged: model.updateRealName,
                ),
                TextFormField(
                    initialValue: model.slogan,
                    decoration: const InputDecoration(
                      label: Text("心情小語 / 座右銘"),
                      icon: Icon(Icons.chat),
                    ),
                    onChanged: model.updateSlogan),
                TextFormField(
                  maxLength: 100,
                  initialValue: model.introduction,
                  decoration: const InputDecoration(
                    label: Text("自我介紹"),
                    icon: Icon(Icons.chat),
                  ),
                  onChanged: model.updateIntroduction,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileImageUpload extends StatefulWidget {
  const ProfileImageUpload({super.key});

  @override
  State<ProfileImageUpload> createState() => _PersonProfileImageUploadgState();
}

class _PersonProfileImageUploadgState extends State<ProfileImageUpload> {
  final headLineText = "你的大頭貼照片";
  final contentText = "名片上的大頭貼照片，如不上傳，可以使用預設照片";

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditViewModel>(
      builder: (context, model, child) =>
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        HeadlineWithContent(headLineText: headLineText, content: contentText),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    radius: 120,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    backgroundImage: model.profileImage != null
                        ? Image.file(model.profileImage!).image
                        : Image.asset('assets/images/profile_male.png').image),
              ),
              MaterialButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                color: Theme.of(context).colorScheme.primary,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () async {
                  final selectedPhoto = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (selectedPhoto != null) {
                    model.updateProfileImage(File(selectedPhoto.path));
                  }
                },
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '上傳圖片',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.file_upload_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    ]),
              )
            ],
          ),
        )),
      ]),
    );
  }
}

class PersonalProfileTagSetting extends StatefulWidget {
  const PersonalProfileTagSetting({super.key});
  @override
  State<PersonalProfileTagSetting> createState() =>
      _PersonalProfileTagSettingState();
}

class _PersonalProfileTagSettingState extends State<PersonalProfileTagSetting> {
  List<Widget> createToolBar(BuildContext context, ProfileEditViewModel model) {
    final labelTheme = Theme.of(context).textTheme.labelMedium;
    final addButtonColor = Theme.of(context).colorScheme.primary;
    final onAddButtonColor = Theme.of(context).colorScheme.onPrimary;
    TextStyle addButtonTextStyle = labelTheme!
        .copyWith(color: onAddButtonColor, fontWeight: FontWeight.bold);
    final editButtonColor = Theme.of(context).colorScheme.surfaceVariant;
    final onEditButtonColor = Theme.of(context).colorScheme.onSurfaceVariant;
    TextStyle editTextStyle = labelTheme.copyWith(
        color: onEditButtonColor, fontWeight: FontWeight.bold);

    final addButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: addButtonColor,
        onPressed: () async {
          model.switchTagEditMode(TagEditMode.create);
          model.tags.length == model.maximunTagNumber
              ? ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("個人標籤數量已達上限"),
                    duration: Duration(seconds: 1),
                  ),
                )
              : showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text("新增個人標籤"),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      children: [TagForm.create()],
                    );
                  }).then((value) {
                  if (value is ProfileTag) {
                    model.createNewTag(value);
                  }
                }).catchError((error) {
                  debugPrint(error.toString());
                });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: onAddButtonColor),
            Text('新增標籤', style: addButtonTextStyle),
          ],
        ),
      ),
    );
    final editButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: editButtonColor,
        onPressed: () {
          model.switchTagEditMode(model.tagEditMode == TagEditMode.create
              ? TagEditMode.edit
              : TagEditMode.create);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit,
              color: onEditButtonColor,
            ),
            Text(
              '修改標籤',
              style: editTextStyle,
            )
          ],
        ),
      ),
    );
    return model.tags.isNotEmpty ? [addButton, editButton] : [addButton];
  }

  final headlineText = "個人標籤";
  final contentText = "填寫名片資訊，可自由填寫 ，可選0 ~ 4項資訊自由填寫, ex 學校: 中央大學";

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditViewModel>(
      builder: (context, model, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          HeadlineWithContent(headLineText: headlineText, content: contentText),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: createToolBar(context, model)),
          Flexible(
            child: ListView.builder(
                clipBehavior: Clip.hardEdge,
                itemCount: model.tags.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return PersonalProileTagTextEditView(
                    tag: model.tags[index],
                    deleteTag: () {
                      model.deleteTag(index);
                    },
                    editTag: () async {
                      try {
                        final newTag = await showDialog(
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                                    title: const Text('修改標籤'),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    children: [
                                      TagForm.edit(tag: model.tags[index])
                                    ]));
                        model.editTag(newTag, index);
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}

class TagForm extends StatefulWidget {
  const TagForm({super.key, required this.mode, required this.tag});
  final String mode;
  final ProfileTag tag;
  // final ProfileEditViewModel model;
  factory TagForm.edit({required ProfileTag tag}) =>
      TagForm(mode: "edit", tag: tag);
  factory TagForm.create() =>
      TagForm(mode: "create", tag: ProfileTag(tag: "", content: ""));
  @override
  State<TagForm> createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
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
    keyText = widget.tag.tag;
    valueText = widget.tag.content;
    keyEditForm = TextFormField(
      maxLength: 10,
      controller: keyTextController
        ..text = keyText
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
        ..text = valueText
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
                  debugPrint("key: $keyText, value: $valueText");
                  // final newTag = ProfileTag(tag: keyText, content: valueText);
                  Navigator.of(context)
                      .pop(ProfileTag(tag: keyText, content: valueText));
                }
              },
              child: Text(widget.mode == "create" ? '新增' : '修改'),
            ),
          ],
        )
      ]),
    );
  }
}

class PersonalProileTagTextEditView extends StatefulWidget {
  final ProfileTag tag;
  final void Function() deleteTag;
  final void Function() editTag;
  const PersonalProileTagTextEditView({
    super.key,
    required this.tag,
    required this.deleteTag,
    required this.editTag,
  });

  @override
  State<PersonalProileTagTextEditView> createState() =>
      _PersonalProileTagTextEditViewState();
}

class _PersonalProileTagTextEditViewState
    extends State<PersonalProileTagTextEditView> {
  Widget createTag(BuildContext contextm, ProfileEditViewModel model) {
    final keyTextStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold);
    final valueTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.bold);
    final buttonColor = Theme.of(context).colorScheme.outline;
    final editTool = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
              onPressed: widget.editTag,
              icon: Icon(Icons.edit, color: buttonColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
              onPressed: widget.deleteTag,
              icon: Icon(Icons.remove, color: buttonColor)),
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
              model.tagEditMode == TagEditMode.edit ? editTool : Container()
            ],
          ),
        ],
      ),
    );
    return tag;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditViewModel>(
        builder: (context, model, child) =>
            model.tagEditMode == TagEditMode.edit
                ? ShakeWidget(child: createTag(context, model))
                : createTag(context, model));
  }
}

class ShakeWidget extends StatefulWidget {
  final Widget child;

  const ShakeWidget({super.key, required this.child});

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
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
