import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String status;
  Color? color;
    TaskCard({
    super.key, required this.status, this.color,
  });

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
            Text('Tittle',style: TextStyle(fontWeight: FontWeight.w600),),
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
                    status,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: color ?? Colors.blueAccent[400],
                ),
                const Spacer(),
                IconButton(onPressed: (){}, icon: Icon(Icons.edit),),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
