import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/profile/personal_profile/inherited_profile.dart';
import 'package:grouping_project/pages/profile/personal_profile/profile_info.dart';
import 'package:grouping_project/pages/profile/personal_profile/profile_photo_upload.dart';
import 'package:grouping_project/pages/profile/personal_profile/profile_tag_edit.dart';

class EditPersonalProfilePage extends StatefulWidget {
  ProfileModel profile;
  EditPersonalProfilePage({super.key, required this.profile});
  @override
  State<EditPersonalProfilePage> createState() =>
      _EditPersonalProfilePageState();
}

class _EditPersonalProfilePageState extends State<EditPersonalProfilePage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  ProfileModel profile = ProfileModel();
  final _dataController = DataController();
  TabController? _tabController;
  int _currentPageIndex = 0;
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = const [
      PerosonalProfileSetting(),
      PersonalProfileTagSetting(),
      PersonProfileImageUpload(),
    ];
    _tabController = TabController(length: 3, vsync: this);
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
        _tabController!.index = _currentPageIndex;
      });
    });
  }

  void updateProfile() {
    _dataController
        .upload(uploadData: widget.profile)
        .then((value) => debugPrint('upload successfully'));
    // InheritedProfile.of(context)!.updateProfile(profile);
    Navigator.of(context).pop(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProfile(
      profile: widget.profile,
      updateProfile: (ProfileModel newProfile) {
        setState(() {
          widget.profile = newProfile;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
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
                    goToNextButtonHandler: updateProfile,
                    goBackButtonHandler: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
