import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'add_page.dart';
import 'statistics_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Initialisation de la sélection du jour (par défaut : jeudi)
  int _selectedDayIndex = 3;

  // Liste des jours de la semaine
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final List<Map<String, dynamic>> _cards = [];
  void addCard(String name, Color color) {
    setState(() {
      _cards.add({'name': name, 'color': color});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 173, 255, 159),
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Barre des jours de la semaine
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_days.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Afficher les initiales des jours
                      Text(
                        _days[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedDayIndex == index
                              ? const Color.fromARGB(255, 0, 115, 35)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Afficher le cercle pour le numéro du jour
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: _selectedDayIndex == index
                            ? const Color.fromARGB(255, 0, 115, 35)
                            : Colors.grey[300],
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedDayIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          // Contenu principal
          Expanded(
            child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return Card(
                  color: card['color'],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
                    ),
                    title: Text(
                      card['name'],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsPage()),
                );
              },
              tooltip: 'Go to Another Page',
              child: SvgPicture.asset(
                'img/statistics.svg',
                height: 24,
                width: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPage()),
                );

                if(result != null && result is Map<String, dynamic>) {
                  addCard(result['name'], result['color']);
                }
              },
              tooltip: 'Go to Add Page',
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
