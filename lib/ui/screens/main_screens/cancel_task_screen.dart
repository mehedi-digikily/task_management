import 'package:flutter/material.dart';

import '../../widgets/summary_card.dart';
import '../../widgets/task_card.dart';

class CancelTaskScreen extends StatelessWidget {
  const CancelTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) => TaskCard(taskStatus: TaskStatus.cancelled, taskName: 'Cancel',
          ),
          separatorBuilder: (context, index) => SizedBox(height: 8,),
          itemCount: 6,
      )
      ,
    );
  }

}
