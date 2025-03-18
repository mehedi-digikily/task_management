import 'package:flutter/material.dart';

import '../../widgets/summary_card.dart';
import '../../widgets/task_card.dart';

class CompleteTaskScreen extends StatelessWidget {
  const CompleteTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(

          itemBuilder: (context, index) => TaskCard(taskStatus: TaskStatus.completed, taskName: 'Completed', ),
          separatorBuilder: (context, index) => SizedBox(height: 8,),
          itemCount: 6,
      )
      ,
    );
  }

}
