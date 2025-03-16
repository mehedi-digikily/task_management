import 'package:flutter/material.dart';
import 'package:task_managemnt/ui/screens/main_screens/cancel_task_screen.dart';
import 'package:task_managemnt/ui/screens/main_screens/complate_task_screen.dart';
import 'package:task_managemnt/ui/screens/main_screens/progress_task_screen.dart';

import 'add_new_task.dart';
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
      appBar: _buildAppBar(),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.green,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Image.network(
                'https://scontent.fdac24-2.fna.fbcdn.net/v/t39.30808-6/480590485_2746937219028780_7046687641455399451_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeHbYJuAl5sy_WJDKH0X5uOzhsu7AQ_CMwOGy7sBD8IzA58g4dT2NjuGmaX-r8lE7ln0ie7lfXuUfD31sq4VdlYD&_nc_ohc=4zJ2Ie5CxVUQ7kNvgEdJNt4&_nc_oc=Adi3AVTIx0Pc3pErhTi9SykPAV43HIsNa2ZEllazGEKaNq1RtaoVRG0caHEfY3RuoR4&_nc_zt=23&_nc_ht=scontent.fdac24-2.fna&_nc_gid=SuDLj-aw5CXBB0-IqY6r7w&oh=00_AYHIRIV0fMuS6FM71nFQxR6tQu2HyjNlFBFeIK_j6S3oJA&oe=67DD1BDE',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            children: [
              Text(
                'Mehedi Hasan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              Text(
                'info.itsmehedi@gmail.com',
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Icon(Icons.login_outlined),
          )
        ],
      ),
    );
  }

}
