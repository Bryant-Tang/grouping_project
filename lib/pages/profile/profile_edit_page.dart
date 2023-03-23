import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/pages/profile/profile_info.dart';
import 'package:grouping_project/pages/profile/profile_photo_upload.dart';
import 'package:grouping_project/pages/profile/profile_tag_edit.dart';

class EditPersonalProfilePage extends StatefulWidget {
  const EditPersonalProfilePage({super.key});

  @override
  State<EditPersonalProfilePage> createState() =>
      _EditPersonalProfilePageState();
}

class _EditPersonalProfilePageState extends State<EditPersonalProfilePage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  late final PerosonalProfileSetting personalProfileSetting;
  late final PersonalProfileTagSetting personalProfileTagSetting;
  late final PersonProfileImageUpload personalProfileImageUpload;
  TabController? _tabController;
  int _currentPageIndex = 0;
  late final List<Widget> _pages;

  List<Map<String, String>> getTagTable() {
    return [
      // {"key": "學校", "value": "國立中央大學"},
      // {"key": "生日", "value": "91/07/15"},
      // {"key": "號碼", "value": "0987685806"},
      // {"key": "號碼", "value": "0987685806"},
    ];
  }

  @override
  void initState() {
    super.initState();
    personalProfileSetting = PerosonalProfileSetting();
    personalProfileTagSetting = PersonalProfileTagSetting(tagTable: getTagTable());
    personalProfileImageUpload = const PersonProfileImageUpload();
    _pages = [
      personalProfileSetting,
      personalProfileTagSetting,
      personalProfileImageUpload
    ];
    _tabController = TabController(length: 3, vsync: this);
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
        _tabController!.index = _currentPageIndex;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 30),
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
                for (dynamic page in _pages) {
                  debugPrint(page.content.toString());
                }
              },
              goBackButtonHandler: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    ));
  }
}
