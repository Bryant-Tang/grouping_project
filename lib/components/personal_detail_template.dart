import 'package:flutter/material.dart';
import 'dart:math';

class CustomLabel extends StatelessWidget {
  const CustomLabel(
      {super.key, required this.title, required this.information});

  final String title;
  final String information;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 5,),
          const Divider(
            thickness: 1.5,
            color: Color.fromARGB(255, 209, 209, 209),
            height: 20,
          ),
          Text(
            title,
            style: const TextStyle(
                color: Color(0xFFFCBF49),
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            information,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            softWrap: true,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}

class HeadShot extends StatelessWidget {
  const HeadShot(
      {super.key,
      required this.name,
      required this.nickName,
      required this.imageShot,
      required this.motto});

  final String name;
  final String nickName;
  final Image imageShot;
  final String motto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      name.isEmpty ? 'unknown' : name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      nickName.isEmpty ? '(No nickname)' : 'a.k.a $nickName',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Stack(
                  children: [
                    ClipPath(
                      clipper: Hexagon(),
                      child: Container(
                        width: 153,
                        height: 76.5 * sqrt(3),
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                        left: 1.5,
                        top: 1.5,
                        child: ClipPath(
                          clipper: Hexagon(),
                          child: Container(
                            width: 150,
                            height: 75 * sqrt(3),
                            decoration: BoxDecoration(
                                color: Colors.cyanAccent,
                                image: DecorationImage(
                                    image: imageShot.image,
                                    fit: BoxFit.fill)),
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
                  angle: pi,
                  child: const Icon(
                    Icons.format_quote,
                    size: 15,
                    color: Color(0xFFFCBF49),
                  ),
                ),
                Text(
                  motto.isEmpty ? 'No gain no pain' : motto,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.format_quote,
                  size: 15,
                  color: Color(0xFFFCBF49),
                )
              ],
            )
          ],
        ));
  }
}

// 將長方形裁剪出六角形
// https://educity.app/flutter/custom-clipper-in-flutter
class Hexagon extends CustomClipper<Path> {
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
