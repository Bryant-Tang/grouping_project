import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/VM/create_group_view_model.dart';
import 'package:grouping_project/components/auth_view/headline_with_content.dart';
import 'package:grouping_project/components/auth_view/navigation_toggle_bar.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/profile_model.dart';
import 'package:grouping_project/pages/view_template/sing_up_page_template.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateWorkspacePage extends StatefulWidget {
  const CreateWorkspacePage({Key? key}) : super(key: key);
  @override
  State<CreateWorkspacePage> createState() => _CreateWorkspacePageState();
}

// implement the state class
class _CreateWorkspacePageState extends State<CreateWorkspacePage> {
  final PageController _pageController = PageController();
  late final List<Widget> _pages;
  late final StartingPage startingPage;
  late final WorkspaceDescriptionRegisterPage workspaceDescriptionRegisterPage;
  late final WorkspaceNameRegisterPage workspaceNameRegisterPage;
  late final WorkspaceTagRegisterPage workspaceTagRegisterPage;
  late final WorkspaceImageRegisterPage workspaceImageRegisterPage;
  late final EndingPage endingPage;
  @override
  void initState() {
    super.initState();
    startingPage = StartingPage(
      forward: forward,
      backward: () {
        Navigator.pop(context);
      },
    );
    workspaceNameRegisterPage = WorkspaceNameRegisterPage(
      forward: forward,
      backward: backward,
    );
    workspaceDescriptionRegisterPage = WorkspaceDescriptionRegisterPage(
      forward: forward,
      backward: backward,
    );
    workspaceTagRegisterPage = WorkspaceTagRegisterPage(
      forward: forward,
      backward: backward,
    );
    workspaceImageRegisterPage = WorkspaceImageRegisterPage(
      forward: register,
      backward: backward,
    );
    // endingPage = EndingPage(
    //   forward: register,
    //   backward: backward,
    // );
    _pages = <Widget>[
      startingPage,
      workspaceNameRegisterPage,
      workspaceDescriptionRegisterPage,
      workspaceTagRegisterPage,
      workspaceImageRegisterPage,
      // endingPage,
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void backward() {
    FocusScope.of(context).requestFocus(FocusNode());
    final pageIndex = _pageController.page!.round();
    if (pageIndex > 0) {
      _pageController.animateToPage(pageIndex - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void forward() {
    FocusScope.of(context).requestFocus(FocusNode());
    final pageIndex = _pageController.page!.round();
    if (pageIndex < _pages.length - 1) {
      _pageController.animateToPage(pageIndex + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void register() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("小組建立成功")));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateGroupViewModel>(
      create: (context) => CreateGroupViewModel()..init(),
      child: Consumer<CreateGroupViewModel>(
        builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: model.onPageChange,
              children: _pages,
            ),
          ),
        ),
      ),
    );
  }
}

class StartingPage extends StatelessWidget {
  final void Function() forward;
  final void Function() backward;
  const StartingPage(
      {super.key, required this.forward, required this.backward});
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent: const HeadlineWithContent(
        headLineText: "創建新的小組",
        content: "您將創建自己的小組，並且邀請其他人加入",
      ),
      body: Image.asset("assets/images/conference.png"),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "取消",
        goToNextButtonText: "下一步",
        goBackButtonHandler: backward,
        goToNextButtonHandler: forward,
      ),
    );
  }
}

class WorkspaceNameRegisterPage extends StatefulWidget {
  const WorkspaceNameRegisterPage(
      {super.key, required this.forward, required this.backward});
  final void Function() forward;
  final void Function() backward;
  @override
  State<WorkspaceNameRegisterPage> createState() =>
      _WorkspaceNameRegisterPageState();
}

class _WorkspaceNameRegisterPageState extends State<WorkspaceNameRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final headLineText = "小組名稱";
  final content = "你的小組要叫什麼名字呢？";
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateGroupViewModel>(
      builder: (context, model, child) => SignUpPageTemplate(
        titleWithContent: HeadlineWithContent(
          headLineText: headLineText,
          content: content,
        ),
        body: Form(
          key: _formKey,
          child: TextFormField(
              initialValue: model.userName,
              decoration: const InputDecoration(
                label: Text("小組名稱 / User Name"),
                icon: Icon(Icons.person_pin_outlined),
              ),
              onChanged: model.updateUserName),
        ),
        toggleBar: NavigationToggleBar(
          goBackButtonText: "上一步",
          goToNextButtonText: "下一步",
          goBackButtonHandler: widget.backward,
          goToNextButtonHandler: () {
            if (_formKey.currentState!.validate()) {
              widget.forward();
            }
          },
        ),
      ),
    );
  }
}

class WorkspaceDescriptionRegisterPage extends StatefulWidget {
  const WorkspaceDescriptionRegisterPage(
      {super.key, required this.forward, required this.backward});
  final void Function() forward;
  final void Function() backward;
  @override
  State<WorkspaceDescriptionRegisterPage> createState() =>
      _WorkspaceDescriptionRegisterPageState();
}

// implement the state class
class _WorkspaceDescriptionRegisterPageState
    extends State<WorkspaceDescriptionRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final headLineText = "小組介紹";
  final content = "簡述一下你的工作小組";
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateGroupViewModel>(
      builder: (context, model, child) => SignUpPageTemplate(
        titleWithContent: HeadlineWithContent(
          headLineText: headLineText,
          content: content,
        ),
        body: Form(
          key: _formKey,
          child: TextFormField(
            initialValue: model.introduction,
            decoration: const InputDecoration(
              label: Text("小組介紹 / Group Introduction"),
              icon: Icon(Icons.person_pin_outlined),
            ),
            onChanged: model.updateIntroduction,
          ),
        ),
        toggleBar: NavigationToggleBar(
          goBackButtonText: "上一步",
          goToNextButtonText: "下一步",
          goBackButtonHandler: widget.backward,
          goToNextButtonHandler: () {
            if (_formKey.currentState!.validate()) {
              widget.forward();
            }
          },
        ),
      ),
    );
  }
}

class WorkspaceTagRegisterPage extends StatefulWidget {
  const WorkspaceTagRegisterPage(
      {super.key, required this.forward, required this.backward});
  final void Function() forward;
  final void Function() backward;
  @override
  State<WorkspaceTagRegisterPage> createState() =>
      _WorkspaceTagRegisterPageState();
}

//implement the state class
class _WorkspaceTagRegisterPageState extends State<WorkspaceTagRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final headLineText = "小組標籤";
  final content = "為你的小組選擇一個或多個標籤";
  // TODO : let user add their own tags
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateGroupViewModel>(
      builder: (context, model, child) => SignUpPageTemplate(
        titleWithContent: HeadlineWithContent(
          headLineText: headLineText,
          content: content,
        ),
        body: Form(
            key: _formKey,
            child: Wrap(
                children: List.generate(
              model.labelTags.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChip(
                  selected: model.isSelected[index],
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  label: Text(model.labelTags[index],
                      style: TextStyle(
                        color: model.isSelected[index]
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                        fontSize: 14,
                      )),
                  onSelected: (value) {
                    final res = model.toggleSelected(value, index);
                    if (res == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("最多選擇四個標籤"),
                        ),
                      );
                    }
                  },
                ),
              ),
            ))),
        toggleBar: NavigationToggleBar(
          goBackButtonText: "上一步",
          goToNextButtonText: "下一步",
          goBackButtonHandler: widget.backward,
          goToNextButtonHandler: () {
            if (_formKey.currentState!.validate()) {
              widget.forward();
            }
          },
        ),
      ),
    );
  }
}

class WorkspaceImageRegisterPage extends StatefulWidget {
  const WorkspaceImageRegisterPage(
      {super.key, required this.forward, required this.backward});
  final void Function() forward;
  final void Function() backward;
  @override
  State<WorkspaceImageRegisterPage> createState() =>
      _WorkspaceImageRegisterPageState();
}

// implement the state class
class _WorkspaceImageRegisterPageState
    extends State<WorkspaceImageRegisterPage> {
  final headLineText = "小組圖片";
  final content = "選擇一張圖片作為你的小組圖片";
  final imagePicker = ImagePicker();
  final defaultImage = Image.asset("assets/images/profile_male.png");

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateGroupViewModel>(
      builder: (context, model, child) => SignUpPageTemplate(
        titleWithContent: HeadlineWithContent(
          headLineText: headLineText,
          content: content,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Center(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: model.profileImage != null
                              ? Image.file(model.profileImage!).image
                              : defaultImage.image,
                        )),
                    MaterialButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 20),
                        color: Colors.grey[700],
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                            children: const [
                              Text(
                                '上傳圖片',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.file_upload_outlined,
                                color: Colors.white,
                              )
                            ]))
                  ])))
        ]),
        toggleBar: NavigationToggleBar(
          goBackButtonText: "上一步",
          goToNextButtonText: "完成",
          goBackButtonHandler: widget.backward,
          goToNextButtonHandler: () {
            model.createGroup();
            widget.forward();
          },
        ),
      ),
    );
  }
}

class EndingPage extends StatelessWidget {
  const EndingPage({super.key, required this.backward, required this.forward});
  final void Function() forward;
  final void Function() backward;
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent: const HeadlineWithContent(
        headLineText: "確認小組訊息",
        content: "即將完成小組註冊",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // HeadlineWithContent(headLineText: "Name", content: )
          Text("你可以在小組頁面中編輯小組資訊"),
          Text("或是在小組列表中找到你的小組"),
        ],
      ),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "上一步",
        goToNextButtonText: "完成",
        goBackButtonHandler: backward,
        goToNextButtonHandler: forward,
      ),
    );
  }
}
