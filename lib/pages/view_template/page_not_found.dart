import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

// build 404 page widget when error thrown return this page
// put image in the central of the page
// image path: assets/images/404_not_found.png
// need headlin_with_content widget
// headline : 這個頁面還未被開發
// content : 404 not found

class NotFoundPage extends StatelessWidget {
  final String errorMessage;
  const NotFoundPage({super.key, this.errorMessage = "404 not found"});
  factory NotFoundPage.fromError(String errorMessage) {
    return NotFoundPage(errorMessage: errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 120.0, 30.0, 120.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeadlineWithContent(
                headLineText: '似乎出現了一些問題', content: errorMessage),
            Image.asset('assets/images/404_not_found.png'),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.amber),
                  borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text("點我返回",
                    style: TextStyle(color: Colors.amber, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
