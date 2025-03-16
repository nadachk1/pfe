import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE family_members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        relation TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE allergies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE user_allergies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        allergy_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (allergy_id) REFERENCES allergies (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE family_member_allergies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        allergy_id INTEGER NOT NULL,
        FOREIGN KEY (member_id) REFERENCES family_members (id) ON DELETE CASCADE,
        FOREIGN KEY (allergy_id) REFERENCES allergies (id) ON DELETE CASCADE
      )
    ''');
  }

  // Ajouter un utilisateur
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  // Ajouter un membre de famille
  Future<int> insertFamilyMember(Map<String, dynamic> member) async {
    final db = await database;
    return await db.insert('family_members', member);
  }

  // Ajouter une allergie
  Future<int> insertAllergy(Map<String, dynamic> allergy) async {
    final db = await database;
    return await db.insert('allergies', allergy, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Associer une allergie à un utilisateur
  Future<int> insertUserAllergy(Map<String, dynamic> userAllergy) async {
    final db = await database;
    return await db.insert('user_allergies', userAllergy);
  }

  // Associer une allergie à un membre de famille
  Future<int> insertFamilyMemberAllergy(Map<String, dynamic> memberAllergy) async {
    final db = await database;
    return await db.insert('family_member_allergies', memberAllergy);
  }

  // Récupérer tous les utilisateurs
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Récupérer les membres de famille d'un utilisateur
  Future<List<Map<String, dynamic>>> getFamilyMembers(int userId) async {
    final db = await database;
    return await db.query('family_members', where: 'user_id = ?', whereArgs: [userId]);
  }

  // Récupérer les allergies d'un utilisateur
  Future<List<Map<String, dynamic>>> getUserAllergies(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT a.type FROM allergies a
      INNER JOIN user_allergies ua ON a.id = ua.allergy_id
      WHERE ua.user_id = ?
    ''', [userId]);
  }

  // Récupérer les allergies d'un membre de famille
  Future<List<Map<String, dynamic>>> getFamilyMemberAllergies(int memberId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT a.type FROM allergies a
      INNER JOIN family_member_allergies fma ON a.id = fma.allergy_id
      WHERE fma.member_id = ?
    ''', [memberId]);
  }
  // Récupérer les allergies d'un produit pour un utilisateur et sa famille
  Future<List<String>> getAllergicMembers(int userId, Product product) async {
    List<String> allergies = (await getUserAllergies(userId)).cast<String>();
    List<String> ingredients = product.ingredients?.map((e) => e.text.toLowerCase()).toList() ?? [];

    List<String> affectedMembers = [];

    // Vérifier l'utilisateur lui-même
    for (String allergy in allergies) {
      for (String ingredient in ingredients) {
        if (ingredient.contains(allergy.toLowerCase())) {
          affectedMembers.add("Vous");
        }
      }
    }

    // Vérifier les membres de la famille
    List<Map<String, dynamic>> familyMembers = await getFamilyMembers(userId);

    for (var member in familyMembers) {
      List<String> memberAllergies = (await getFamilyMemberAllergies(member['id'])).cast<String>();

      for (String allergy in memberAllergies) {
        for (String ingredient in ingredients) {
          if (ingredient.contains(allergy.toLowerCase())) {
            affectedMembers.add(member['name']);
          }
        }
      }
    }

    return affectedMembers;
  }
}

class Product {
}
