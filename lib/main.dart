import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleThemeMode(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loli Characters',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      themeMode: _themeMode,
      home: LoliListScreen(
        onThemeToggle: _toggleThemeMode,
        themeMode: _themeMode,
      ),
    );
  }
}

class Loli {
  final String name;
  final String info;
  final String imagePath;
  final String description;
  bool isFavorite;

  Loli({
    required this.name,
    required this.info,
    required this.imagePath,
    required this.description,
    this.isFavorite = false,
  });
}

final List<Loli> lolis = [
  Loli(
    name: 'Loli 1',
    info: 'Cute and cheerful',
    imagePath: 'assets/a.jpg',
    description: 'Loli 1 is known for her cheerful personality and loves adventures.',
  ),
  Loli(
    name: 'Loli 2',
    info: 'Mischievous and playful',
    imagePath: 'assets/j.jpg',
    description: 'Loli 2 is always up to some mischief but has a kind heart.',
  ),
  Loli(
    name: 'Loli 3',
    info: 'Smart and bookish',
    imagePath: 'assets/s.jpg',
    description: 'Loli 3 is a bookworm who enjoys quiet time in the library.',
  ),
  Loli(
    name: 'Loli 4',
    info: 'Shy and reserved',
    imagePath: 'assets/y.jpg',
    description: 'Loli 4 is shy but very sweet once you get to know her.',
  ),
  Loli(
    name: 'Loli 5',
    info: 'Energetic and bubbly',
    imagePath: 'assets/loli5.png',
    description: 'Loli 5 is full of energy and always spreading positive vibes.',
  ),
];

class LoliListScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final ThemeMode themeMode;

  LoliListScreen({
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  _LoliListScreenState createState() => _LoliListScreenState();
}

class _LoliListScreenState extends State<LoliListScreen> {
  List<Loli> filteredLolis = lolis;
  List<Loli> favoriteLolis = [];
  String selectedCategory = 'All';
  String searchQuery = '';

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredLolis = lolis.where((loli) =>
      loli.name.toLowerCase().contains(query.toLowerCase()) ||
          loli.info.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      filteredLolis = lolis.where((loli) =>
      category == 'All' ||
          loli.info.toLowerCase().contains(category.toLowerCase())).toList();
    });
  }

  void _toggleFavorite(Loli loli) {
    setState(() {
      loli.isFavorite = !loli.isFavorite;
      if (loli.isFavorite) {
        favoriteLolis.add(loli);
      } else {
        favoriteLolis.remove(loli);
      }
    });
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoliListScreen(
            onThemeToggle: widget.onThemeToggle,
            themeMode: widget.themeMode,
          )),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesScreen(
              favoriteLolis: favoriteLolis,
              onThemeToggle: widget.onThemeToggle,
              themeMode: widget.themeMode,
            ),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsScreen(
              onThemeToggle: widget.onThemeToggle,
              themeMode: widget.themeMode,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Lolis'),
        backgroundColor: widget.themeMode == ThemeMode.dark ? Colors.black : Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(onSearch: _onSearch),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryTab('All', 'All'),
                _buildCategoryTab('Cute', 'Cute'),
                _buildCategoryTab('Smart', 'Smart'),
                _buildCategoryTab('Playful', 'Playful'),
                _buildCategoryTab('Shy', 'Shy'),
                _buildCategoryTab('Energetic', 'Energetic'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredLolis.length,
              itemBuilder: (context, index) {
                return _buildLoliCard(context, filteredLolis[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: widget.themeMode == ThemeMode.dark ? Colors.black : Colors.pink,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.white),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: 'Settings',
          ),
        ],
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildCategoryTab(String category, String filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: GestureDetector(
        onTap: () => _onCategorySelected(filter),
        child: Text(
          category,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoliCard(BuildContext context, Loli loli) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoliDetailScreen(
              loli: loli,
              lolis: filteredLolis,
              onThemeToggle: widget.onThemeToggle,
              themeMode: widget.themeMode,
            ),
          ),
        );
      },
      child: Card(
        color: widget.themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                loli.imagePath,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loli.name,
                    style: TextStyle(
                      color: widget.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    loli.info,
                    style: TextStyle(
                      color: widget.themeMode == ThemeMode.dark ? Colors.grey : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          loli.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.pink,
                        ),
                        onPressed: () => _toggleFavorite(loli),
                      ),
                      IconButton(
                        icon: Icon(Icons.info, color: Colors.pink),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoliDetailScreen(
                                loli: loli,
                                lolis: filteredLolis,
                                onThemeToggle: widget.onThemeToggle,
                                themeMode: widget.themeMode,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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

class LoliDetailScreen extends StatelessWidget {
  final Loli loli;
  final List<Loli> lolis;
  final Function(bool) onThemeToggle;
  final ThemeMode themeMode;

  LoliDetailScreen({
    required this.loli,
    required this.lolis,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    int currentIndex = lolis.indexOf(loli);
    int nextIndex = (currentIndex + 1) % lolis.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(loli.name),
        backgroundColor: themeMode == ThemeMode.dark ? Colors.black : Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(loli.imagePath),
            SizedBox(height: 20),
            Text(
              loli.description,
              style: TextStyle(
                color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                fontSize: 18,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Back'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoliDetailScreen(
                          loli: lolis[nextIndex],
                          lolis: lolis,
                          onThemeToggle: onThemeToggle,
                          themeMode: themeMode,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;

  CustomSearchDelegate({required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container(); // The results will be displayed in the main screen
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = lolis.where((loli) {
      return loli.name.toLowerCase().contains(query.toLowerCase()) ||
          loli.info.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final loli = suggestions[index];
        return ListTile(
          leading: Image.asset(loli.imagePath, width: 50, height: 50),
          title: Text(loli.name),
          subtitle: Text(loli.info),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoliDetailScreen(
                  loli: loli,
                  lolis: lolis,
                  onThemeToggle: (isDark) {},
                  themeMode: ThemeMode.light,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Loli> favoriteLolis;
  final Function(bool) onThemeToggle;
  final ThemeMode themeMode;

  FavoritesScreen({
    required this.favoriteLolis,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: themeMode == ThemeMode.dark ? Colors.black : Colors.pink,
      ),
      body: ListView.builder(
        itemCount: favoriteLolis.length,
        itemBuilder: (context, index) {
          final loli = favoriteLolis[index];
          return ListTile(
            leading: Image.asset(loli.imagePath, width: 50, height: 50),
            title: Text(loli.name),
            subtitle: Text(loli.info),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoliDetailScreen(
                    loli: loli,
                    lolis: favoriteLolis,
                    onThemeToggle: onThemeToggle,
                    themeMode: themeMode,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final Function(bool) onThemeToggle;
  final ThemeMode themeMode;

  SettingsScreen({
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: themeMode == ThemeMode.dark ? Colors.black : Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'App Settings',
              style: TextStyle(
                fontSize: 24,
                color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                ),
              ),
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                onThemeToggle(value);
                Navigator.pop(context); // Return to home screen after toggling theme
              },
            ),
          ],
        ),
      ),
    );
  }
}

