import 'package:flutter/material.dart';

import '../../widgets/summary_card.dart';
import '../../widgets/task_card.dart';

class ProgressTaskScreen extends StatelessWidget {
  const ProgressTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) => TaskCard(taskStatus: TaskStatus.progress, taskName: 'Progress',
            
          ),
          separatorBuilder: (context, index) => SizedBox(height: 8,),
          itemCount: 6,
      )
      ,
    );
  }

}
