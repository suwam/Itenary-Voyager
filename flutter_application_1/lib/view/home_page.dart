import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/itinerary_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _sliderTimer;

  final List<String> backgroundImages = [
    'assets/image/thamel.jpg',
    'assets/image/patan.webp',
    'assets/image/bouddha.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _currentPage = (_currentPage + 1) % backgroundImages.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            _menuItem("Profile", Icons.person, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            }),
            _menuItem("Settings", Icons.settings, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            }),
            _menuItem("Logout", Icons.logout, () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            }),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ItineraryController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 165, 224),
        title: const Text("Travel Itinerary"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            child: const Text("Home", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/generator'),
            child: const Text("Generator", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/about'),
            child: const Text("About Us", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/chat'),
            child: const Text("Chat", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/contact'),
            child: const Text("Contact Us", style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: _showProfileMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: backgroundImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  backgroundImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: controller.filteredPOIs.isEmpty
                      ? const Center(
                          child: Text(
                            "No POIs available.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.filteredPOIs.length,
                          itemBuilder: (context, index) {
                            final poi = controller.filteredPOIs[index];
                            return Card(
                              color: Colors.white.withOpacity(0.9),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.asset(poi.image, width: 60, fit: BoxFit.cover),
                                title: Text(poi.name),
                                subtitle: Text("Tags: ${poi.tags.join(', ')}"),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
