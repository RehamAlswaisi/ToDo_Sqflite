import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';

  void saveDarkMode(bool isDarkTheme) {
    _box.write(_key, isDarkTheme);
  }

  bool loadDarkMode() {
    return _box.read<bool>(_key) ?? false;
  }

  ThemeMode get theme => loadDarkMode() ? ThemeMode.dark : ThemeMode.light;

  void switchThemeMode() {
    bool firstTimeRun = _box.read<bool>(_key) == null;
    if (firstTimeRun) {
      saveDarkMode(true);
      Get.changeThemeMode(theme);
      return;
    }
    if (loadDarkMode()) {
      saveDarkMode(false);
    } else {
      saveDarkMode(true);
    }
    Get.changeThemeMode(theme);
  }
}
