/*

**  ATTENTION  **
This is a empty test Widget, it's only used as test. Therefore, please don't delete it.

*/
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math';

class EmptyWidget extends StatefulWidget {
  const EmptyWidget({super.key});

  @override
  State<EmptyWidget> createState() => _QrCodeState();
}

class _QrCodeState extends State<EmptyWidget> {
  List<Text> items = [];
  int data = Random().nextInt(100000);

  void getQrcodeData() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const QrCodeScanner()));
    setState(() {
      items.add(Text('$result'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: ListView(
                  key: ValueKey(items.length),
                  children: items,
                )),
            Expanded(
                flex: 1,
                child: QrImage(
                  data: 'data $data',
                  version: QrVersions.auto,
                  size: 300,
                  gapless: false,
                )),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () => setState(() {
                          data = Random().nextInt(100000);
                          debugPrint(data.toString());
                        }),
                    child: const Text('New QrCode')),
                TextButton(
                    onPressed: getQrcodeData, child: const Text('Scan QrCode')),
                TextButton(
                    onPressed: () => setState(() {
                          items = [];
                        }),
                    child: const Text('Reset Items'))
              ],
            ))
          ],
        ),
      ),
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    Navigator.of(context).pop(capture.barcodes[0].rawValue);
                    controller.stop();
                    // Navigator.pop(context, capture.barcodes[0].rawValue);
                    // debugPrint(capture.barcodes[0].rawValue);
                  }),
            ),
            Expanded(
                child: TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ))
          ],
        ),
      ),
    );
  }
}
