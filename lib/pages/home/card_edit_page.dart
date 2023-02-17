import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/cover.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class CardEditDone extends StatefulWidget {
  CardEditDone({super.key});
  @override
  State<CardEditDone> createState() => _cardEditDoneState();
}

class _cardEditDoneState extends State<CardEditDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'QUAN 的工作區',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                print('switch to personal Intro.');
                Navigator.pop(context);
              },
              icon: Icon(Icons.circle),
              // pop back to home_page.dart
            ),
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.all(5),
              width: 380,
              //height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      spreadRadius: 0.5,
                      blurRadius: 2,
                    )
                  ]),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 5,
                    child: Icon(Icons.edit_document),
                  ),
                  Positioned(
                      top: 20,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 380,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            createName(),
                            SizedBox(
                              height: 3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12),
                              ),
                            ),
                            createMyself(),
                            SizedBox(
                              height: 3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12),
                              ),
                            ),
                            createGrade(),
                            SizedBox(
                              height: 3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12),
                              ),
                            ),
                            createEmail(),
                            SizedBox(
                              height: 3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12),
                              ),
                            ),
                            createPhone(),
                            SizedBox(
                              height: 3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12),
                              ),
                            ),
                            createGithub(),
                            SizedBox(
                              height: 3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12),
                              ),
                            ),
                            createSkill()
                            /*
                  區間大小
                  SizedBox(height: 23, child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black12
                    ),
                  ),),
                  */
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      print('share');
                    },
                    child: Text(
                      'SHARE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                  ),
                  TextButton(
                    onPressed: () {
                      print('edit');
                    },
                    child: Text(
                      'EDIT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                  ),
                  TextButton(
                    onPressed: () {
                      print('theme');
                    },
                    child: Text(
                      'THEME',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                  ),
                ],
              ))
        ]));
  }
}

Container createName() {
  return Container(
    width: 340,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'QUEN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'a.k.a ' + 'QU',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Stack(
            children: [
              ClipPath(
                clipper: hexagon(),
                child: Container(
                  width: 153,
                  height: 76.5 * sqrt(3),
                  color: Colors.black,
                ),
              ),
              Positioned(
                  left: 1,
                  top: 1,
                  child: ClipPath(
                    clipper: hexagon(),
                    child: Container(
                      width: 150,
                      height: 75 * sqrt(3),
                      decoration: const BoxDecoration(
                          color: Colors.cyanAccent,
                          image: DecorationImage(
                              image: AssetImage('groupTest.png'),
                              fit: BoxFit.contain)),
                    ),
                  ))
            ],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Transform.rotate(
            angle: 180 * pi / 180,
            child: Icon(
              Icons.format_quote,
              size: 15,
              color: Colors.amber,
            ),
          ),
          Text(
            '今日事今日畢',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.format_quote,
            size: 15,
            color: Colors.amber,
          )
        ],
      )
    ]),
  );
}

// 將長方形裁剪出六角形
// https://educity.app/flutter/custom-clipper-in-flutter
class hexagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.25, size.height);
    path.lineTo(0, size.height * 0.5);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclip) => false;
}

Container createMyself() {
  return Container(
    width: 340,
    padding: EdgeInsets.symmetric(vertical: 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('自我介紹',
            style: TextStyle(
                color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
        Text(
          '''我是一位來自中央大學的宅宅，正朝著自己的夢想前進，目標是考上台大醫學院。我也喜歡打羽球，如果想要一起打的話可以聯絡我。
我很喜歡交朋友，如果你也喜歡也可以跟我聯絡，我們能一起吃飯或做其他事情之類的~
(想不到還可以打甚麼，所以隨便亂打充字數來測試一切ok或甚麼之類的)''',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          softWrap: true,
          maxLines: 5,
          overflow: TextOverflow.fade,
        )
      ],
    ),
  );
}

Container createGrade() {
  return Container(
    width: 340,
    padding: EdgeInsets.symmetric(vertical: 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('系級',
            style: TextStyle(
                color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
        Text(
          '中央大學 通訊工程學系 3年級',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.fade,
        )
      ],
    ),
  );
}

Container createEmail() {
  return Container(
    width: 340,
    padding: EdgeInsets.symmetric(vertical: 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('工作郵件',
            style: TextStyle(
                color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
        Text(
          'test@gmail.com',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.fade,
        )
      ],
    ),
  );
}

Container createPhone() {
  return Container(
    width: 340,
    padding: EdgeInsets.symmetric(vertical: 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('連絡電話',
            style: TextStyle(
                color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
        Text(
          '0800XXX000',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.fade,
        )
      ],
    ),
  );
}

Container createGithub() {
  return Container(
    width: 340,
    padding: EdgeInsets.symmetric(vertical: 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('GITHUB',
            style: TextStyle(
                color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
        Text(
          '我沒有github',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.fade,
        )
      ],
    ),
  );
}

Container createSkill() {
  return Container(
    width: 340,
    padding: EdgeInsets.symmetric(vertical: 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('專長',
            style: TextStyle(
                color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
        Text(
          'R語言以及一些資料統整相關知識',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          softWrap: false,
          maxLines: 2,
          overflow: TextOverflow.fade,
        )
      ],
    ),
  );
}
