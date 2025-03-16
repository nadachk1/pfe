// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../JSON/users.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  final String databaseName = "auth.db";

  // Définition de la table users
  final String userTable = '''
    CREATE TABLE IF NOT EXISTS users (
      usrId INTEGER PRIMARY KEY AUTOINCREMENT,
      fullName TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      usrName TEXT UNIQUE NOT NULL,
      usrPassword TEXT NOT NULL,
      allergies TEXT
    )
  ''';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialisation de la base de données
  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(userTable);
      },
    );
  }

  // Fonction d'authentification sécurisée
  Future<bool> authenticate(String usrName, String usrPassword, {required String email}) async {
    final Database db = await database;
    var result = await db.query(
      "users",
      where: "usrName = ? AND usrPassword = ?",
      whereArgs: [usrName, usrPassword],
    );
    return result.isNotEmpty;
  }

  // Inscription d'un utilisateur
  Future<int> createUser(Users usr) async {
    final Database db = await database;
    return await db.insert("users", usr.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Récupérer un utilisateur par son username
  Future<Users?> getUser(String usrName) async {
    final Database db = await database;
    var res = await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  // Vérifier les tables existantes
  Future<void> checkTables() async {
    final Database db = await database;
    final List<Map<String, dynamic>> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print("Tables existantes : ${tables.map((t) => t['name']).toList()}");
  }
}
