import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int? id;
  final String name;
  final String birthDate;
  final String phone;
  final String email;
  final String password;
  final String gender;
  final bool gmailNotifications;
  final bool whatsappNotifications;

  User({
    this.id,
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.password,
    required this.gender,
    required this.gmailNotifications,
    required this.whatsappNotifications,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate,
      'phone': phone,
      'email': email,
      'password': password,
      'gender': gender,
      'gmailNotifications': gmailNotifications ? 1 : 0,
      'whatsappNotifications': whatsappNotifications ? 1 : 0,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return openDatabase(
      path,
      version: 2,  // Atualizamos a versão do banco para permitir alterações
      onCreate: (db, version) async {
        // Criação da tabela de usuários
        await db.execute(''' 
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            birthDate TEXT,
            phone TEXT,
            email TEXT,
            password TEXT,
            gender TEXT,
            gmailNotifications INTEGER,
            whatsappNotifications INTEGER,
            favorites TEXT  -- Coluna para armazenar favoritos como um JSON ou String
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Adiciona a coluna favorites se não existir
          await db.execute('ALTER TABLE users ADD COLUMN favorites TEXT');
        }
      },
    );
  }

  Future<void> updateFavorites(int userId, List<String> favorites) async {
    final db = await database;
    String favoritesJson = jsonEncode(favorites);  // Converte lista de favoritos em JSON
    await db.update(
      'users',
      {'favorites': favoritesJson},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Função para buscar os dados do usuário
  Future<Map<String, dynamic>?> getUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> insertUser(User user) async {
  final db = await database;
  await db.insert(
    'users',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,  // Evita conflito em caso de ID duplicado
  );
}

}


class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final double _fontSize = 16;
  bool _obscureText = true;
  String _radioSelected = '';
  bool _gmail = false;
  bool _whatsapp = false;

  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _switchPasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _saveUser(BuildContext context) async {
    if (_nameController.text.isEmpty ||
        _birthDateController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _radioSelected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um e-mail válido!')),
      );
      return;
    }

    if (_phoneController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Telefone deve ter 11 dígitos!')),
      );
      return;
    }

    final newUser = User(
      name: _nameController.text,
      birthDate: _birthDateController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
      gender: _radioSelected,
      gmailNotifications: _gmail,
      whatsappNotifications: _whatsapp,
    );

    await _dbHelper.insertUser(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
    );

    _nameController.clear();
    _birthDateController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _radioSelected = '';
      _gmail = false;
      _whatsapp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an account"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: _fontSize),
                keyboardType: TextInputType.text,
                maxLength: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _birthDateController,
                decoration: const InputDecoration(
                  labelText: "Data de nascimento",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: _fontSize),
                keyboardType: TextInputType.datetime,
                maxLength: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: _fontSize),
                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: _fontSize),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: _switchPasswordVisibility,
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                style: TextStyle(fontSize: _fontSize),
                maxLength: 20,
              ),
            ),
            Row(
              children: <Widget>[
                Text("Gênero:", style: TextStyle(fontSize: _fontSize)),
                const SizedBox(width: 20),
                Expanded(
                  child: RadioListTile(
                    title: Text("Masculino", style: TextStyle(fontSize: _fontSize)),
                    value: "m",
                    groupValue: _radioSelected,
                    onChanged: (String? escolha) {
                      setState(() {
                        _radioSelected = escolha!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Feminino", style: TextStyle(fontSize: _fontSize)),
                    value: "f",
                    groupValue: _radioSelected,
                    onChanged: (String? escolha) {
                      setState(() {
                        _radioSelected = escolha!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SwitchListTile(
              title: Text("Gmail", style: TextStyle(fontSize: _fontSize)),
              value: _gmail,
              onChanged: (bool valor) {
                setState(() {
                  _gmail = valor;
                });
              },
            ),
            SwitchListTile(
              title: Text("WhatsApp", style: TextStyle(fontSize: _fontSize)),
              value: _whatsapp,
              onChanged: (bool valor) {
                setState(() {
                  _whatsapp = valor;
                });
              },
            ),
            ElevatedButton(
              onPressed: () => _saveUser(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),  // Passando o contexto aqui
              child: Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
