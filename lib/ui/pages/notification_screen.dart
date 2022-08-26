import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late String payload;
  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            payload.split('|')[1],
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (() {
              Get.back();
            }),
          )),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                'Hello Abood',
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                    fontWeight: FontWeight.w900,
                    fontSize: 30),
              ),
              const SizedBox(height: 10),
              Text(
                'You may have a new reminder ',
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
                color: primaryClr, borderRadius: BorderRadius.circular(30)),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myBodyNotification(Icons.text_format, 'Title'),
                    const SizedBox(height: 20),
                    Text(
                      payload.split('|')[0],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                    const Divider(
                      height: 20,
                      color: Colors.grey,
                    ),
                    myBodyNotification(Icons.description, 'Description'),
                    const SizedBox(height: 20),
                    Text(
                      payload.split('|')[1],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                    const Divider(
                      height: 20,
                      color: Colors.grey,
                    ),
                    myBodyNotification(Icons.calendar_today_outlined, 'Date'),
                    const SizedBox(height: 20),
                    Text(
                      payload.split('|')[2],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                  ]),
            ),
          )),
          const SizedBox(height: 10),
        ],
      )),
    );
  }

  myBodyNotification(IconData icon, String text) {
    return Row(children: [
      Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
      const SizedBox(
        width: 20,
      ),
      Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 30),
      )
    ]);
  }
}
