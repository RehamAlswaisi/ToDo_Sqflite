import 'package:flutter/material.dart';

import '../theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.lable,
    required this.onTap,
  }) : super(key: key);

  final String lable;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: primaryClr, borderRadius: BorderRadius.circular(20)),
        width: 100,
        height: 45,
        child: Text(lable,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center),
      ),
    );
  }
}
