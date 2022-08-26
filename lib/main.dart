import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp/db/db_helper.dart';
import 'package:todoapp/ui/theme.dart';

import 'services/theme_services.dart';
import 'ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isInit = await DBHelper().initDB();

  await GetStorage.init();
  runApp(MyApp());
  //NotifyHelper().initializationNotification();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeServices().theme,
        theme: Themes.light,
        darkTheme: Themes.dark,
        home: const HomePage()

        //home: const NotificationScreen(payload: 'My Screen | Hello | 08-20-2022'),
        );
  }
}
