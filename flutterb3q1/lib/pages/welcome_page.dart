import 'package:flutter/material.dart';
import 'add_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 252, 230, 152)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Today'),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
            child: Center(
              child: Text(
                'Selected Day: ${_days[_selectedDayIndex]}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
        },
        tooltip: 'Go to Add Page',
        child: const Icon(Icons.add),
      ),
    );
  }
}
