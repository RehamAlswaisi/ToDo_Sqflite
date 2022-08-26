import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../size_config.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[200] : Colors.grey[700],
                  readOnly: widget != null ? true : false,
                  style: Themes.subTitleStyle,
                  controller: controller,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: hint,
                    labelStyle: Themes.subTitleStyle,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor)),
                  ),
                )),
                widget ?? Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
