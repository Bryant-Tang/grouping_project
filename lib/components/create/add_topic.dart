import 'package:flutter/material.dart';

class AddTopic extends StatelessWidget {
  const AddTopic({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        debugPrint('create Topic');
      },
      splashFactory: InkRipple.splashFactory,
      child: Card(
        child: Container(
          width: 190,
          height: 300,
          color: const Color(0xFFFFE3E5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/topic.png'),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  '話題 TOPIC',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    '與夥伴們任意開啟一個話題、指定任務、事件，或聊聊新的idea吧。',
                    softWrap: true,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
