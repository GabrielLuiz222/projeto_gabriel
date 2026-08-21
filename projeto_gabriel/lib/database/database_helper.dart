import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/custo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'controle_gastos.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        valor REAL NOT NULL,
        categoria TEXT NOT NULL
      )
    ''');
  }


Future<int> inserirGasto(Custo custo) async {
  final db = await database;

  return await db.insert(
    'gastos',
    custo.toMap(),
  );
}

Future<List<Custo>> buscarGastos() async {
  final db = await database;

  final resultado = await db.query(
    'gastos',
    orderBy: 'id DESC',
  );

  return resultado.map((map) {
    return Custo.fromMap(map);
  }).toList();
}

Future<int> atualizarGasto(Custo custo) async {
  final db = await database;

  return await db.update(
    'gastos',
    custo.toMap(),
    where: 'id = ?',
    whereArgs: [custo.id],
  );
}

Future<int> deletarGasto(int id) async {
  final db = await database;

  return await db.delete(
    'gastos',
    where: 'id = ?',
    whereArgs: [id],
  );
}
}