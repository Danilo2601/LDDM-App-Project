import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Modelo da Review
class Review {
  final int? id;
  final String placeName;
  final String reviewText;
  final int rating;
  final String? imagePath;

  Review({
    this.id,
    required this.placeName,
    required this.reviewText,
    required this.rating,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placeName': placeName,
      'reviewText': reviewText,
      'rating': rating,
      'imagePath': imagePath,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      placeName: map['placeName'],
      reviewText: map['reviewText'],
      rating: map['rating'],
      imagePath: map['imagePath'],
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
    final path = join(dbPath, 'reviews.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reviews (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            placeName TEXT,
            reviewText TEXT,
            rating INTEGER,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertReview(Review review) async {
    final db = await database;
    return await db.insert('reviews', review.toMap());
  }

  Future<List<Review>> getAllReviews() async {
    final db = await database;
    final result = await db.query('reviews');
    return result.map((map) => Review.fromMap(map)).toList();
  }
}

// Tela principal
class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _reviewTextController = TextEditingController();
  int rating = 0;
  File? _image;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Método para selecionar uma imagem
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Método para salvar a review
  Future<void> _saveReview() async {
    final placeName = _placeNameController.text;
    final reviewText = _reviewTextController.text;

    if (placeName.isEmpty || reviewText.isEmpty || rating == 0) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    final newReview = Review(
      placeName: placeName,
      reviewText: reviewText,
      rating: rating,
      imagePath: _image?.path,
    );

    await _dbHelper.insertReview(newReview);

    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Review salva com sucesso!')),
    );

    _placeNameController.clear();
    _reviewTextController.clear();
    setState(() {
      rating = 0;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Screen'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Campo de texto para o nome do lugar
              TextField(
                controller: _placeNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Lugar',
                  labelStyle: TextStyle(color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),

              // Campo de texto para a review
              TextField(
                controller: _reviewTextController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Escreva sobre o que achou',
                  labelStyle: TextStyle(color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),

              // Avaliação por estrelas
              Text(
                'Avaliação:',
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 20),

              // Botão para adicionar imagem
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Adicione uma imagem'),
                  ),
                  SizedBox(width: 10),
                  _image != null
                      ? Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 20),

              // Botão para salvar a review
              Center(
                child: ElevatedButton(
                  onPressed: _saveReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Salvar Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
