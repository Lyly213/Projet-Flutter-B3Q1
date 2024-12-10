import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterb3q1/blocs/card/card_bloc.dart';
import 'package:flutterb3q1/blocs/card/card_event.dart';
import 'package:flutterb3q1/blocs/card/card_state.dart';
import 'package:flutterb3q1/pages/edit_page.dart';
import 'add_page.dart';
import 'statistics_page.dart';
import '../repositories/card_repository.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardBloc(cardRepository: CardRepository())..add(LoadCardsEvent()),
      child: MyHomePageContent(title: title),
    );
  }
}

class MyHomePageContent extends StatefulWidget {
  const MyHomePageContent({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageContent> createState() => _MyHomePageContentState();
}

class _MyHomePageContentState extends State<MyHomePageContent> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 115, 35),
        title: Text(
          _getDayTitle(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5DC),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _buildWeekCalendar(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<CardBloc, CardState>(
                builder: (context, state) {
                  if (state is CardsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CardsLoaded) {
                    final selectedDate = _selectedDay!;
                    final filteredCards = state.cards.where((card) {
                      final cardDate = card['date'] as DateTime;
                      return cardDate.year == selectedDate.year &&
                          cardDate.month == selectedDate.month &&
                          cardDate.day == selectedDate.day;
                    }).toList();

                    if (filteredCards.isEmpty) {
                      return const Center(
                        child: Text('No cards for this day.'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: filteredCards.length,
                      itemBuilder: (context, index) {
                        final card = filteredCards[index];
                        bool isChecked = false;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Card(
                              color: card['color'],
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value ?? false;
                                    });
                                  },
                                ),
                                title: Text(
                                  card['name'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        id: card['id'],
                                        name: card['name'],
                                        color: card['color'],
                                        date: card['date'],
                                        hours: card['hours'],
                                        frequency: card['frequency'],
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    if (result['action'] == 'update') {
                                      context.read<CardBloc>().add(UpdateCardEvent(
                                        id: result['id'],
                                        name: result['name'],
                                        originalName: result['originalName'],
                                        color: result['color'],
                                        date: result['date'],
                                        hours: result['hours'],
                                        frequency: result['frequency'],
                                        originalFrequency: result['originalFrequency'],
                                      ));
                                    } else if (result['action'] == 'delete') {
                                      context.read<CardBloc>().add(DeleteCardEvent(id: result['id']));
                                    }
                                  }

                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is CardsError) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              heroTag: "statisticsPageBtn",
              backgroundColor: const Color.fromARGB(255, 0, 115, 35),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsPage()),
                );
              },
              tooltip: 'Go to Statistics Page',
              child: SvgPicture.asset(
                'img/statistics.svg',
                height: 24,
                width: 24,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: FloatingActionButton(
              heroTag: "addPageBtn",
              backgroundColor: const Color.fromARGB(255, 0, 115, 35),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPage()),
                );

                if (result != null && result is List<Map<String, dynamic>>) {
                  debugPrint("Received cards from AddPage: $result"); // Journal pour vérifier les données
                  for (var card in result) {
                    context.read<CardBloc>().add(
                      AddCardEvent(
                        name: card['name'],
                        color: card['color'],
                        date: DateTime.parse(card['date']),
                        hours: card['hours'],
                        frequency: card['frequency'],
                      ),
                    );
                  }
                }
              },
              tooltip: 'Go to Add Page',
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayTitle() {
    if (_selectedDay == null) return 'Today';

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selectedDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

    final difference = selectedDate.difference(todayDate).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';

    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = monthNames[selectedDate.month - 1];
    final day = selectedDate.day;
    final year = selectedDate.year;

    return '$month $day, $year';
  }



  Widget _buildWeekCalendar() {
    final daysOfWeek = List.generate(7, (index) {
      final day = _focusedDay.add(Duration(days: index - _focusedDay.weekday + 1));
      return day;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left, size: 28, color: Color.fromARGB(255, 0, 115, 35)),
          onPressed: () {
            setState(() {
              _focusedDay = _focusedDay.subtract(const Duration(days: 7));
            });
          },
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek.map((day) {
              final isSelected = _selectedDay?.difference(day).inDays == 0;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      _getDayName(day),
                      style: TextStyle(
                        color: isSelected
                            ? const Color.fromARGB(255, 0, 115, 35)
                            : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isSelected
                          ? const Color.fromARGB(255, 0, 115, 35)
                          : Colors.grey[300],
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, size: 28, color: Color.fromARGB(255, 0, 115, 35)),
          onPressed: () {
            setState(() {
              _focusedDay = _focusedDay.add(const Duration(days: 7));
            });
          },
        ),
      ],
    );
  }

  String _getDayName(DateTime day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day.weekday - 1];
  }
}