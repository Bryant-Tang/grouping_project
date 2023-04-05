import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

import 'package:image_picker/image_picker.dart';

class PersonProfileImageUpload extends StatefulWidget {
  File? profileImage;
  PersonProfileImageUpload({super.key});

  @override
  State<PersonProfileImageUpload> createState() =>
      _PersonProfileImageUploadgState();
}

class _PersonProfileImageUploadgState extends State<PersonProfileImageUpload> {
  XFile? _image;
  void _pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _image = value;
        debugPrint('image: ${_image!.path}');
        widget.profileImage = File(_image!.path);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const HeadlineWithContent(
            headLineText: "你的大頭貼照片", content: "名片上的大頭貼照片，如不上傳，可以使用預設照片"),
        Center(child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _image != null ? FileImage(File(_image!.path)) : Image.asset('assets/images/profile_male.png').image
                ),
              ),
              MaterialButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                color: Colors.grey[700],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: _pickImage,
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
                    ]),
              )
            ],
          ),
        )),
      ],
    );
  }
}
