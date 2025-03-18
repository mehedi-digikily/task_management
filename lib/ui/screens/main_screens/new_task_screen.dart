import 'package:flutter/material.dart';

import '../../widgets/summary_card.dart';
import '../../widgets/task_card.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummarySection(),
            ListView.separated(
              primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) => TaskCard(taskStatus: TaskStatus.sNew, taskName: 'New',),
                separatorBuilder: (context, index) => SizedBox(height: 8,),
                itemCount: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SummaryCard(
              tittle: 'New',
              count: 12,
            ),
            SummaryCard(
              count: 23,
              tittle: 'Progress',
            ),
            SummaryCard(
              count: 3,
              tittle: 'Completed',
            ),
            SummaryCard(
              tittle: 'Cancelled',
              count: 25,
            ),
          ],
        ),
      ),
    );
  }
}
