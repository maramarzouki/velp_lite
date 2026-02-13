import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
    // return await openDatabase(
    //   path,
    //   version: 1, // ← Change to 2
    //   onCreate: _onCreate,
    //   // onUpgrade: _onUpgrade, // ← Add this
    // );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    )
  ''');

    // pets (owner_id references users(id))
    await db.execute('''
    CREATE TABLE pets(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      species TEXT,
      breed TEXT,
      birth_date TEXT,
      gender TEXT,
      weight REAL,
      color TEXT,
      chip_number TEXT,
      owner_id INTEGER NOT NULL,
      FOREIGN KEY (owner_id) REFERENCES users(id)
    )
  ''');

    // vets
    await db.execute('''
    CREATE TABLE vets(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT NOT NULL,
      specialty TEXT NOT NULL,
      clinic TEXT NOT NULL
    )
  ''');

    // rdvs (appointments). NOTE: vet_id nullable to allow text vet if needed
    await db.execute('''
    CREATE TABLE rdvs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      animal_id INTEGER NOT NULL,
      vet TEXT,
      date TEXT NOT NULL,
      is_confirmed INTEGER NOT NULL,
      vet_id INTEGER,
      FOREIGN KEY (animal_id) REFERENCES pets(id),
      FOREIGN KEY (vet_id) REFERENCES vets(id)
    )
  ''');

    // messages
    await db.execute('''
    CREATE TABLE messages(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sender_id INTEGER NOT NULL,
      sender_type TEXT NOT NULL,
      content TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      room_id INTEGER NOT NULL,
      content_type TEXT NOT NULL,
      FOREIGN KEY (room_id) REFERENCES chat_rooms(id)
    )
  ''');

    // chat_rooms
    await db.execute('''
    CREATE TABLE chat_rooms(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sender_id INTEGER NOT NULL,
      sender_type TEXT NOT NULL,
      receiver_id INTEGER NOT NULL,
      receiver_type TEXT NOT NULL,
      last_message_id INTEGER,
      is_seen INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      FOREIGN KEY (last_message_id) REFERENCES messages(id)
    )
  ''');
  
    await db.insert('vets', {
      'name': 'Dr. Emily Carter',
      'email': 'emily.carter@greenvalleyvet.com',
      'phone': '+15551234567',
      'specialty': 'Small Animal Surgery',
      'clinic': 'Green Valley Veterinary Clinic',
    });

    await db.insert('vets', {
      'name': 'Dr. Michael Thompson',
      'email': 'michael.thompson@citypetcare.com',
      'phone': '+15559876543',
      'specialty': 'Dermatology',
      'clinic': 'City Pet Care Center',
    });

    await db.insert('vets', {
      'name': 'Dr. Sophia Martinez',
      'email': 'sophia.martinez@happyhealthpets.com',
      'phone': '+15553456789',
      'specialty': 'Preventive Medicine',
      'clinic': 'Happy Health Pets Clinic',
    });

    await db.insert('vets', {
      'name': 'Dr. Daniel Lee',
      'email': 'daniel.lee@animalwellness.com',
      'phone': '+15557654321',
      'specialty': 'Orthopedics',
      'clinic': 'Animal Wellness Hospital',
    });
  }
  //
  // Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 2) {
  //     await db.execute('DROP TABLE IF EXISTS rdvs');

  //     await db.execute('''
  //     CREATE TABLE rdvs(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       animal_id INTEGER NOT NULL,
  //       vet TEXT,
  //       date TEXT NOT NULL,
  //       is_confirmed INTEGER NOT NULL
  //     )
  //   ''');
  //   }
  // }

  Future close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
