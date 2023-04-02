// building page
// show a building page when this page has not been implemented yet
// image file name : technical_support.png
import "package:flutter/material.dart";
import "package:grouping_project/components/auth_view/headline_with_content.dart";

class BuildingPage extends StatelessWidget {
  final String errorMessage;
  const BuildingPage({super.key, this.errorMessage = "page is building"});
  factory BuildingPage.fromError(String errorMessage) {
    return BuildingPage(errorMessage: errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HeadlineWithContent(headLineText: '測試頁面', content: errorMessage),
            Image.asset('assets/images/technical_support.png'),
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
