import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonjour !'),
        centerTitle: true, // Place le texte au centre
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne le contenu à gauche
          children: [
            const Text(
              'Habit Statistics',
              style: TextStyle(
                fontSize: 20, // Taille légèrement plus petite
                fontWeight: FontWeight.bold,
              ),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                // Gérer la sélection d'une date
              },
            ),
            const SizedBox(height: 20), // Espace entre le calendrier et le titre
            const Text(
              'Records',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Espace entre le titre et les carrés
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: const Color.fromARGB(255, 142, 255, 148),
                    alignment: Alignment.center,
                    child: const Text(
                      '1 day series',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Espace entre les deux carrés
                Expanded(
                  child: Container(
                    height: 100,
                    color: const Color.fromARGB(255, 67, 255, 15),
                    alignment: Alignment.center,
                    child: const Text(
                      '90 completed tasks',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
