import 'package:flutter/material.dart';
import '../models/scorecard_model.dart';
import '../models/played_game.dart';
import '../services/database_service.dart';

class PlayGameScreen extends StatefulWidget {
  final ScoreCardModel model;

  PlayGameScreen({required this.model});

  @override
  _PlayGameScreenState createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  List<int> _scores = List<int>.filled(18, 0);
  List<bool> _fairways = List<bool>.filled(18, false);
  List<bool> _greens = List<bool>.filled(18, false);
  List<int> _putts = List<int>.filled(18, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Partie (${widget.model.name})'),
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
                        title: Text('Par: ${widget.model.pars[index]}'),
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
                final newGame = PlayedGame(
                  modelId: widget.model.id!,
                  modelName: widget.model.name,
                  pars: widget.model.pars,
                  scores: _scores,
                  fairways: _fairways,
                  greens: _greens,
                  putts: _putts,
                );

                await DatabaseService().insertPlayedGame(newGame);

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
