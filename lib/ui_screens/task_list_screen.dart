/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';
import '../models/task.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController taskController = Get.put(TaskController());

  // List to store the selected tasks for deletion
  RxList<bool> _selectedTasks = RxList.generate(0, (_) => false);

  // Flag to toggle "Select All"
  RxBool _selectAll = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          // Row containing Select All text and checkbox
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text for "Select All"
                Text('Select All'),

                // Checkbox for "Select All"
                Obx(() {
                  return Checkbox(
                    value: _selectAll.value,
                    onChanged: (value) {
                      setState(() {
                        _selectAll.value = value!;
                        // Sync selected tasks with Select All checkbox
                        _selectedTasks.value = List<bool>.generate(
                            taskController.tasks.length,
                                (_) => value
                        );
                      });
                    },
                  );
                }),
              ],
            ),
          ),

          // List of tasks with checkboxes
          Expanded(
            child: Obx(() {
              // Ensure the selectedTasks list matches the tasks list length
              if (_selectedTasks.length != taskController.tasks.length) {
                _selectedTasks.value = List<bool>.generate(
                    taskController.tasks.length, (_) => false);
              }

              return ListView.builder(
                itemCount: taskController.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskController.tasks[index];
                  Color flagColor;
                  Icon flagIcon;

                  // Set flag icon color based on priority
                  switch (task.priority) {
                    case 'Medium':
                      flagColor = Colors.orange;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                      break;
                    case 'Low':
                      flagColor = Colors.yellow;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                      break;
                    default:
                      flagColor = Colors.red;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                  }

                  // If task is completed, change flag color to green
                  if (task.isCompleted) {
                    flagColor = Colors.green;
                    flagIcon = Icon(Icons.flag, color: flagColor);
                  }

                  // Format due date if available
                  String dueDateText = task.dueDate != null
                      ? 'Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}'
                      : 'No Due Date';

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Text(task.title), // Use task.title, not task.name
                      subtitle: Text(dueDateText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          flagIcon,
                          // Checkbox for selection
                          Checkbox(
                            value: _selectedTasks[index],
                            onChanged: (value) {
                              setState(() {
                                _selectedTasks[index] = value!;
                                _selectAll.value = _selectedTasks.every((selected) => selected);
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to task detail page
                        Get.to(TaskDetailScreen(task: task));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // Floating Action Button Row
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Floating Action Button for Delete
          FloatingActionButton(
            onPressed: () {
              // Delete the selected tasks and reset selected task list
              for (int i = taskController.tasks.length - 1; i >= 0; i--) {
                if (_selectedTasks[i]) {
                  taskController.deleteTask(i); // Delete task by index
                }
              }
              // Reset the selection and Select All checkbox
              setState(() {
                _selectedTasks.value = List<bool>.generate(taskController.tasks.length, (_) => false);
                _selectAll.value = false;
              });
            },
            backgroundColor: Colors.white,  // Set color to differentiate the button
            child: Icon(Icons.delete,color: Colors.red),     // Icon for delete
          ),

          // Floating Action Button for Add Task
          SizedBox(width: 10),  // To give some space between buttons
          FloatingActionButton(
            onPressed: () => Get.to(TaskFormScreen()),
            backgroundColor: Colors.white,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
*/


// 17 jan edited

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';
import '../models/task.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  final TaskController taskController = Get.put(TaskController());

  // List to store the selected tasks for deletion
  RxList<bool> _selectedTasks = RxList<bool>();

  // Flag to toggle "Select All"
  RxBool _selectAll = false.obs;

  // Tab controller for handling tabs
  late TabController _tabController;

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 2 tabs
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Filter tasks based on the tab index
  List<Task> _getFilteredTasks() {
    if (_selectedTabIndex == 0) {
      // Pending tasks: Not completed
      return taskController.tasks.where((task) => !task.isCompleted).toList();
    } else {
      // Completed tasks: Completed tasks only
      return taskController.tasks.where((task) => task.isCompleted).toList();
    }
  }

  // Group tasks by priority for Pending tasks
  List<Task> _getPriorityFilteredTasks(List<Task> tasks) {
    return [
      ...tasks.where((task) => task.priority == 'High').toList(),
      ...tasks.where((task) => task.priority == 'Medium').toList(),
      ...tasks.where((task) => task.priority == 'Low').toList(),
    ];
  }

  // Update the selectedTasks list whenever the task list is updated
  void _syncSelectedTasks() {
    _selectedTasks.value = List<bool>.generate(taskController.tasks.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending Tasks'),
            Tab(text: 'Completed Tasks'),
          ],
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
        ),
      ),
      body: Column(
        children: [
          // Row containing Select All text and checkbox
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text for "Select All"
                Text('Select All'),

                // Checkbox for "Select All"
                Obx(() {
                  return Checkbox(
                    value: _selectAll.value,
                    onChanged: (value) {
                      setState(() {
                        _selectAll.value = value!;
                        // Sync selected tasks with Select All checkbox
                        _selectedTasks.value = List<bool>.generate(
                            taskController.tasks.length, (_) => value);
                      });
                    },
                  );
                }),
              ],
            ),
          ),

          // List of tasks with checkboxes
          Expanded(
            child: Obx(() {
              // Ensure the selectedTasks list matches the tasks list length
              if (_selectedTasks.length != taskController.tasks.length) {
                _syncSelectedTasks();
              }

              var filteredTasks = _getFilteredTasks();

              if (_selectedTabIndex == 0) {
                // If it's the Pending tab, group by priority
                filteredTasks = _getPriorityFilteredTasks(filteredTasks);
              }

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  Color flagColor;
                  Icon flagIcon;

                  // Set flag icon color based on priority
                  switch (task.priority) {
                    case 'Medium':
                      flagColor = Colors.orange;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                      break;
                    case 'Low':
                      flagColor = Colors.yellow;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                      break;
                    default:
                      flagColor = Colors.red;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                  }

                  // If task is completed, change flag color to green
                  if (task.isCompleted) {
                    flagColor = Colors.green;
                    flagIcon = Icon(Icons.flag, color: flagColor);
                  }

                  // Format due date if available
                  String dueDateText = task.dueDate != null
                      ? 'Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}'
                      : 'No Due Date';

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Text(task.title), // Use task.title, not task.name
                      subtitle: Text(dueDateText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          flagIcon,
                          // Checkbox for selection
                          Checkbox(
                            value: _selectedTasks[index],
                            onChanged: (value) {
                              // Update selection
                              setState(() {
                                _selectedTasks[index] = value!;
                                _selectAll.value = _selectedTasks.every((selected) => selected);
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to task detail page
                        Get.to(TaskDetailScreen(task: task));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Floating Action Button for Delete
          FloatingActionButton(
            onPressed: () {
              // Delete the selected tasks and reset selected task list
              for (int i = taskController.tasks.length - 1; i >= 0; i--) {
                if (_selectedTasks[i]) {
                  taskController.deleteTask(i); // Delete task by index
                }
              }
              // Reset the selection and Select All checkbox
              setState(() {
                _selectedTasks.value = List<bool>.generate(taskController.tasks.length, (_) => false);
                _selectAll.value = false;
              });
            },
            backgroundColor: Colors.white, // Set color to differentiate the button
            child: Icon(Icons.delete, color: Colors.red), // Icon for delete
          ),

          // Floating Action Button for Add Task
          SizedBox(width: 10), // To give some space between buttons
          FloatingActionButton(
            onPressed: () => Get.to(TaskFormScreen()),
            backgroundColor: Colors.white,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';

import '../main.dart';
import '../models/task.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  final TaskController taskController = Get.put(TaskController());
  final ThemeController themeController = Get.put(ThemeController());

  RxList<bool> _selectedTasks = RxList<bool>();
  RxBool _selectAll = false.obs;
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> _getFilteredTasks() {
    if (_selectedTabIndex == 0) {
      return taskController.tasks.where((task) => !task.isCompleted).toList();
    } else {
      return taskController.tasks.where((task) => task.isCompleted).toList();
    }
  }

  List<Task> _getPriorityFilteredTasks(List<Task> tasks) {
    return [
      ...tasks.where((task) => task.priority == 'High').toList(),
      ...tasks.where((task) => task.priority == 'Medium').toList(),
      ...tasks.where((task) => task.priority == 'Low').toList(),
    ];
  }

  void _syncSelectedTasks() {
    _selectedTasks.value = List<bool>.generate(taskController.tasks.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlue[300],
        actions: [
          IconButton(
            icon: Icon(
              themeController.isDarkMode.value
                  ? Icons.nights_stay // Filled icon for dark mode
                  : Icons.wb_sunny_outlined, // Unfilled icon for light mode
            ),
            onPressed: () {
              themeController.toggleTheme(); // Toggle theme on button press
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending Tasks'),
            Tab(text: 'Completed Tasks'),
          ],
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Select All'),
                Obx(() {
                  return Checkbox(
                    value: _selectAll.value,
                    onChanged: (value) {
                      setState(() {
                        _selectAll.value = value!;
                        _selectedTasks.value = List<bool>.generate(
                            taskController.tasks.length, (_) => value);
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_selectedTasks.length != taskController.tasks.length) {
                _syncSelectedTasks();
              }

              var filteredTasks = _getFilteredTasks();

              if (_selectedTabIndex == 0) {
                filteredTasks = _getPriorityFilteredTasks(filteredTasks);
              }

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  Color flagColor;
                  Icon flagIcon;

                  switch (task.priority) {
                    case 'Medium':
                      flagColor = Colors.orange;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                      break;
                    case 'Low':
                      flagColor = Colors.yellow;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                      break;
                    default:
                      flagColor = Colors.red;
                      flagIcon = Icon(Icons.flag, color: flagColor);
                  }

                  if (task.isCompleted) {
                    flagColor = Colors.green;
                    flagIcon = Icon(Icons.flag, color: flagColor);
                  }

                  String dueDateText = task.dueDate != null
                      ? 'Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}'
                      : 'No Due Date';

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Text(task.title),
                      subtitle: Text(dueDateText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          flagIcon,
                          Checkbox(
                            value: _selectedTasks[index],
                            onChanged: (value) {
                              setState(() {
                                _selectedTasks[index] = value!;
                                _selectAll.value = _selectedTasks.every((selected) => selected);
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Get.to(TaskDetailScreen(task: task));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              for (int i = taskController.tasks.length - 1; i >= 0; i--) {
                if (_selectedTasks[i]) {
                  taskController.deleteTask(i);
                }
              }
              setState(() {
                _selectedTasks.value = List<bool>.generate(taskController.tasks.length, (_) => false);
                _selectAll.value = false;
              });
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.delete, color: Colors.red),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => Get.to(TaskFormScreen()),
            backgroundColor: Colors.white,
            child: Icon(Icons.add,color: Colors.deepPurpleAccent,),
          ),
        ],
      ),
    );
  }
}

