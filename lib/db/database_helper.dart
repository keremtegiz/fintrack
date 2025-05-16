import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as model;
import '../models/budget.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fintrack.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // İşlem tablosu oluştur
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        date INTEGER NOT NULL,
        currency TEXT NOT NULL
      )
    ''');

    // Bütçe tablosu oluştur
    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        budget_limit REAL NOT NULL,
        spent REAL NOT NULL,
        startDate INTEGER NOT NULL,
        endDate INTEGER NOT NULL
      )
    ''');
  }

  // İşlem CRUD işlemleri
  Future<int> insertTransaction(model.Transaction transaction) async {
    try {
      print('Veritabanına işlem ekleniyor...');
      Database db = await database;
      print('Veritabanı bağlantısı başarılı');
      final result = await db.insert(
        'transactions',
        {
          'id': transaction.id,
          'title': transaction.title,
          'amount': transaction.amount,
          'category': transaction.category,
          'type': transaction.type,
          'date': transaction.date.millisecondsSinceEpoch,
          'currency': transaction.currency,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('İşlem başarıyla eklendi. ID: $result');
      return result;
    } catch (e) {
      print('Veritabanı hatası: $e');
      rethrow;
    }
  }

  Future<List<model.Transaction>> getTransactions() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return model.Transaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        type: maps[i]['type'],
        date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
        currency: maps[i]['currency'],
      );
    });
  }

  Future<int> deleteTransaction(String id) async {
    Database db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Bütçe CRUD işlemleri
  Future<int> insertBudget(Budget budget) async {
    Database db = await database;
    return await db.insert(
      'budgets',
      {
        'id': budget.id,
        'category': budget.category,
        'budget_limit': budget.limit,
        'spent': budget.spent,
        'startDate': budget.startDate.millisecondsSinceEpoch,
        'endDate': budget.endDate.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getBudgets() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return List.generate(maps.length, (i) {
      return Budget(
        id: maps[i]['id'],
        category: maps[i]['category'],
        limit: maps[i]['budget_limit'],
        spent: maps[i]['spent'],
        startDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['startDate']),
        endDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['endDate']),
      );
    });
  }

  Future<int> deleteBudget(String id) async {
    Database db = await database;
    return await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateBudgetSpent(String category, double spent) async {
    Database db = await database;
    return await db.update(
      'budgets',
      {'spent': spent},
      where: 'category = ?',
      whereArgs: [category],
    );
  }
}
