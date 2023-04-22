/*

**  ATTENTION  **
This is a empty test Widget, it's only used as test. Therefore, please don't delete it.

*/
import 'package:flutter/material.dart';

import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/testing/qr_view_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/database_service.dart';

import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Generate QR code of a group
class QRView extends StatefulWidget {
  WorkspaceDashBoardViewModel workspaceDashBoardViewModel =
      WorkspaceDashBoardViewModel();
  QRView({
    super.key,
    required this.workspaceDashBoardViewModel,
  });

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
      value: widget.workspaceDashBoardViewModel,
      builder: (context, child) => ChangeNotifierProvider<QRViewModel>(
          create: (_) => QRViewModel(),
          builder: (context, child) => Consumer<QRViewModel>(
                builder: (context, model, child) {
                  debugPrint('Trying to show QR code');
                  if (widget.workspaceDashBoardViewModel.isPersonalAccount ==
                      false) {
                    debugPrint(
                        'Printing group id, ${widget.workspaceDashBoardViewModel.accountProfile.id}');
                    model.showGroupId(
                        widget.workspaceDashBoardViewModel.accountProfile.id);
                    model.updateWelcomeMessage(
                        'Welcome to ${widget.workspaceDashBoardViewModel.accountProfile.name}!');
                  } else {
                    debugPrint('It\'s personal account');
                    model.showGroupId(
                        'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
                    model.updateWelcomeMessage('Never gonna give you up~');
                  }
                  return Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QrImage(
                          data: model.stringToShow,
                          version: QrVersions.auto,
                          size: 300,
                          gapless: false,
                        ),
                        Text(model.welcomeMessage,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Go Back'),
                            )),
                      ],
                    ),
                  );
                },
              )),
    );
  }
}

/// To scan QR code
class QrCodeScanner extends StatefulWidget {
  WorkspaceDashBoardViewModel workspaceDashBoardViewModel;
  QrCodeScanner({super.key, required this.workspaceDashBoardViewModel});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.workspaceDashBoardViewModel,
        builder: (context, child) => ChangeNotifierProvider(
              create: (context) => QRViewModel(),
              builder: (context, child) => Consumer<QRViewModel>(
                builder: (context, model, child) {
                  model.setPersonalModel(
                      widget.workspaceDashBoardViewModel.personalprofileData);
                  return Scaffold(
                      body: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        Expanded(
                          child: MobileScanner(
                            controller: controller,
                            onDetect: (capture) async {
                              model.updateBarcode(
                                  capture.barcodes[0].rawValue ?? '');
                              controller.stop();
                              await model.setGroupModel();
                              // debugPrint(
                              //     '=> Barcode detected: ${model.code}');
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                            '您已被邀請加入${model.groupAccountModel.nickname}'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('取消')),
                                          TextButton(
                                              onPressed: () async {
                                                model.addAssociation();
                                                await widget
                                                    .workspaceDashBoardViewModel
                                                    .addGroupViaQR(
                                                        model.code,
                                                        model
                                                            .groupAccountModel);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('確認'))
                                        ],
                                      ));
                            },
                          ),
                        ),
                        Text(
                          '掃描完成後，請稍等片刻',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go back')),
                      ]));
                },
              ),
            ));
  }
}
