import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/lead.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'leads.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leads (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        source TEXT,
        notes TEXT,
        status TEXT,
        createdAt TEXT
      );
    ''');
  }

  Future<void> insertLead(Lead lead) async {
    final database = await db;
    await database.insert('leads', lead.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Fetch all leads (used for export or full listing)
  Future<List<Lead>> fetchAll() async {
    final database = await db;
    final res = await database.query('leads', orderBy: 'createdAt DESC');
    return res.map((e) => Lead.fromMap(e)).toList();
  }

  /// Fetch a page of leads with limit & offset for pagination
  Future<List<Lead>> fetchPage({required int limit, required int offset}) async {
    final database = await db;
    final res = await database.rawQuery(
      'SELECT * FROM leads ORDER BY createdAt DESC LIMIT ? OFFSET ?',
      [limit, offset],
    );
    return res.map((e) => Lead.fromMap(e)).toList();
  }

  Future<void> deleteLead(String id) async {
    final database = await db;
    await database.delete('leads', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateLead(Lead lead) async {
    final database = await db;
    await database.update('leads', lead.toMap(), where: 'id = ?', whereArgs: [lead.id]);
  }
}
