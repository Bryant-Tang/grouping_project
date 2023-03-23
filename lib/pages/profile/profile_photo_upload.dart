import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

import 'package:image_picker/image_picker.dart';

class PersonProfileImageUpload extends StatefulWidget {
  Image? profileImage;
  PersonProfileImageUpload({super.key});

  @override
  State<PersonProfileImageUpload> createState() =>
      _PersonProfileImageUploadgState();
}

class _PersonProfileImageUploadgState extends State<PersonProfileImageUpload> {
  XFile? _image;
  void _pickImage(){
    ImagePicker().pickImage(source: ImageSource.gallery).then((value){
      setState(() {
        _image = value;
        widget.profileImage = Image.file(File(_image!.path));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const HeadlineWithContent(
            headLineText: "個人資訊設定", content: "新增全名、暱稱、自我介紹與心情小語，讓大家更快認識你"),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:
                    _image != null ? FileImage(File(_image!.path)) : null,
                radius: 100,
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
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(_controller);
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
