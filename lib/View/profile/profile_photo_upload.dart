import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/component_lib.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
    return Consumer<ProfileEditViewModel>(builder: (context, model, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          HeadlineWithContent(headLineText: headLineText, content:contentText),
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
                          : Image.asset('assets/images/profile_male.png')
                              .image),
                ),
                MaterialButton(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
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
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
