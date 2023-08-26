import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String fileName;
  final String name;
  final void Function() onPressed;
  const AuthButton({
    super.key,
    required this.fileName,
    required this.name,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    "assets/icons/authIcon/$fileName",
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${name.toUpperCase()} 帳號登入",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
