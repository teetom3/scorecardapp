class PlayedGame {
  int? id;
  int modelId; // Référence à l'ID du modèle utilisé
  String modelName; // Nom du modèle pour affichage
  List<int> pars; // Liste des pars pour chaque trou
  List<int> scores; // Scores des trous
  List<bool> fairways; // Fairways en régulation
  List<bool> greens; // Greens en régulation
  List<int> putts; // Nombre de putts par trou

  PlayedGame({
    this.id,
    required this.modelId,
    required this.modelName,
    required this.pars,
    required this.scores,
    required this.fairways,
    required this.greens,
    required this.putts,
  });

  // Méthode copyWith pour créer une copie de PlayedGame avec des modifications
  PlayedGame copyWith({
    int? id,
    int? modelId,
    String? modelName,
    List<int>? pars,
    List<int>? scores,
    List<bool>? fairways,
    List<bool>? greens,
    List<int>? putts,
  }) {
    return PlayedGame(
      id: id ?? this.id,
      modelId: modelId ?? this.modelId,
      modelName: modelName ?? this.modelName,
      pars: pars ?? this.pars,
      scores: scores ?? this.scores,
      fairways: fairways ?? this.fairways,
      greens: greens ?? this.greens,
      putts: putts ?? this.putts,
    );
  }

  // Conversion de PlayedGame en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modelId': modelId,
      'modelName': modelName,
      'pars': pars.join(','),
      'scores': scores.join(','),
      'fairways': fairways.map((e) => e ? 1 : 0).join(','),
      'greens': greens.map((e) => e ? 1 : 0).join(','),
      'putts': putts.join(','),
    };
  }

  // Création de PlayedGame à partir d'un Map (SQLite)
  static PlayedGame fromMap(Map<String, dynamic> map) {
    return PlayedGame(
      id: map['id'],
      modelId: map['modelId'],
      modelName: map['modelName'],
      pars:
          (map['pars'] as String).split(',').map((e) => int.parse(e)).toList(),
      scores: (map['scores'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
      fairways:
          (map['fairways'] as String).split(',').map((e) => e == '1').toList(),
      greens:
          (map['greens'] as String).split(',').map((e) => e == '1').toList(),
      putts:
          (map['putts'] as String).split(',').map((e) => int.parse(e)).toList(),
    );
  }

  // Méthode pour calculer les statistiques d'une partie
  Map<String, double> calculateStats() {
    int totalFairways = fairways.where((f) => f).length;
    int totalGreens = greens.where((g) => g).length;
    int totalPutts = putts.reduce((a, b) => a + b);
    int totalHoles = scores.length;

    return {
      'fairwayPercentage':
          totalHoles > 0 ? (totalFairways / totalHoles) * 100 : 0,
      'greenPercentage': totalHoles > 0 ? (totalGreens / totalHoles) * 100 : 0,
      'averagePutts': totalHoles > 0 ? totalPutts / totalHoles : 0,
    };
  }
}
