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
  final String userId;
  final String title;

  const MyHomePage({super.key, required this.title, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardBloc(cardRepository: CardRepository())..add(LoadCardsEvent(userId: userId)),
      child: MyHomePageContent(title: title, userId: userId),
    );
  }
}

class MyHomePageContent extends StatefulWidget {
  const MyHomePageContent({super.key, required this.title, required this.userId});

  final String title;
  final String userId;

  @override
  State<MyHomePageContent> createState() => _MyHomePageContentState();
}

class _MyHomePageContentState extends State<MyHomePageContent> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // ignore: unused_field
  int _completedTasksCount = 0;
  // ignore: unused_field
  int _totalTasksCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _updateCompletedTasksCount(widget.userId, _selectedDay!);
  }

  void _updateCompletedTasksCount(String userId, DateTime day) async {
    final cardRepository = RepositoryProvider.of<CardRepository>(context);
    final count = await cardRepository.countCompletedTasksForDay(userId, day);
    final total = await cardRepository.countTotalTasksForDay(userId, day);
    setState(() {
      _completedTasksCount = count;
      _totalTasksCount = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 176, 146),
        title: Text(
          _getDayTitle(),
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFFCE0),
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
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Card(
                              color: card['color'] ?? const Color.fromARGB(255, 130, 176, 146),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Checkbox(
                                  tristate: true, // Pour dire que le checkbox peut être null
                                  value: card['isFinished'] ?? false, // la mettre à false si elle est null
                                  onChanged: (bool? value) {
                                    setState(() {
                                      card['isFinished'] = value ?? false;
                                    });
                                    context.read<CardBloc>().add(UpdateCardStatusEvent(
                                      userId: widget.userId,
                                      id: card['id'],
                                      isFinished: value ?? false,
                                    ));
                                  },
                                ),
                                title: Text(
                                  card['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: card['isFinished'] == true
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: card['hours'] != null
                                    ? Text(
                                        card['hours'],
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      )
                                    : null,
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
                                        userId: widget.userId,
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
                                      context.read<CardBloc>().add(DeleteCardEvent(userId: widget.userId, id: result['id'], originalName: result['originalName'], originalFrequency: result['originalFrequency']));
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
              backgroundColor: const Color.fromARGB(255, 130, 176, 146),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsPage(userId: widget.userId)),
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
              backgroundColor: const Color.fromARGB(255, 130, 176, 146),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPage()),
                );

                if (result != null && result is List<Map<String, dynamic>>) {
                  for (var card in result) {
                    context.read<CardBloc>().add(
                      AddCardEvent(
                        userId: widget.userId,
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
          icon: const Icon(Icons.arrow_left, size: 28, color: Color.fromARGB(255, 130, 176, 146)),
          onPressed: () {
            setState(() {
              _focusedDay = _focusedDay.subtract(const Duration(days: 7));
              _updateCompletedTasksCount(widget.userId, _focusedDay);
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
                    _updateCompletedTasksCount(widget.userId, day);
                  });
                },
                child: Column(
                  children: [
                    Text(
                      _getDayName(day),
                      style: TextStyle(
                        color: isSelected
                            ? const Color.fromARGB(255, 130, 176, 146)
                            : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isSelected
                          ? const Color.fromARGB(255, 130, 176, 146)
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
          icon: const Icon(Icons.arrow_right, size: 28, color: Color(0xFFA6CDB6)),
          onPressed: () {
            setState(() {
              _focusedDay = _focusedDay.add(const Duration(days: 7));
              _updateCompletedTasksCount(widget.userId, _focusedDay);
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