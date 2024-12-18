import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'TelaCadastro.dart' as TelaCadastro;


void main() {
  runApp(const MyTripWebsite());
}

class MyTripWebsite extends StatelessWidget {
  const MyTripWebsite({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    final int userId = ModalRoute.of(context)!.settings.arguments as int;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Trip App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/explore': (context) => const ExplorePage(),
        '/popular': (context) => const PopularDestinationsPage(),
        '/about': (context) => const AboutPage(),
        '/login': (context) => LoginPage(),
        '/search': (context) => ReviewScreen(),
        '/profile': (context) => UserProfileScreen(userId: userId ?? 0),
      },
    );
  }
}


BottomNavigationBar _buildBottomNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacementNamed('/');
          break;
        case 1:
          Navigator.of(context).pushReplacementNamed('/explore');
          break;
        case 2:
          Navigator.of(context).pushReplacementNamed('/popular');
          break;
        case 3:
          Navigator.of(context).pushReplacementNamed('/about');
          break;
        case 4:
          Navigator.of(context).pushReplacementNamed('/search'); // Redireciona para ReviewPage
          break;
        case 5:
          Navigator.of(context).pushReplacementNamed('/profile'); // Redireciona para ProfilePage
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
      BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Populares'),
      BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Sobre'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'), // Ícone de Pesquisa
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),   // Ícone de Perfil
    ],
    selectedItemColor: Colors.yellow[700],
    unselectedItemColor: Colors.blue[900],
    unselectedLabelStyle: TextStyle(color: Colors.blue[900]),
    showUnselectedLabels: true,
  );
}



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
  final email = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: CustomAppBar(showSearch: true), // Busca visível
      body:  SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            // Exibindo a saudação com o nome do usuário ou email
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: email != null 
                  ? Text(
                        "Bem-vindo, $email!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      )
                  : Text(
                      "Bem-vindo, Usuário!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
            ),
            MapImageSection(),
            ServicesSection(),
            PopularDestinationsSection(),
            ContactSection(),
            Footer(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, _currentIndex),
    );
  }
}


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showSearch; // Adiciona um parâmetro para controle

  const CustomAppBar({super.key, this.showSearch = false});
  
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _CustomAppBarState extends State<CustomAppBar> {
  List<dynamic> _places = [];
  List<dynamic> _filteredPlaces = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  // Carrega os dados do JSON
  Future<void> _loadPlaces() async {
    final String response = await rootBundle.loadString('assets/places.json');
    final data = json.decode(response);
    setState(() {
      _places = data;
      _filteredPlaces = _places;
    });
  }

  // Filtra a lista conforme a entrada
  void _filterPlaces(String query) {
    setState(() {
      _query = query;
      if (query.isEmpty) {
        _filteredPlaces = _places;
      } else {
        _filteredPlaces = _places
            .where((place) =>
                place['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão "My Trip App"
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text(
                    'My Trip App',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/login");
                  },
                  child: const Text(
                    'Fazer login',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Campo de busca
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Lugares para ir, o que fazer, hotéis...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterPlaces,
            ),
            const SizedBox(height: 10),
            // Exibição dinâmica dos resultados
            _query.isNotEmpty
                ? Container(
                    height: 150,
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = _filteredPlaces[index];
                        return ListTile(
                          leading: const Icon(Icons.place, color: Colors.orange),
                          title: Text(place['name']),
                          onTap: () {
                            // Ação ao selecionar um item
                            Navigator.of(context).pushNamed('/explore');
                          },
                        );
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}



class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Aumenta a altura para dar mais destaque
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
              'assets/belohorizonte2.jpg'), // Adicione uma imagem de fundo que remete a Belo Horizonte
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(
                0.6), // Adiciona uma leve sobreposição escura para o texto se destacar
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Explore\n',
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
              letterSpacing: 2.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Belo Horizonte\n',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900]
                ),
              ),
              const TextSpan(
                text: 'com a My Trip',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapImageSection extends StatefulWidget {
  const MapImageSection({super.key});

  @override
  State<MapImageSection> createState() => _MapImageSectionState();
}

class _MapImageSectionState extends State<MapImageSection> {
  late GoogleMapController mapController;

  // Coordenadas dos locais com base na lista fornecida
  final List<Map<String, dynamic>> places = [
    {'name': 'Igreja da Pampulha', 'category': 'Cultural', 'latLng': LatLng(-19.8586, -43.9842)},
    {'name': 'Parque Municipal', 'category': 'Parque', 'latLng': LatLng(-19.9212, -43.9377)},
    {'name': 'Mercado Central', 'category': 'Compras', 'latLng': LatLng(-19.9222, -43.9375)},
    {'name': 'Praça da Liberdade', 'category': 'Histórico', 'latLng': LatLng(-19.932056, -43.937378)},
    {'name': 'Mineirão', 'category': 'Esportivo', 'latLng': LatLng(-19.8651, -43.9716)},
    {'name': 'Mirante Mangabeiras', 'category': 'Parque', 'latLng': LatLng(-19.9499, -43.9133)},
    {'name': 'Inhotim', 'category': 'Cultural', 'latLng': LatLng(-20.1251, -44.0559)},
    {'name': 'Feira Hippie', 'category': 'Compras', 'latLng': LatLng(-19.9244, -43.9337)},
    {'name': 'Palácio das Artes', 'category': 'Cultural', 'latLng': LatLng(-19.9225, -43.9385)},
    {'name': 'Lagoa da Pampulha', 'category': 'Natureza', 'latLng': LatLng(-19.8534, -43.9761)},
    {'name': 'Parque das Mangabeiras', 'category': 'Parque', 'latLng': LatLng(-19.9496, -43.9152)},
    {'name': 'Savassi', 'category': 'Vida Noturna', 'latLng': LatLng(-19.9338, -43.9296)},
    {'name': 'Museu de Arte da Pampulha', 'category': 'Cultural', 'latLng': LatLng(-19.8582, -43.9837)},
    {'name': 'Centro Cultural Banco do Brasil', 'category': 'Cultural', 'latLng': LatLng(-19.9323, -43.9382)},
    {'name': 'Museu Histórico Abílio Barreto', 'category': 'Histórico', 'latLng': LatLng(-19.9374, -43.9409)},
    {'name': 'Museu de Ciências Naturais', 'category': 'Cultural', 'latLng': LatLng(-19.9350, -43.9815)},
    {'name': 'Restaurante Xapuri', 'category': 'Gastronomia', 'latLng': LatLng(-19.8595, -43.9783)},
    {'name': 'Mercado Novo', 'category': 'Gastronomia', 'latLng': LatLng(-19.9216, -43.9406)},
    {'name': 'Casa Fiat de Cultura', 'category': 'Cultural', 'latLng': LatLng(-19.9329, -43.9387)},
    {'name': 'Café com Letras', 'category': 'Gastronomia', 'latLng': LatLng(-19.9328, -43.9295)},
  ];

  // Função para determinar a cor dos marcadores com base na categoria
  BitmapDescriptor _getMarkerColor(String category) {
    switch (category) {
      case 'Cultural':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      case 'Parque':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'Compras':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'Histórico':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'Esportivo':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'Natureza':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      case 'Vida Noturna':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case 'Gastronomia':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      default:
        return BitmapDescriptor.defaultMarker; // Cor padrão
    }
  }

  Set<Marker> _createMarkers() {
    return places.map((place) {
      return Marker(
        markerId: MarkerId(place['name']),
        position: place['latLng'],
        infoWindow: InfoWindow(title: place['name']),
        icon: place['name'] == 'Praça da Liberdade'
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
            : _getMarkerColor(place['category']),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialPosition = const LatLng(-19.932056, -43.937378); // Praça da Liberdade

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 400,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 13.0,
        ),
        markers: _createMarkers(),
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}


class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          Text(
            'Serviços',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ServiceCard(
                icon: Icons.flight,
                title: 'Reservas de Voo',
                description:
                    'Encontre informações sobre passagens aéreas em BH.',
              ),
              ServiceCard(
                icon: Icons.hotel,
                title: 'Reservas de Hotel',
                description:
                    'Encontre hotéis confortáveis em qualquer parte da cidade.',
              ),
              ServiceCard(
                icon: Icons.directions_car,
                title: 'Aluguel de Carros',
                description:
                    'Veja os principais locais onde pode alugar carros.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ServiceCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          children: [
            Icon(icon, size: 60, color: Colors.blue),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class PopularDestinationsSection extends StatelessWidget {
  const PopularDestinationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[100],
      child: const Column(
        children: [
          Text(
            'Destinos Populares',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              DestinationCard(imageUrl: 'assets/place1.jpeg', title: 'Igreja da Pampulha'),
              DestinationCard(imageUrl: 'assets/place2.jpeg', title: 'Savassi'),
              DestinationCard(imageUrl: 'assets/place3.jpeg', title: 'Parque Guanabara'),
              DestinationCard(imageUrl: 'assets/mineirao.jpg', title: 'Mineirão'),
            ],
          ),
        ],
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const DestinationCard(
      {super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(imageUrl, width: 200, height: 150, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          Text(
            'Entre em Contato',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Email: contato@mytrip.com',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Telefone: +55 11 1234-5678',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Siga-nos nas redes sociais:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook,
                    color: Colors
                        .white), // ícone do Facebook (substituir por outro genérico)
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.alternate_email,
                    color: Colors.white), // ícone genérico para Twitter
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.photo_camera,
                    color: Colors.white), // ícone genérico para Instagram
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '© 2024 My Trip Website. Todos os direitos reservados.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final int _currentIndex = 1;

  List<Place> places = [
    Place(name: 'Igreja da Pampulha', category: 'Cultural', rating: 4.8),
    Place(name: 'Parque Municipal', category: 'Parque', rating: 4.5),
    Place(name: 'Mercado Central', category: 'Compras', rating: 4.7),
    Place(name: 'Praça da Liberdade', category: 'Histórico', rating: 4.6),
    Place(name: 'Mineirão', category: 'Esportivo', rating: 4.9),
    Place(name: 'Mirante Mangabeiras', category: 'Parque', rating: 4.6),
    Place(name: 'Inhotim', category: 'Cultural', rating: 4.9),
    Place(name: 'Feira Hippie', category: 'Compras', rating: 4.4),
    Place(name: 'Palácio das Artes', category: 'Cultural', rating: 4.8),
    Place(name: 'Lagoa da Pampulha', category: 'Natureza', rating: 4.7),
    Place(name: 'Parque das Mangabeiras', category: 'Parque', rating: 4.7),
    Place(name: 'Savassi', category: 'Vida Noturna', rating: 4.6),
    Place(name: 'Museu de Arte da Pampulha', category: 'Cultural', rating: 4.6),
    Place(name: 'Centro Cultural Banco do Brasil', category: 'Cultural', rating: 4.7),
    Place(name: 'Museu Histórico Abílio Barreto', category: 'Histórico', rating: 4.5),
    Place(name: 'Museu de Ciências Naturais', category: 'Cultural', rating: 4.6),
    Place(name: 'Restaurante Xapuri', category: 'Gastronomia', rating: 4.7),
    Place(name: 'Mercado Novo', category: 'Gastronomia', rating: 4.6),
    Place(name: 'Casa Fiat de Cultura', category: 'Cultural', rating: 4.8),
    Place(name: 'Café com Letras', category: 'Gastronomia', rating: 4.5),
  ];

  List<Place> filteredPlaces = [];
  String searchQuery = '';
  Map<String, bool> selectedCategories = {
    'Cultural': false,
    'Parque': false,
    'Compras': false,
    'Histórico': false,
    'Esportivo': false,
    'Natureza': false,
    'Vida Noturna': false,
    'Gastronomia': false,
  };

  @override
  void initState() {
    super.initState();
    filteredPlaces = places;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void updateCategoryFilter(String category, bool selected) {
    setState(() {
      selectedCategories[category] = selected;
      applyFilters();
    });
  }

  void applyFilters() {
    setState(() {
      filteredPlaces = places
          .where((place) =>
              place.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
              (selectedCategories.values.every((isSelected) => !isSelected) ||
                  selectedCategories[place.category] == true))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showSearch: true), // Exibe a busca no AppBar
      body: Column(
        children: [
          // Filtros de categoria com Checkboxes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10.0,
              children: selectedCategories.keys.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: selectedCategories[category]!,
                  onSelected: (bool selected) {
                    updateCategoryFilter(category, selected);
                  },
                );
              }).toList(),
            ),
          ),
          // Lista filtrada de lugares
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = filteredPlaces[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.category),
                  trailing: Text('${place.rating} ⭐'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, _currentIndex),
    );
  }
}

class Place {
  final String name;
  final String category;
  final double rating;

  Place({required this.name, required this.category, required this.rating});
}



class PopularDestinationsPage extends StatelessWidget {
  const PopularDestinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: const [
              Text(
                'Restaurantes Populares',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DestinationCardPage(
                imageUrl: 'assets/restaurante1.jpg',
                title: 'Restaurante 1621',
                location: 'Centro, Belo Horizonte',
                reviews: 2776,
                description:
                    'Uma experiência gastronômica única, com um ambiente acolhedor e culinária excepcional.',
              ),
              DestinationCardPage(
                imageUrl: 'assets/restaurante2.jpeg',
                title: 'Northcote Restaurant',
                location: 'Pampulha, Belo Horizonte',
                reviews: 2020,
                description:
                    'Experimente pratos deliciosos preparados por renomados chefs em um ambiente elegante.',
              ),
              DestinationCardPage(
                imageUrl: 'assets/restaurante3.jpeg',
                title: 'Casa Vigil',
                location: 'Savassi, Belo Horizonte',
                reviews: 1490,
                description:
                    'Desfrute de uma experiência única em uma vinícola localizada no coração de BH.',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 2),
    );
  }
}


class DestinationCardPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final int reviews;
  final String description;

  const DestinationCardPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.reviews,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem ajustável
          Container(
            width: MediaQuery.of(context).size.width * 0.3, // 30% da largura da tela
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Conteúdo textual flexível
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // Limita o título a uma linha
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        '$reviews avaliações',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Limita a descrição a duas linhas
                  ),
                ],
              ),
            ),
          ),
          // Ícone de favorito
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quem Somos',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Nós somos uma equipe dedicada a criar experiências de viagem inesquecíveis através da tecnologia.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              TeamMember(
                name: 'Diego',
                description:
                    'Diego é um desenvolvedor com grande experiência em aplicativos de turismo e mobilidade urbana. Seu foco é oferecer soluções inovadoras para melhorar a experiência do usuário.',
                imageUrl: 'assets/diego.jpg', // Adicione uma imagem do Diego
              ),
              TeamMember(
                name: 'Danilo',
                description:
                    'Danilo é responsável pela arquitetura de dados e pela integração de APIs que permitem oferecer as melhores recomendações de viagem aos usuários.',
                imageUrl: 'assets/danilo.jpg', // Adicione uma imagem do Danilo
              ),
              TeamMember(
                name: 'Rondinelly',
                description:
                    'Com uma paixão por design, Rondinelly é o designer da equipe, garantindo que o aplicativo seja visualmente atraente e fácil de usar.',
                imageUrl:
                    'assets/rondinelly.jpg', // Adicione uma imagem do Rondinelly
              ),
              TeamMember(
                name: 'Henrique',
                description:
                    'Henrique é responsável pelo backend e pela segurança do aplicativo, garantindo que a plataforma seja segura e escalável para todos os usuários.',
                imageUrl:
                    'assets/henrique.jpg', // Adicione uma imagem do Henrique
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 3),
    );
  }
}

class TeamMember extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;

  const TeamMember({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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
      bottomNavigationBar: _buildBottomNavigationBar(context, 4),
    );
  }
}


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

  // Função para construir o item de review
  Widget _buildReviewTile(String place, String review, int rating) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          place,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          review,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: Colors.orange,
            );
          }),
        ),
      ),
    );
  }
}

