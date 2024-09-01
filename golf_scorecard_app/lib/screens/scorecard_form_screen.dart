import 'package:flutter/material.dart';
import '../models/scorecard_model.dart';
import '../services/database_service.dart';

class ScoreCardFormScreen extends StatefulWidget {
  final ScoreCardModel?
      model; // Modèle de carte de score, optionnel pour modification

  ScoreCardFormScreen({this.model});

  @override
  _ScoreCardFormScreenState createState() => _ScoreCardFormScreenState();
}

class _ScoreCardFormScreenState extends State<ScoreCardFormScreen> {
  final _nameController = TextEditingController();
  List<int> _pars =
      List<int>.filled(18, 4); // Par défaut, tous les trous sont des par 4.

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      // Si un modèle est fourni, nous remplissons les champs avec ses données.
      _nameController.text = widget.model!.name;
      _pars = List<int>.from(widget.model!.pars);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.model == null ? 'Créer un Modèle' : 'Modifier le Modèle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom du Modèle',
                prefixIcon: Icon(Icons.edit, color: Colors.teal),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 18,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text('Trou ${index + 1}'),
                    title: DropdownButton<int>(
                      value: _pars[index],
                      onChanged: (value) {
                        setState(() {
                          _pars[index] = value!;
                        });
                      },
                      items: [3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('Par $value'),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Veuillez entrer un nom pour le modèle')),
                  );
                  return;
                }

                final newModel = ScoreCardModel(
                  id: widget.model?.id,
                  name: _nameController.text,
                  pars: _pars,
                );

                if (widget.model == null) {
                  // Nouveau modèle
                  await DatabaseService().insertScoreCardModel(newModel);
                } else {
                  // Modifier le modèle existant
                  await DatabaseService().insertScoreCardModel(
                      newModel); // Utiliser la même méthode d'insertion
                }

                Navigator.pop(context,
                    true); // Retourne à l'écran de liste après ajout ou modification.
              },
              child: Text(widget.model == null
                  ? 'Enregistrer le Modèle'
                  : 'Modifier le Modèle'),
            ),
          ],
        ),
      ),
    );
  }
}
