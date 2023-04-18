import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/View/profile/profile_info.dart';
import 'package:grouping_project/View/profile/profile_photo_upload.dart';
import 'package:grouping_project/View/profile/profile_tag_edit.dart';
import 'package:provider/provider.dart';

class ProfileEditPageView extends StatefulWidget {
  const ProfileEditPageView({super.key});
  @override
  State<ProfileEditPageView> createState() => _ProfileEditPageViewState();
}

class _ProfileEditPageViewState extends State<ProfileEditPageView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileEditViewModel>(
      create: (context) => ProfileEditViewModel()..init(),
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
