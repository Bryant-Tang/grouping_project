import 'package:flutter/material.dart';

class AddNote extends StatelessWidget {
  const AddNote({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        debugPrint('create Note');
      },
      splashFactory: InkRipple.splashFactory,
      child: Card(
        child: Container(
          width: 190,
          height: 300,
          color: const Color(0xFFFEFFF8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('images/Note.png'),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  '筆記 NOTE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    '與夥伴們建立共同筆記，共享知識庫，合作編輯會議記錄。',
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
