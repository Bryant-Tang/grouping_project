import 'dart:io';
import 'package:flutter/material.dart';

import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/service/storage_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class StorageTestPage extends StatefulWidget {
  const StorageTestPage({super.key});

  @override
  State<StorageTestPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<StorageTestPage>
    with TickerProviderStateMixin {
  StorageController _storageController = StorageController();
  final AuthService _authService = AuthService();

  XFile? one;
  List<XFile> all = [];

  @override
  void initState() {
    // TODO: implement initState
    _authService.emailLogIn('test@mail.com', 'password');
    _storageController
        .get(purpose: FilePurpose.profilepicture, type: FileType.picture)
        .then((value) {
      setState(() {
        one = value;
      });
    });
    _storageController.getAll(purpose: FilePurpose.other).then((value) {
      setState(() {
        if (value != null) {
          all = value;
          debugPrint('HEEEEEEEEEEEY, It\'s not empty\n');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('Refresh'))
          ],
        ),
        body: Column(children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: one != null ? FileImage(File(one!.path)) : null,
            radius: 120,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: lookupMimeType(all[0].path)!.startsWith('image/')
                ? FileImage(File(all[0].path))
                : FileImage(File(all[0].path)),
            radius: 120,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: FileImage(File(all[1].path)),
            radius: 120,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: FileImage(File(all[2].path)),
            radius: 120,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: FileImage(File(all[3].path)),
            radius: 120,
          )
        ]),
      ),
    );
  }
}
