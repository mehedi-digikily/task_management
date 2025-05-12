import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_managemnt/live_score_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final List<LiveScoreModel> _liveScoreList = [];

  @override
  void initState() {
    super.initState();
    _getLiveScore();
  }

  Future<void> _getLiveScore() async {
    QuerySnapshot snapshot = await db.collection('football').get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      LiveScoreModel liveScoreModel =
          LiveScoreModel.formJson(doc.id, doc.data() as Map<String, dynamic>);
      _liveScoreList.add(liveScoreModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Score App'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
          stream: db.collection('football').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData == false) {
              return Center(
                child: SizedBox(),
              );
            } else if (snapshot.hasData) {
              _liveScoreList.clear();
              for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                LiveScoreModel liveScoreModel = LiveScoreModel.formJson(
                    doc.id, doc.data() as Map<String, dynamic>);
                _liveScoreList.add(liveScoreModel);
              }
            }

            return ListView.builder(
              itemCount: _liveScoreList.length,
              itemBuilder: (context, index) {
                LiveScoreModel liveScore = _liveScoreList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _liveScoreList[index].isRunning
                        ? Colors.green
                        : Colors.grey,
                    radius: 8,
                  ),
                  title: Text(
                    _liveScoreList[index].tittle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(liveScore.team1),
                      Text(liveScore.team2),
                      Text('Winner Team: ${liveScore.winner}'),
                    ],
                  ),
                  trailing: Text(
                    '${liveScore.team1Score} : ${liveScore.team2Score}',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LiveScoreModel liveScoreModel = LiveScoreModel(
              tittle: 'England VS SriLanka',
              team1: 'England',
              team2: 'SriLanka',
              team1Score: 2,
              team2Score: 2,
              isRunning: true,
              winner: '');
          db.collection('football').doc(liveScoreModel.tittle).set(liveScoreModel.toJson());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
