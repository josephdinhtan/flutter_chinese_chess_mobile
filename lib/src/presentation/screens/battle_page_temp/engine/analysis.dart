class AnalysisItem {
  //
  final String move;
  final int score;
  final double winrate;

  String? name;

  AnalysisItem({
    required this.move,
    required this.score,
    required this.winrate,
  });

  @override
  String toString() =>
      '{move: ${name ?? move}, score: $score, winrate: $winrate}';
}

class AnalysisFetcher {
  //
  static List<AnalysisItem> fetch(String response, {limit = 5}) {
    //
    final segments = response.split('|');

    List<AnalysisItem> result = [];

    final regx = RegExp(r'move:(.{4}).+score:(\-?\d+).+winrate:(\d+.?\d*)');

    for (var segment in segments) {
      //
      final match = regx.firstMatch(segment);

      if (match == null) break;

      final move = match.group(1)!;
      final score = int.parse(match.group(2)!);
      final winrate = double.parse(match.group(3)!);

      result.add(AnalysisItem(move: move, score: score, winrate: winrate));

      if (result.length == limit) break;
    }

    return result;
  }
}
