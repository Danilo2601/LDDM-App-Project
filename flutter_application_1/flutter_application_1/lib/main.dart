import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/review_page.dart';
import 'package:flutter_application_1/user_profile_screen.dart';


void main() {
  runApp(const MyTripWebsite());
}

class MyTripWebsite extends StatelessWidget {
  const MyTripWebsite({super.key});
  
  
  @override
  Widget build(BuildContext context) {
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
        '/search': (context) => ReviewScreen(),  // Supondo que seja o arquivo review_page.dart
        '/profile': (context) =>  UserProfileScreen(), // Referenciando o arquivo de perfil
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
    // Obtendo o email passado como argumento
    final email = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
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




class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
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
                // Logo do site
                const Text(
                  'My Trip App',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Botão de login
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
                  child: const Text('Fazer login', style: TextStyle(color: Colors.orange),),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Campo de busca centralizado
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7, 
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Lugares para ir, o que fazer, hotéis...',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Buscar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
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

class MapImageSection extends StatelessWidget {
  const MapImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        'assets/maps.jpeg',
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
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
          Image.network(imageUrl, width: 200, height: 150, fit: BoxFit.cover),
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
      appBar: CustomAppBar(),
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

      bottomNavigationBar: _buildBottomNavigationBar(context, _currentIndex)
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
      appBar: CustomAppBar(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Restaurantes Populares',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
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
                  location: 'Pambulha, Belo Horizonte',
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
          ],
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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem
          Container(
            width: 150,
            height: 150,
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
          // Conteúdo textual
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(location,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 5),
                      Text('$reviews avaliações',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          // Botão de salvar
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


<<<<<<< HEAD
=======
class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int rating = 0;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Campo de texto para o nome do lugar
            TextField(
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
              style: TextStyle(color: Colors.white, fontSize: 16),
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
                    : Text(
                        '.',
                        style: TextStyle(color: Colors.white),
                      ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 4),
    );
  }
}


class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Seção de cabeçalho com nome, foto e bio
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Nome de Usuário',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Esta é uma bio interessante que fala um pouco sobre o usuário.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Seção de lugares favoritos
            const Text(
              'Lugares Favoritos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/place1.jpeg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Igrejinha da Pampulha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/place2.jpeg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Praça da Liberdade',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/place3.jpeg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Pampulha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Seção de reviews anteriores
            const Text(
              'Reviews Recentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildReviewTile('Igrejinha da Pampulha', 'Maravilhoso! achei muito linda, carrega muita história.', 5),
                  _buildReviewTile('Praça da Liberdade', 'Praça linda que tem um jardim maravilhoso', 4),
                  _buildReviewTile('Pampulha', 'Otimo para fazer caminhadas', 5),
                ],
              ),
            ),
          ],
        ),
      ),
            bottomNavigationBar: _buildBottomNavigationBar(context, 5),
      backgroundColor: Colors.blue.shade900,
    );
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
>>>>>>> 05828390d5c25c2d5c574b205191b75d47a7a318
