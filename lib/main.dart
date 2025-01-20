/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ui_screens/task_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager',
      home: TaskListScreen(),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui_screens/task_list_screen.dart'; // Assuming this exists in your project

// ThemeController to manage dark/light mode with SharedPreferences
class ThemeController extends GetxController {
  // RxBool to handle dark mode state
  RxBool isDarkMode = false.obs;

  // Load theme preference from SharedPreferences
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool('darkMode') ?? false;
    isDarkMode.value = darkMode;
  }

  // Toggle theme and save to SharedPreferences
  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode.value);
  }
}

// Main app widget
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create an instance of ThemeController
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    // Load the theme preference when the app starts
    themeController.loadTheme();

    return Obx(() {
      return GetMaterialApp(
        title: 'Task Manager',
        theme: themeController.isDarkMode.value ? ThemeData.dark() : ThemeData.light(),
        home: TaskListScreen(), // Replace with your actual screen
      );
    });
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui_screens/task_list_screen.dart'; // Assuming this exists in your project

// ThemeController to manage dark/light mode with SharedPreferences
class ThemeController extends GetxController {
  // RxBool to handle dark mode state
  RxBool isDarkMode = false.obs;

  // Load theme preference from SharedPreferences
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool('darkMode') ?? false;
    isDarkMode.value = darkMode;
  }

  // Toggle theme and save to SharedPreferences
  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode.value);
  }
}

// Main app widget
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create an instance of ThemeController
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    // Load the theme preference when the app starts
    themeController.loadTheme();

    return Obx(() {
      return GetMaterialApp(
        title: 'Task Manager',
        theme: themeController.isDarkMode.value ? ThemeData.dark() : ThemeData.light(),
        home: TaskListScreen(), // Replace with your actual screen
      );
    });
  }
}


