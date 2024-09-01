import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scorecard_model.dart';
import '../models/played_game.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'golf_scorecards.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Créer la table pour les modèles de cartes de score
        await db.execute('''
          CREATE TABLE scorecard_models (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            pars TEXT
          )
        ''');

        // Créer la table pour les parties jouées, y compris la colonne 'pars'
        await db.execute('''
          CREATE TABLE played_games (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            modelId INTEGER,
            modelName TEXT,
            pars TEXT, -- Ajouter cette ligne pour la colonne 'pars'
            scores TEXT,
            fairways TEXT,
            greens TEXT,
            putts TEXT
          )
        ''');

        // Créer la table pour les utilisateurs
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // Méthodes pour gérer les modèles de cartes de score (ScoreCardModel)

  Future<void> insertScoreCardModel(ScoreCardModel model) async {
    final db = await database;
    await db.insert('scorecard_models', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ScoreCardModel>> getScoreCardModels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('scorecard_models');
    return List.generate(maps.length, (i) {
      return ScoreCardModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteScoreCardModel(int id) async {
    final db = await database;
    await db.delete('scorecard_models', where: 'id = ?', whereArgs: [id]);
  }

  // Méthodes pour gérer les parties jouées (PlayedGame)

  Future<void> insertPlayedGame(PlayedGame game) async {
    final db = await database;
    await db.insert('played_games', game.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PlayedGame>> getPlayedGames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('played_games');
    return List.generate(maps.length, (i) {
      return PlayedGame.fromMap(maps[i]);
    });
  }

  Future<void> deletePlayedGame(int id) async {
    final db = await database;
    await db.delete('played_games', where: 'id = ?', whereArgs: [id]);
  }

  // Méthodes pour gérer les utilisateurs (User)

  Future<void> registerUser(String username, String password) async {
    final db = await database;
    try {
      await db.insert('users', {'username': username, 'password': password});
    } catch (e) {
      throw Exception('Le nom d\'utilisateur existe déjà.');
    }
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  // Méthode pour supprimer la base de données (utilisée pour le développement)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'golf_scorecards.db');
    await deleteDatabase(path);
  }
}
