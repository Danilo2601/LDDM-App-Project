import 'package:flutter/material.dart';
import 'TelaCadastro.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Modelo de usuário
class User {
  final int? id;
  final String email;
  final String password;

  User({this.id, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}

// Helper para gerenciar o banco de dados
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
            email TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _remember = false;
  bool _obscureText = true;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _switchPasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Método atualizado para exibir o diálogo de erro
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context, // Usando o context fornecido pelo método Builder
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de login'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  // Método de validação de login
  Future<void> _validarLogin(BuildContext context) async {
    String email = _emailController.text;
    String senha = _passwordController.text;

    final user = await _dbHelper.getUserByEmail(email);

    if (user == null) {
      _showErrorDialog(context, "Email não encontrado.");
    } else if (user.password != senha) {
      _showErrorDialog(context, "Senha incorreta.");
    } else {
      Navigator.of(context).pushNamed("/", arguments: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Texto "TrailGuide"
                  Text(
                    'TrailGuide',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Ícone de pessoa com borda laranja
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.orange,
                        width: 4,
                      ),
                      color: Colors.blue[900],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Campo de email
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  SizedBox(height: 20),

                  // Campo de senha
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        onPressed: _switchPasswordVisibility,
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    controller: _passwordController,
                    obscureText: _obscureText,
                  ),
                  SizedBox(height: 20),

                  // Checkbox "Lembrar de mim"
                  CheckboxListTile(
                    title: Text(
                      "Lembrar de mim?",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _remember,
                    onChanged: (bool? valor) {
                      setState(() {
                        _remember = valor ?? false;
                      });
                    },
                    checkColor: Colors.black,
                    activeColor: Colors.white,
                  ),
                  SizedBox(height: 20),

                  // Botão de login
                  ElevatedButton(
                    onPressed: () => _validarLogin(context), // Passando o context correto
                    child: Text("Entrar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Link para criar nova conta
                  RichText(
                    text: TextSpan(
                      text: "Não tem conta? ",
                      style: TextStyle(color: Colors.white),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TelaCadastro()),
                              );
                            },
                            child: Text(
                              "Criar uma nova",
                              style: TextStyle(
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
