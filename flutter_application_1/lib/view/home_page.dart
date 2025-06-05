import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../controller/itinerary_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final inputController = TextEditingController();
  bool loading = false;
  String placeInfo = '';

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

  Future<void> fetchPlaceDetails(String query) async {
    setState(() {
      loading = true;
      placeInfo = '';
    });

    const apiKey = 'YOUR_GOOGLE_PLACES_API_KEY'; // Replace this
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final result = data['results'][0];
        setState(() {
          placeInfo = result['name'] +
              "\n" +
              (result['formatted_address'] ?? 'No address available');
        });
      } else {
        setState(() {
          placeInfo = 'No place details found.';
        });
      }
    } catch (e) {
      setState(() {
        placeInfo = 'Error fetching details: $e';
      });
    } finally {
      setState(() => loading = false);
    }
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
                TextField(
                  controller: inputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Type 'Patan', 'Thamel' or ask a place...",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black54,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: controller.handleInput,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final input = inputController.text.trim();
                    if (input.isNotEmpty) {
                      await fetchPlaceDetails(input);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 155, 100, 107),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Search Google Places"),
                ),
                const SizedBox(height: 10),
                if (placeInfo.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(placeInfo),
                  ),
                Expanded(
                  child: controller.filteredPOIs.isEmpty
                      ? const SizedBox.shrink()
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
