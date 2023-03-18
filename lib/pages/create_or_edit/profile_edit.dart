import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

import '../templates/sing_up_page_template.dart';

class EditPersonalProfilePage extends StatefulWidget {
  const EditPersonalProfilePage({super.key});

  @override
  State<EditPersonalProfilePage> createState() =>
      _EditPersonalProfilePageState();
}

class _EditPersonalProfilePageState extends State<EditPersonalProfilePage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  final perosonalProfileSeeting = PerosonalProfileSetting();
  final personalProfileTagSetting = PersonalProfileTagSetting();
  TabController? _tabController;
  int _currentPageIndex = 0;
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const HeadlineWithContent(
              headLineText: "個人資訊設定", content: "新增全名、暱稱、自我介紹與心情小語，讓大家更快認識你"),
          perosonalProfileSeeting
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const HeadlineWithContent(
              headLineText: "個人標籤",
              content: "填寫名片資訊，可自由填寫 ，可選0 ~ 4項資訊自由填寫, ex 學校: 中央大學"),
          personalProfileTagSetting,
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          HeadlineWithContent(
              headLineText: "照片上傳", content: "名片上的大頭貼，如不上傳，可以使用預設照片"),
          Placeholder(),
        ],
      ),
    ];
    _tabController = TabController(length: 3, vsync: this);
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
        // debugPrint('page index: $_currentPageIndex');
        _tabController!.index = _currentPageIndex;
        // debugPrint('tab index: ${_tabController?.index}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _pages,
            ),
          ),
          SizedBox(
            height: 60.0,
            child: Center(
              child: TabPageSelector(
                controller: _tabController,
                color: Colors.white,
                selectedColor: Colors.amber,
                indicatorSize: 16,
              ),
            ),
          ),
          NavigationToggleBar(
              goBackButtonText: "Cancel",
              goToNextButtonText: "Save",
              goToNextButtonHandler: () {
                setState(() {});
                debugPrint(
                    perosonalProfileSeeting.personalInformation.toString());
              },
              goBackButtonHandler: () {})
        ],
      ),
    )); // return
  }
}

class PersonalProfileTagSetting extends StatefulWidget {
  const PersonalProfileTagSetting({super.key});

  @override
  State<PersonalProfileTagSetting> createState() =>
      _PersonalProfileTagSettingState();
}

class _PersonalProfileTagSettingState extends State<PersonalProfileTagSetting> {
  late final MaterialButton addButton;
  late final MaterialButton editButton;
  // late MaterialButton buttonBar;
  late List<Widget> tags;
  List tagTable = [
    {"key": "學校", "value": "國立中央大學"},
    {"key": "生日", "value": "91/07/15"},
    {"key": "號碼", "value": "0987685806"},
    {"key": "系級", "value": "中央資工3B"},
  ];
  List<Widget> tagsBuilder() {
    List<Widget> tagList =
        tagTable.isNotEmpty ? [addButton, editButton] : [addButton];
    for (dynamic tag in tagTable) {
      tagList.add(PersonalProileTagTextEditView(
        tagKey: tag['key'],
        tagValue: tag['value'],
      ));
    }
    //List<Widget> buttonList;
    // if(tagTable.isEmpty)
    // tagList.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: buttonList
    // );
    return tagList;
  }

  @override
  void initState() {
    super.initState();
    addButton = MaterialButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: Colors.amber,
      onPressed: () {
        for (dynamic tag in tagTable) {
          debugPrint("${tag['key']} , ${tag['value']}");
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
    );
    editButton = MaterialButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.amber)),
      color: Colors.white,
      onPressed: () {
        for (dynamic tag in tagTable) {
          debugPrint("${tag['key']} , ${tag['value']}");
        }
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
    );
    tags = tagsBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tags,
    );
  }
}

class PersonalProileTagTextEditView extends StatelessWidget {
  final String tagKey;
  final String tagValue;
  final TextStyle keyTextStyle = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber);
  final TextStyle valueTextStyle = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey);
  const PersonalProileTagTextEditView({
    super.key,
    required this.tagKey,
    required this.tagValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(tagKey, style: keyTextStyle),
          const Divider(
            thickness: 1,
          ),
          Text(tagValue, style: valueTextStyle),
        ],
      ),
    );
  }
}

class PerosonalProfileSetting extends StatefulWidget {
  PerosonalProfileSetting({super.key});
  late Map<String, String?> personalInformation;
  @override
  State<PerosonalProfileSetting> createState() =>
      _PerosonalProfileSettingState();
  static _PerosonalProfileSettingState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PerosonalProfileSettingState>();
}

class _PerosonalProfileSettingState extends State<PerosonalProfileSetting> {
  final _formKey = GlobalKey<FormState>();
  final userNameEditTextController = TextEditingController();
  final userReallNameEditTextController = TextEditingController();
  final userMottoEditTextController = TextEditingController();
  final userIntroductioionEditController = TextEditingController();
  late TextFormField userNameField;
  late TextFormField userRealNameField;
  late TextFormField userMottoField;
  late TextFormField userIntroductionField;
  @override
  void initState() {
    super.initState();
    userNameField = TextFormField(
      // 預設會是UserName
      controller: userNameEditTextController,
      //initialValue: "Your User Name",
      decoration: const InputDecoration(
        label: Text("使用者名稱 / User Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userRealNameField = TextFormField(
      // 預設會是UserName
      controller: userReallNameEditTextController,
      decoration: const InputDecoration(
        label: Text("本名 / Real Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userMottoField = TextFormField(
      controller: userMottoEditTextController,
      decoration: const InputDecoration(
        label: Text("心情小語 / 座右銘"),
        icon: Icon(Icons.chat),
      ),
    );
    widget.personalInformation = getAllFormContent();
    userIntroductionField = TextFormField(
      maxLength: 50,
      maxLines: 3,
      controller: userIntroductioionEditController,
      decoration: const InputDecoration(
        label: Text("自我介紹"),
        icon: Icon(Icons.chat),
      ),
    );
    userNameEditTextController.addListener(() {
      widget.personalInformation = getAllFormContent();
    });
    userReallNameEditTextController.addListener(() {
      widget.personalInformation = getAllFormContent();
    });
    userMottoEditTextController.addListener(() {
      widget.personalInformation = getAllFormContent();
    });
    userIntroductioionEditController.addListener(() {
      widget.personalInformation = getAllFormContent();
    });
  }

  @override
  void dispose() {
    userNameEditTextController.dispose();
    userReallNameEditTextController.dispose();
    userMottoEditTextController.dispose();
    userIntroductioionEditController.dispose();
    super.dispose();
  }

  Map<String, String?> getAllFormContent() {
    return {
      'userName': userNameEditTextController.text,
      'userRealName': userReallNameEditTextController.text,
      'userMotto': userMottoEditTextController.text,
      'userInroduction': userIntroductioionEditController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            userNameField,
            userRealNameField,
            userMottoField,
            userIntroductionField
          ],
        ),
      ),
    );
  }
}
