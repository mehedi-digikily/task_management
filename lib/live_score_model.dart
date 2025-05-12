class LiveScoreModel {
  final String tittle;
  final String team1;
  final String team2;
  final int team1Score;
  final int team2Score;
  final bool isRunning;
  final String winner;

  LiveScoreModel({
    required this.tittle,
    required this.team1,
    required this.team2,
    required this.team1Score,
    required this.team2Score,
    required this.isRunning,
    required this.winner,
  });

  factory LiveScoreModel.formJson(String docId, Map<String, dynamic> jsonBody){
    return LiveScoreModel(
        tittle: docId,
        team1: jsonBody['team1'],
        team2: jsonBody['team2'],
        team1Score: jsonBody['team1_score'],
        team2Score: jsonBody['team2_score'],
        isRunning: jsonBody['isRunning'],
        winner: jsonBody['winner_team']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'team1' : team1,
      'team2' : team2,
      'team1_score' : team1Score,
      'team2_score' : team2Score,
      'isRunning' : isRunning,
      'winner_team' : team1,
    };
}
}