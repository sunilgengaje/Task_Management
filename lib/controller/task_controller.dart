import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart'; // Make sure the Task class is properly imported
import 'dart:convert';

class TaskController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }

  // Load tasks from shared preferences
  _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    tasks.value = taskList
        .map((task) => Task.fromJson(json.decode(task)))
        .toList();
  }

  // Add a new task
  addTask(Task task) async {
    tasks.add(task);
    _saveTasks();
  }

  // Save tasks to shared preferences
  _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => json.encode(task.toJson()))
        .toList();
    await prefs.setStringList('tasks', taskList);
  }

  // Update task completion status
  toggleCompletion(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    _saveTasks();
  }

  // Remove a task
  removeTask(int index) {
    tasks.removeAt(index);
    _saveTasks();
  }


  // Update the task with new details
  void updateTask(Task updatedTask) {
    int index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask; // Replace the task in the list
      update(); // Notify listeners
    }
  }



  // Delete task method
  void deleteTask(int index) {
    tasks.removeAt(index);
    update(); // Update listeners
  }
}