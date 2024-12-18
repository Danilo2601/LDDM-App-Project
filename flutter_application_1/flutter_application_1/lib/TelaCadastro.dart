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
    final path = join(dbPath, 'users.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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
            whatsappNotifications INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }
}

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  double _fontSize = 16;
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
      // Usando o ScaffoldMessenger de forma correta dentro do contexto
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
      SnackBar(content: Text('Usuário cadastrado com sucesso!')),
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
        title: Text("Create an account"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
                  border: OutlineInputBorder(),
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
                SizedBox(width: 20),
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
              onPressed: () => _saveUser(context),  // Passando o contexto aqui
              child: Text("Cadastrar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
