import 'package:flutter/material.dart';
import '../models/played_game.dart';
import '../services/database_service.dart';

class ScoreCardPlayScreen extends StatefulWidget {
  final PlayedGame? playedGame; // Modèle pour les parties jouées

  ScoreCardPlayScreen({required this.playedGame});

  @override
  _ScoreCardPlayScreenState createState() => _ScoreCardPlayScreenState();
}

class _ScoreCardPlayScreenState extends State<ScoreCardPlayScreen> {
  List<int> _scores = List<int>.filled(18, 0);
  List<bool> _fairways = List<bool>.filled(18, false);
  List<bool> _greens = List<bool>.filled(18, false);
  List<int> _putts = List<int>.filled(18, 0);

  @override
  void initState() {
    super.initState();
    if (widget.playedGame != null) {
      _scores = List<int>.from(widget.playedGame!.scores);
      _fairways = List<bool>.from(widget.playedGame!.fairways);
      _greens = List<bool>.from(widget.playedGame!.greens);
      _putts = List<int>.from(widget.playedGame!.putts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Jouer Partie (${widget.playedGame?.modelName ?? 'Nouvelle Partie'})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 18,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Text('Trou ${index + 1}'),
                        title: Text(
                            'Par: ${widget.playedGame?.pars[index] ?? ''}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Score'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _scores[index] = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text('Fairway en Régulation'),
                              value: _fairways[index],
                              onChanged: (value) {
                                setState(() {
                                  _fairways[index] = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text('Green en Régulation'),
                              value: _greens[index],
                              onChanged: (value) {
                                setState(() {
                                  _greens[index] = value!;
                                });
                              },
                            ),
                            TextField(
                              decoration:
                                  InputDecoration(labelText: 'Nombre de Putts'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _putts[index] = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedPlayedGame = widget.playedGame?.copyWith(
                  scores: _scores,
                  fairways: _fairways,
                  greens: _greens,
                  putts: _putts,
                );

                if (updatedPlayedGame != null) {
                  await DatabaseService().insertPlayedGame(updatedPlayedGame);
                }

                Navigator.pop(context, true);
              },
              child: Text('Enregistrer la Partie'),
            ),
          ],
        ),
      ),
    );
  }
}
