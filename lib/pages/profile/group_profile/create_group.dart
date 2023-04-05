import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/components/auth_view/headline_with_content.dart';
import 'package:grouping_project/components/auth_view/input_box.dart';
import 'package:grouping_project/components/auth_view/navigation_toggle_bar.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/profile_model.dart';
import 'package:grouping_project/pages/profile/personal_profile/inherited_profile.dart';
import 'package:grouping_project/pages/templates/sing_up_page_template.dart';
import 'package:image_picker/image_picker.dart';

class GroupInfo {
  String groupName;
  String groupDescription;
  List<String> groupTags;
  File groupImage;
  GroupInfo(
      {required this.groupName,
      required this.groupDescription,
      required this.groupTags,
      required this.groupImage});
  factory GroupInfo.empty() => GroupInfo(
      groupName: "", groupDescription: "", groupTags: [], groupImage: File(""));
}

class InhertedGroupInfo extends InheritedWidget {
  final GroupInfo groupInfo;
  const InhertedGroupInfo(
      {Key? key, required this.groupInfo, required Widget child})
      : super(key: key, child: child);
  static InhertedGroupInfo? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InhertedGroupInfo>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class CreateWorkspacePage extends StatefulWidget {
  CreateWorkspacePage({Key? key}) : super(key: key);
  final GroupInfo groupInfo = GroupInfo.empty();
  @override
  State<CreateWorkspacePage> createState() => _CreateWorkspacePageState();
}

// implement the state class
class _CreateWorkspacePageState extends State<CreateWorkspacePage> {
  // create a page controller
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
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
      callback: (name) {
        setState(() {
          widget.groupInfo.groupName = name;
        });
      },
    );
    workspaceDescriptionRegisterPage = WorkspaceDescriptionRegisterPage(
      forward: forward,
      backward: backward,
      callback: (content) {
        setState(() {
          widget.groupInfo.groupDescription = content;
        });
      },
    );
    workspaceTagRegisterPage = WorkspaceTagRegisterPage(
      forward: forward,
      backward: backward,
      callback: (selectedTags) {
        setState(() {
          widget.groupInfo.groupTags = selectedTags;
        });
      },
    );
    workspaceImageRegisterPage = WorkspaceImageRegisterPage(
      forward: register,
      backward: backward,
      callback: (file) {
        setState(() {
          widget.groupInfo.groupImage = file;
        });
      },
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
    final pageIndex = _pageController.page!.round();
    debugPrint(pageIndex.toString());
    if (pageIndex > 0) {
      _pageController.animateToPage(pageIndex - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void forward() {
    final pageIndex = _pageController.page!.round();
    if (pageIndex < _pages.length - 1) {
      _pageController.animateToPage(pageIndex + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void register() {
    // print out the group info
    final ProfileModel group = ProfileModel(
        name: widget.groupInfo.groupName,
        introduction: widget.groupInfo.groupDescription,
        tags: widget.groupInfo.groupTags
            .map((tags) => ProfileTag(tag: tags, content: tags))
            .toList(),
        photo: widget.groupInfo.groupImage);
    DataController().createGroup(group).then((value) {
      DataController()
          .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
          .then((value) {
        InheritedProfile.of(context)!.updateProfile(value);
      });
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("小組建立成功")));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InhertedGroupInfo(
        groupInfo: widget.groupInfo,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _pages,
          onPageChanged: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
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
      {super.key,
      required this.callback,
      required this.forward,
      required this.backward});
  final void Function(String) callback;
  final void Function() forward;
  final void Function() backward;
  @override
  State<WorkspaceNameRegisterPage> createState() =>
      _WorkspaceNameRegisterPageState();
}

class _WorkspaceNameRegisterPageState extends State<WorkspaceNameRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final inputBox = GroupingInputField(
    labelText: "小組名稱",
    boxIcon: Icons.people,
    boxColor: Colors.grey,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "小組名稱名稱請勿留空";
      } else {
        return null;
      }
    },
  );
  final headLineText = "小組名稱";
  final content = "你的小組要叫什麼名字呢？";
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent: HeadlineWithContent(
        headLineText: headLineText,
        content: content,
      ),
      body: Form(
        key: _formKey,
        child: inputBox
          ..setText(InhertedGroupInfo.of(context)!.groupInfo.groupName),
      ),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "上一步",
        goToNextButtonText: "下一步",
        goBackButtonHandler: () {
          widget.callback(inputBox.text ?? "");
          widget.backward();
        },
        goToNextButtonHandler: () {
          if (_formKey.currentState!.validate()) {
            widget.callback(inputBox.text ?? "");
            widget.forward();
          }
        },
      ),
    );
  }
}

class WorkspaceDescriptionRegisterPage extends StatefulWidget {
  const WorkspaceDescriptionRegisterPage(
      {super.key,
      required this.callback,
      required this.forward,
      required this.backward});
  final void Function(String) callback;
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
  final inputBox = GroupingInputField(
      labelText: "小組介紹",
      boxIcon: Icons.people,
      boxColor: Colors.grey,
      maxLength: 100,
      // maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "小組名稱名稱請勿留空";
        } else {
          return null;
        }
      });
  final headLineText = "小組介紹";
  final content = "簡述一下你的工作小組";
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent: HeadlineWithContent(
        headLineText: headLineText,
        content: content,
      ),
      body: Form(
        key: _formKey,
        child: inputBox
          ..setText(InhertedGroupInfo.of(context)!.groupInfo.groupDescription),
      ),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "上一步",
        goToNextButtonText: "下一步",
        goBackButtonHandler: () {
          widget.callback(inputBox.text ?? "");
          widget.backward();
        },
        goToNextButtonHandler: () {
          if (_formKey.currentState!.validate()) {
            widget.callback(inputBox.text ?? "");
            debugPrint(
                InhertedGroupInfo.of(context)!.groupInfo.groupDescription);
            debugPrint(InhertedGroupInfo.of(context)!.groupInfo.groupName);
            widget.forward();
          }
        },
      ),
    );
  }
}

class WorkspaceTagRegisterPage extends StatefulWidget {
  const WorkspaceTagRegisterPage(
      {super.key,
      required this.callback,
      required this.forward,
      required this.backward});
  final void Function(List<String>) callback;
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
  final List<String> tags = [
    "#社團",
    "#課程",
    "#打工",
    "#工作小組",
    "#程式學習",
    "#專題報告",
    "#讀書會",
    "#期末報告",
    "#其他"
  ];
  // TODO : let user add their own tags
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   selectedTags.addAll(InhertedGroupInfo.of(context)?.groupInfo.groupTags ?? []);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent: HeadlineWithContent(
        headLineText: headLineText,
        content: content,
      ),
      body: Form(
        key: _formKey,
        child: Builder(builder: (context) {
          selectedTags =
              InhertedGroupInfo.of(context)?.groupInfo.groupTags ?? [];
          return Wrap(
            children: tags
                .map((tag) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                        backgroundColor: Colors.grey.shade300,
                        selectedColor: Colors.amber,
                        label: Text(tag,
                            style: TextStyle(
                              color: selectedTags.contains(tag)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                            )),
                        selected: selectedTags.contains(tag),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              if (selectedTags.length < 4) {
                                // implement change label text color
                                selectedTags.add(tag);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("最多選擇四個標籤"),
                                  ),
                                );
                              }
                            } else {
                              selectedTags.remove(tag);
                            }
                          });
                        },
                      ),
                    ))
                .toList(),
          );
        }),
      ),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "上一步",
        goToNextButtonText: "下一步",
        goBackButtonHandler: () {
          widget.callback(selectedTags);
          widget.backward();
        },
        goToNextButtonHandler: () {
          if (_formKey.currentState!.validate()) {
            widget.callback(selectedTags);
            widget.forward();
          }
        },
      ),
    );
  }
}

class WorkspaceImageRegisterPage extends StatefulWidget {
  const WorkspaceImageRegisterPage(
      {super.key,
      required this.callback,
      required this.forward,
      required this.backward});
  final void Function(File) callback;
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
  String? imageFilePath;
  void _pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        imageFilePath = value?.path ?? imageFilePath;
        widget.callback(File(imageFilePath!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      imageFilePath = InhertedGroupInfo.of(context)?.groupInfo.groupImage.path;
      return SignUpPageTemplate(
        titleWithContent: HeadlineWithContent(
          headLineText: headLineText,
          content: content,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 120,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: imageFilePath != null
                                  ? FileImage(File(imageFilePath!))
                                  : defaultImage.image,
                            )),
                        MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
                            color: Colors.grey[700],
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            onPressed: _pickImage,
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
          goToNextButtonText: "下一步",
          goBackButtonHandler: () {
            widget.callback(
                imageFilePath != null ? File(imageFilePath!) : File(""));
            widget.backward();
          },
          goToNextButtonHandler: () {
            widget.callback(
                imageFilePath != null ? File(imageFilePath!) : File(""));
            widget.forward();
          },
        ),
      );
    });
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
        content: "即將完成了小組註冊",
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
