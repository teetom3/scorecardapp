class ScoreCardModel {
  int? id;
  String name;
  List<int> pars; // Liste des pars pour chaque trou (18 trous).

  ScoreCardModel({
    this.id,
    required this.name,
    required this.pars,
  });

  // Méthode copyWith pour créer une copie de ScoreCardModel avec des modifications
  ScoreCardModel copyWith({
    int? id,
    String? name,
    List<int>? pars,
  }) {
    return ScoreCardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      pars: pars ?? this.pars,
    );
  }

  // Conversion de ScoreCardModel en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pars': pars.join(','), // Stocke la liste sous forme de chaîne.
    };
  }

  // Création de ScoreCardModel à partir d'un Map (SQLite)
  static ScoreCardModel fromMap(Map<String, dynamic> map) {
    return ScoreCardModel(
      id: map['id'],
      name: map['name'],
      pars:
          (map['pars'] as String).split(',').map((e) => int.parse(e)).toList(),
    );
  }
}
