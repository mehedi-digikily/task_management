import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String tittle;
  final int count;
  const SummaryCard({
    super.key, required this.tittle, required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(tittle,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            Text('$count'),
          ],
        ),
      ),
    );
  }
}
