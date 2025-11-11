import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B0B),
        colorScheme: ColorScheme.dark(primary: Colors.redAccent),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // CardSwiper controller dibuat sekali di state
  late final CardSwiperController _cardSwiperController;

  // [UPDATE] Menambahkan key 'overview' untuk setiap film
  final List<Map<String, String>> sampleMovies = [
    {
      'title': 'Deadpool',
      'poster': 'assets/images/Deadpool x Wolverine.jpg',
      'subtitle': 'Action · 2024 · 105 min',
      'overview':
          'Wade Wilson, in a mid-life crisis, is pulled from his quiet life by the TVA to embark on a mission with a very reluctant Wolverine. Chaos, fourth-wall breaks, and explosions ensue.',
    },
    {
      'title': 'Bad Boys Ride or Die',
      'poster': 'assets/images/Bad-Boys-Ride-or-Die.jpg',
      'subtitle': 'Action · 2021 · 120 min',
      'overview':
          'Miami\'s finest, Mike Lowrey and Marcus Burnett, are back. But this time, they\'re on the run after their late captain is framed, forcing them to clear his name outside the law.',
    },
    {
      'title': 'Mystery Film',
      'poster': 'assets/images/Mystery.jpg',
      'subtitle': 'Drama · 2023 · 110 min',
      'overview':
          'A seasoned detective investigating a seemingly impossible disappearance finds himself questioning his own reality as the case unravels a conspiracy larger than he ever imagined.',
    },
    {
      'title': 'Sonic Adventure X',
      'poster': 'assets/images/Sonic Adventure X.jpg',
      'subtitle': 'Adventure · 2022 · 130 min',
      'overview':
          'Sonic, Tails, and Knuckles team up once again to stop Dr. Robotnik from harnessing the power of the Chaos Emeralds. A new, mysterious challenger stands in their way.',
    },
    {
      'title': 'Sonic X Shadow Generations',
      'poster': 'assets/images/Sonic X Shadow Generations.jpg',
      'subtitle': 'Adventure · 2021 · 150 min',
      'overview':
          'This new campaign explores Shadow past and motivations giving him a new story following his last appearance in Sonic Forces .',
    },
    {
      'title': 'Avatar',
      'poster': 'assets/images/Avatar.jpg',
      'subtitle': 'Sci-Fi · 2020 · 140 min',
      'overview':
          'A paraplegic marine, Jake Sully, is dispatched to the distant moon of Pandora. He finds himself torn between following orders and protecting the world he feels is his new home.',
    },
    {
      'title': 'Avatar Fire and Ash',
      'poster': 'assets/images/Avatar Fire and Ash.jpg',
      'subtitle': 'Sci-Fi · 2025 · 182 min',
      'overview':
          'Jake and Neytiri family grapples with grief after Neteyam death, encountering a new, aggressive Navi tribe, the Ash People, who are led by the fiery Varang, as the conflict on Pandora escalates and a new moral focus emerges..',
    },
    {
      'title': 'One cut of the dead',
      'poster': 'assets/images/onecutofthedead.jpg',
      'subtitle': 'Comedy · 2019 · 95 min',
      'overview':
          'A low-budget film crew attempts to shoot a zombie movie in one continuous take. However, their hectic shoot is interrupted by... an actual zombie apocalypse? Or is it?',
    },
  ];

  void _onTapNav(int idx) => setState(() => _selectedIndex = idx);

  @override
  void initState() {
    super.initState();
    _cardSwiperController = CardSwiperController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache gambar agar mengurangi jank saat tampil pertama kali.
    for (final m in sampleMovies) {
      final provider = AssetImage(m['poster']!);
      // ignore: unawaited_futures
      precacheImage(provider, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Wrapper aman untuk menampilkan image dari asset (tidak crash jika asset hilang)
  Widget _safeImage(
    String assetPath, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // tampilkan placeholder sederhana dan jangan crash app
        return Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          color: const Color(0xFF222222),
          child: const Icon(
            Icons.broken_image,
            size: 36,
            color: Colors.white30,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedIndex) {
      case 1:
        content = const Center(
          child: Text(
            'Search screen (implement search)',
            style: TextStyle(color: Colors.white70),
          ),
        );
        break;
      case 2:
        content = const Center(
          child: Text(
            'Favorites screen (saved items)',
            style: TextStyle(color: Colors.white70),
          ),
        );
        break;
      default:
        content = _buildHome(context);
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
        ],
      ),
      body: SafeArea(child: content),
    );
  }

  Widget _buildHome(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Carousel banner (Now Playing) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Now Playing',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          _buildCarouselBanner(context),

          const SizedBox(height: 16),
          // --- Trending (card swiper) ---
          _sectionTitle(context, 'Trending'),
          const SizedBox(height: 8),
          SizedBox(height: 260, child: _buildCardSwiper(context)),

          const SizedBox(height: 16),
          _sectionTitle(context, 'Popular'),
          const SizedBox(height: 8),
          _horizontalMovieList(context, sampleMovies, 'popular'),

          const SizedBox(height: 16),
          _sectionTitle(context, 'Top Rated'),
          const SizedBox(height: 8),
          _horizontalMovieList(
            context,
            sampleMovies.reversed.toList(),
            'toprated',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCarouselBanner(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: sampleMovies.length,
      itemBuilder: (context, index, realIdx) {
        final m = sampleMovies[index];
        final heroTag = 'carousel_${m['poster']!}';

        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(movie: m, heroTag: heroTag),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Stack(
              children: [
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 320,
                      width: double.infinity,
                      child: _safeImage(m['poster']!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['title']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m['subtitle']!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    heroTag: 'banner_${m['title']}',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            MovieDetailPage(movie: m, heroTag: heroTag),
                      ),
                    ),
                    child: const Icon(Icons.play_arrow),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 320,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        viewportFraction: 0.86,
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context) {
    return CardSwiper(
      controller: _cardSwiperController,
      numberOfCardsDisplayed: 3,
      cardsCount: sampleMovies.length,
      onSwipe: (int index, dynamic, direction) async {
        return true;
      },
      cardBuilder: (context, index) {
        final m = sampleMovies[index];
        final heroTag = 'swiper_${m['poster']!}';

        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(movie: m, heroTag: heroTag),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _safeImage(m['poster']!, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black45, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Text(
                        m['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text('More', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _horizontalMovieList(
    BuildContext context,
    List<Map<String, String>> movies,
    String listId,
  ) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, idx) {
          final m = movies[idx];
          final heroTag = '${listId}_${m['poster']!}';

          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MovieDetailPage(movie: m, heroTag: heroTag),
              ),
            ),
            child: Container(
              width: 110,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _safeImage(
                        m['poster']!,
                        height: 140,
                        width: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    m['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final Map<String, String> movie;
  final String heroTag;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(movie['title']!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _DetailPoster(movie: movie),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie['subtitle']!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Play tapped')),
                            ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to favorites'),
                              ),
                            ),
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Favorite'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  // [UPDATE] Menggunakan data overview dari map
                  Text(
                    movie['overview']!, // Mengganti teks placeholder
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget ini tidak perlu diubah
class _DetailPoster extends StatelessWidget {
  final Map<String, String> movie;
  const _DetailPoster({required this.movie});

  @override
  Widget build(BuildContext context) {
    final poster = movie['poster']!;
    return SizedBox(
      height: 380,
      width: double.infinity,
      child: Image.asset(
        poster,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 380,
            alignment: Alignment.center,
            color: const Color(0xFF222222),
            child: const Icon(
              Icons.broken_image,
              size: 48,
              color: Colors.white30,
            ),
          );
        },
      ),
    );
  }
}
