
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/task.dart';
import '../controller/task_controller.dart';  // Assuming you have a TaskController

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task task;
  bool isEditing = false; // To toggle between edit and view modes
  final TaskController taskController = Get.find(); // Get the existing instance of TaskController

  // Controllers for form fields
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final ThemeController themeController = Get.put(ThemeController());
  String? _priority;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _dueDate = task.dueDate;
    _priority = task.priority;
    if (_dueDate != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(_dueDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the flag icon color based on task's priority
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

    // If the task is completed, change the flag icon color to green
    if (task.isCompleted) {
      flagColor = Colors.green;
      flagIcon = Icon(Icons.flag, color: flagColor);
    }

    return Scaffold(
      appBar: AppBar(

        title: Text('Task Details', style: TextStyle(color: Colors.white),),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Added SingleChildScrollView to handle overflow
          child: Card(
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Icon and Title
                  Row(
                    children: [
                      Icon(Icons.task_alt, size: 40, color: flagColor),
                      SizedBox(width: 10),
                      Expanded(
                        child: isEditing
                            ? TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: 'Task Title'),
                        )
                            : Text(
                          'Task Name: ${task.title}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Editable Task Description when in Edit Mode
                  isEditing
                      ? TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Task Description'),
                    maxLines: 3,
                  )
                      : Text('Description: ${task.description}'),
                  SizedBox(height: 10),

                  // Editable Due Date when in Edit Mode
                  isEditing
                      ? TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Due Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _dueDate) {
                        setState(() {
                          _dueDate = pickedDate;
                          _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  )
                      : Text('Due Date: ${task.dueDate != null ? DateFormat('yyyy-MM-dd').format(task.dueDate!) : "Not set"}'),
                  SizedBox(height: 10),

                  // Editable Priority Dropdown when in Edit Mode
                  isEditing
                      ? DropdownButtonFormField<String>(
                    value: _priority,
                    decoration: InputDecoration(labelText: 'Priority'),
                    onChanged: (value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                    items: ['High', 'Medium', 'Low']
                        .map((e) => DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                  )
                      : Row(
                    children: [
                      flagIcon,
                      SizedBox(width: 10),
                      Text('Priority: ${task.priority}'),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Radio buttons for Task Completion Status
                  if (isEditing)
                    Column(
                      children: [
                        RadioListTile<bool>(
                          title: Text('Task Completed'),
                          value: true,
                          groupValue: task.isCompleted,
                          onChanged: (value) {
                            setState(() {
                              task.isCompleted = value!;
                            });
                          },
                        ),
                        RadioListTile<bool>(
                          title: Text('Task Not Completed'),
                          value: false,
                          groupValue: task.isCompleted,
                          onChanged: (value) {
                            setState(() {
                              task.isCompleted = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 20),

                  // Show Edit/Save Button based on mode
                  isEditing
                      ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false; // Save and exit editing mode
                      });

                      // Update task properties
                      task.title = _titleController.text;
                      task.description = _descriptionController.text;
                      task.dueDate = _dueDate;
                      task.priority = _priority ?? 'High';

                      // Update task in the TaskController
                      taskController.updateTask(task);

                      // Optionally, you can also pop the screen after saving
                      Get.back();
                    },
                    child: Text('Save Changes'),
                  )
                      : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true; // Enable editing mode
                      });
                    },
                    child: Text('Edit Task'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


