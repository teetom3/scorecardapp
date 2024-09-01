import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/scorecard_model.dart';
import 'scorecard_form_screen.dart';
import 'play_game_screen.dart';

class ScoreCardListScreen extends StatefulWidget {
  @override
  _ScoreCardListScreenState createState() => _ScoreCardListScreenState();
}

class _ScoreCardListScreenState extends State<ScoreCardListScreen> {
  late Future<List<ScoreCardModel>> _scoreCardModelList;

  @override
  void initState() {
    super.initState();
    _refreshScoreCardModelList();
  }

  void _refreshScoreCardModelList() {
    setState(() {
      _scoreCardModelList = DatabaseService().getScoreCardModels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modèles de Cartes de Score'),
      ),
      body: FutureBuilder<List<ScoreCardModel>>(
        future: _scoreCardModelList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final models = snapshot.data!;

            return ListView.builder(
              itemCount: models.length,
              itemBuilder: (context, index) {
                final model = models[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(model.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Parcours de Golf'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        DatabaseService().deleteScoreCardModel(model.id!);
                        _refreshScoreCardModelList();
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayGameScreen(model: model),
                        ),
                      ).then((_) {
                        _refreshScoreCardModelList();
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text('Aucun modèle de carte de score trouvé.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ScoreCardFormScreen()),
          );
          if (result == true) {
            _refreshScoreCardModelList();
          }
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }
}
