import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'TelaCadastro.dart' as TelaCadastro;

class UserProfileScreen extends StatefulWidget {
  final int userId;  // O ID do usuário logado será passado para essa tela
  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<Map<String, dynamic>?> _userData;

  @override
  void initState() {
    super.initState();
    // Verificar se o usuário está logado. Caso contrário, redireciona para a tela de login
    _userData = _getUserData();
  }

  // Método para buscar os dados do usuário logado
  Future<Map<String, dynamic>?> _getUserData() async {
    final userData = await TelaCadastro.DatabaseHelper().getUser(widget.userId);
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(  // FutureBuilder para buscar dados do usuário
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            // Se o usuário não estiver logado, redireciona para a tela de login
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Faça o login para acessar o perfil'),
              ),
            );
          }

          final user = snapshot.data!;
          final String username = user['username'] ?? 'Nome não encontrado';
          // Verifique se favoritos é uma lista de strings antes de decodificar
          final favoritesJson = user['favorites'] ?? '[]';
          final List<String> favorites = List<String>.from(jsonDecode(favoritesJson));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Nome de Usuário
                Text('Nome de Usuário: $username', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Exibir Favoritos
                const Text('Favoritos:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // Usando ListView sem Expanded para evitar problemas de layout
                if (favorites.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,  // Importante para não causar problemas de layout
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final placeName = favorites[index];
                      return ListTile(
                        leading: Icon(Icons.place, color: Colors.orange),
                        title: Text(placeName),
                        trailing: Icon(Icons.star, color: Colors.orange),
                      );
                    },
                  )
                else
                  const Center(child: Text('Você ainda não tem favoritos')),
              ],
            ),
          );
        },
      ),
    );
  }
}
