import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../models/played_game.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<PlayedGame>> _playedGamesList;

  @override
  void initState() {
    super.initState();
    _refreshPlayedGamesList();
  }

  void _refreshPlayedGamesList() {
    setState(() {
      _playedGamesList = DatabaseService().getPlayedGames();
    });
  }

  // Calculer les statistiques moyennes pour toutes les parties jouées
  Map<String, double> _calculateAverageStats(List<PlayedGame> playedGames) {
    double totalFairways = 0.0;
    double totalGreens = 0.0;
    double totalPutts = 0.0;
    int totalHoles = 0;

    for (var game in playedGames) {
      final stats = game.calculateStats();

      // Utiliser le null-aware operator '??' pour fournir une valeur par défaut si null
      double fairwayPercentage = stats['fairwayPercentage'] ?? 0.0;
      double greenPercentage = stats['greenPercentage'] ?? 0.0;
      double averagePutts = stats['averagePutts'] ?? 0.0;
      int scoresLength = game.scores.length;

      totalFairways += (fairwayPercentage > 0
          ? (fairwayPercentage * scoresLength / 100)
          : 0.0);
      totalGreens +=
          (greenPercentage > 0 ? (greenPercentage * scoresLength / 100) : 0.0);
      totalPutts += averagePutts * scoresLength;
      totalHoles += scoresLength;
    }

    return {
      'averageFairways':
          totalHoles > 0 ? (totalFairways / totalHoles) * 100 : 0,
      'averageGreens': totalHoles > 0 ? (totalGreens / totalHoles) * 100 : 0,
      'averagePutts': totalHoles > 0 ? totalPutts / totalHoles : 0,
    };
  }

  // Supprimer une partie jouée
  void _deletePlayedGame(int id) async {
    await DatabaseService().deletePlayedGame(id);
    _refreshPlayedGamesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<PlayedGame>>(
        future: _playedGamesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final playedGames = snapshot.data!;
            final averageStats = _calculateAverageStats(playedGames);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Statistiques Moyennes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          'Fairways en Régulation: ${averageStats['averageFairways']?.toStringAsFixed(3)}%'),
                      Text(
                          'Greens en Régulation: ${averageStats['averageGreens']?.toStringAsFixed(3)}%'),
                      Text(
                          'Nombre moyen de Putts: ${averageStats['averagePutts']?.toStringAsFixed(3)}'),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: playedGames.length,
                    itemBuilder: (context, index) {
                      final game = playedGames[index];
                      final totalScore = game.scores.reduce((a, b) => a + b);

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: Icon(Icons.golf_course, color: Colors.teal),
                          title: Text(
                            game.modelName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Score Total: $totalScore'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deletePlayedGame(game.id!);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Aucune partie jouée trouvée.'));
          }
        },
      ),
    );
  }
}
