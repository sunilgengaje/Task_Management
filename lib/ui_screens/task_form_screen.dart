
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/ui_screens/task_list_screen.dart';
import '../controller/task_controller.dart';
import '../main.dart';
import '../models/task.dart';
import '../validation_helper/validation_helper.dart';

class TaskFormScreen extends StatelessWidget {
  final TaskController taskController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final ThemeController themeController = Get.put(ThemeController());
  String _priority = 'High';
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Add Task', style: TextStyle(color: Colors.white),),
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
      body: SingleChildScrollView(  // Ensures the form can be scrolled if it overflows
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 5,  // Add shadow for the Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners for the card
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title (Name)
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Task Title'),
                      validator: (value) => ValidationHelper.validateRequiredField(value, 'Task title'),
                    ),
                    SizedBox(height: 16),

                    // Task Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Task Description'),
                      maxLines: 3,
                      validator: (value) => ValidationHelper.validateRequiredField(value, 'Task description'),
                    ),
                    SizedBox(height: 16),

                    // Due Date Picker
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Due Date'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),  // Disable past dates
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != _dueDate) {
                          _dueDate = pickedDate;
                          _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },

                      validator: (value) {
                        // Ensure the date is not in the past
                        return ValidationHelper.validateFutureDate(_dueDate);
                      },
                    ),
                    SizedBox(height: 16),

                    // Priority Dropdown
                    DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: InputDecoration(labelText: 'Priority'),
                      onChanged: (value) {
                        _priority = value!;
                      },
                      items: ['High', 'Medium', 'Low']
                          .map((e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                    ),
                    SizedBox(height: 20),

                    // Save Task Button

                    Align(
                      alignment: Alignment.bottomRight,
                      // Padding around the button
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Generate a unique id using the current timestamp
                              int taskId = DateTime.now().millisecondsSinceEpoch;

                              // Create Task object from the input data
                              Task task = Task(
                                id: taskId, // Assign the generated id
                                title: _titleController.text,
                                description: _descriptionController.text,
                                dueDate: _dueDate,
                                priority: _priority,
                              );

                              // Add task to the task controller
                              taskController.addTask(task);

                              // Show Snackbar to notify the user that the task was added
                              Get.snackbar(
                                'Task Added', // Title
                                'Your task has been added successfully!', // Message
                                snackPosition: SnackPosition.BOTTOM, // Display at the bottom
                                backgroundColor: Colors.green, // Background color of the Snackbar
                                colorText: Colors.white, // Text color
                                margin: EdgeInsets.all(10), // Margin around the Snackbar
                                borderRadius: 8, // Rounded corners
                                duration: Duration(seconds: 2), // Show the Snackbar for 2 seconds
                              );

                              // Wait for the Snackbar to finish before navigating back
                              Future.delayed(Duration(seconds: 2), () {
                                Get.to(TaskListScreen()); // Navigate back to Task List screen
                              });
                            }
                          },
                          child: Text('Save Task'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 50),  // Button width and height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                          ),
                        ),
/*ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Generate a unique id using the current timestamp
                              int taskId = DateTime.now().millisecondsSinceEpoch;

                              // Create Task object from the input data
                              Task task = Task(
                                id: taskId, // Assign the generated id
                                title: _titleController.text,
                                description: _descriptionController.text,
                                dueDate: _dueDate,
                                priority: _priority,
                              );

                              // Add task to the task controller
                              taskController.addTask(task);

                              // Navigate back after saving
                              Get.back();
                            }
                          },
                          child: Text('Save Task'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 50),  // Button width and height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                          ),
                        ),*/

                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
