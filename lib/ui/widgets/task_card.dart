import 'package:flutter/material.dart';

enum TaskStatus {
  sNew,
  progress,
  completed,
  cancelled
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskStatus, required this.taskName,
  });

  final TaskStatus taskStatus;
  final String taskName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tittle',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('Description'),
            Text('Date: 16/03/2025'),
            Row(
              children: [
                Chip(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  label: Text(
                    taskName,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor:_getStatusChipColor(),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Color _getStatusChipColor() {
    late Color color;
    switch (taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }
}
