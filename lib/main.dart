import 'package:flutter/material.dart';

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
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/explore': (context) => const ExplorePage(),
        '/popular': (context) => const PopularDestinationsPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            MapImageSection(),
            ServicesSection(),
            PopularDestinationsSection(),
            ContactSection(),
            Footer(),
          ],
        ),
      ),
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
                // Botões de navegação
                Row(
                  children: [
                    _buildNavButton(context, 'Home', '/home'),
                    _buildNavButton(context, 'Explorar', '/explore'),
                    _buildNavButton(context, 'Destinos Populares', '/popular'),
                    _buildNavButton(context, 'Sobre', '/about'),
                    // Botão de login
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Fazer login'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Campo de busca centralizado
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 600,
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
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
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
                        child: const Text('Buscar'),
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

  Widget _buildNavButton(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 16),
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
              'assets/place1.jpg'), // Adicione uma imagem de fundo que remete a Belo Horizonte
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
              color: Colors.white,
              letterSpacing: 2.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Belo Horizonte\n',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[
                        Colors.lightBlueAccent,
                        Colors.cyanAccent,
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              const TextSpan(
                text: 'com a My Trip',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
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
        'maps.jpeg',
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
        width: 250,
        child: Column(
          children: [
            Icon(icon, size: 60, color: Colors.blue),
            const SizedBox(height: 10),
            Text(title,
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
              DestinationCard(
                  imageUrl: 'assets/place1.jpeg', title: 'Igreja da Pampulha'),
              DestinationCard(imageUrl: 'assets/place2.jpeg', title: 'Savassi'),
              DestinationCard(
                  imageUrl: 'assets/place3.jpeg', title: 'Parque Guanabara'),
              DestinationCard(
                  imageUrl: 'assets/mineirao.jpg', title: 'Mineirão'),
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
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
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
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
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



