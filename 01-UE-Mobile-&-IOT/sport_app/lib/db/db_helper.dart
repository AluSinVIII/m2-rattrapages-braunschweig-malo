import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/seance.dart'; // Assure-toi que le chemin est correct

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'seances.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE seances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        titre TEXT,
        duree INTEGER,
        distance REAL,
        difficulte INTEGER,
        commentaire TEXT
      )
    ''');
  }

  Future<void> insertSeance(Seance seance) async {
    final db = await database;
    await db.insert(
      'seances',
      seance.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSeance(Seance seance) async {
    final db = await database;
    await db.update(
      'seances',
      seance.toMap(),
      where: 'id = ?',
      whereArgs: [seance.id],
    );
  }

  Future<void> deleteSeance(int id) async {
    final db = await database;
    await db.delete(
      'seances',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Seance>> getSeances() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('seances');
    return List.generate(maps.length, (i) {
      return Seance(
        id: maps[i]['id'],
        date: DateTime.parse(maps[i]['date']),
        titre: maps[i]['titre'],
        duree: maps[i]['duree'],
        distance: maps[i]['distance'],
        difficulte: maps[i]['difficulte'],
        commentaire: maps[i]['commentaire'],
      );
    });
  }

  Future<Seance?> getSeance(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'seances',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Seance(
        id: maps[0]['id'],
        date: DateTime.parse(maps[0]['date']),
        titre: maps[0]['titre'],
        duree: maps[0]['duree'],
        distance: maps[0]['distance'],
        difficulte: maps[0]['difficulte'],
        commentaire: maps[0]['commentaire'],
      );
    }
    return null;
  }
}
