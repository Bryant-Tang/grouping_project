import 'package:flutter/material.dart';

import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/testing/qr_view_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Generate QR code of a group
class ShowQRCodeView extends StatefulWidget {
  ShowQRCodeView({
    super.key,
  });

  @override
  State<ShowQRCodeView> createState() => _ShowQRCodeViewState();
}

class _ShowQRCodeViewState extends State<ShowQRCodeView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, value, child) => ChangeNotifierProvider<QRViewModel>(
        create: (_) => QRViewModel(),
        builder: (context, child) => Consumer<QRViewModel>(
          builder: (context, model, child) {
            debugPrint('Trying to show QR code');
            if (value.isPersonalAccount == false) {
              debugPrint('Printing group id, ${value.accountProfile.id}');
              model.showGroupId(value.accountProfile.id);
              model.updateWelcomeMessage(
                  'Welcome to ${value.accountProfile.name}!');
            } else {
              debugPrint('It\'s personal account');
              model.showGroupId('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
              model.updateWelcomeMessage('Never gonna give you up~');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImage(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  data: model.stringToShow,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                ),
                Text(model.welcomeMessage,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                // Padding(
                //     padding: const EdgeInsets.only(top: 20),
                //     child: ElevatedButton(
                //       onPressed: () => Navigator.pop(context),
                //       child: const Text('Go Back'),
                //     )),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// To scan QR code
class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

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
    return Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, value, child) => ChangeNotifierProvider(
              create: (context) => QRViewModel(),
              builder: (context, child) => Consumer<QRViewModel>(
                builder: (context, model, child) {
                  model.setPersonalModel(value.personalprofileData);
                  return Scaffold(
                      body: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        Expanded(
                          child: MobileScanner(
                            controller: controller,
                            // scanWindow: Rect.fr,
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
                                                await value.addGroupViaQR(
                                                    model.code,
                                                    model.groupAccountModel);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                setState(() {});
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

class QrCodeScannerTesting extends StatefulWidget {
  const QrCodeScannerTesting({super.key});

  @override
  State<QrCodeScannerTesting> createState() => _QrCodeScannerTestingrState();
}

class _QrCodeScannerTestingrState extends State<QrCodeScannerTesting> {
  MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, value, child) => ChangeNotifierProvider(
              create: (context) => QRViewModel(),
              builder: (context, child) => Consumer<QRViewModel>(
                builder: (context, model, child) {
                  model.setPersonalModel(value.personalprofileData);
                  return SizedBox(
                    height: MediaQuery.of(context).size.width * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MobileScanner(
                      // scanWindow: Rect.zero,
                      controller: controller,
                      // scanWindow: Rect.fr,
                      onDetect: (capture) async {
                        model.updateBarcode(capture.barcodes[0].rawValue ?? '');
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
                                          await value.addGroupViaQR(model.code,
                                              model.groupAccountModel);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text('確認'))
                                  ],
                                ));
                      },
                    ),
                  );
                },
              ),
            ));
  }
}
