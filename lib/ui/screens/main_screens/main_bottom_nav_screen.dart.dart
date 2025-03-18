import 'package:flutter/material.dart';
import 'package:task_managemnt/ui/screens/main_screens/cancel_task_screen.dart';
import 'package:task_managemnt/ui/screens/main_screens/progress_task_screen.dart';

import '../../widgets/tm_app_bar.dart';
import 'add_new_task.dart';
import 'complate_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompleteTaskScreen(),
    CancelTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            _selectedIndex = index;
            setState(() {});
          },
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.new_label_outlined), label: 'New'),
            NavigationDestination(icon: Icon(Icons.padding), label: 'Progress'),
            NavigationDestination(
                icon: Icon(Icons.incomplete_circle), label: 'Complete'),
            NavigationDestination(icon: Icon(Icons.cancel), label: 'Cancel'),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewTask(),),);
        },
        child: Icon(Icons.add),
      ),
    );
  }


}

