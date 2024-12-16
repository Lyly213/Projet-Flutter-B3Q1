import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterb3q1/blocs/card/card_bloc.dart';
import 'package:flutterb3q1/blocs/card/card_event.dart';
import 'package:flutterb3q1/blocs/card/card_state.dart';
import 'package:flutterb3q1/repositories/card_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late Map<DateTime, String> _dayStatus;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int completedDaysCount = 0;

  @override
  void initState() {
    super.initState();
    _dayStatus = {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDayStatuses();
    });
  }

  void _loadDayStatuses() async {
    final cardRepository = RepositoryProvider.of<CardRepository>(context);
    final Map<DateTime, String> statuses = {};
    int completedDays = 0;

    for (int i = 0; i < 30; i++) {
      final day = DateTime.now().subtract(Duration(days: i));

      final totalTasks = await cardRepository.countTotalTasksForDay(day);
      final completedTasks = await cardRepository.countCompletedTasksForDay(day);

      if (totalTasks == 0) {
        statuses[day] = 'none';
      } else if (completedTasks == totalTasks) {
        statuses[day] = 'full';
        completedDays++; 
      } else {
        statuses[day] = 'empty'; 
      }
    }

    if (mounted) {
      setState(() {
        _dayStatus = statuses;
        completedDaysCount = completedDays;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider<CardBloc>(
      create: (context) => CardBloc(
        cardRepository: RepositoryProvider.of<CardRepository>(context),
      )..add(CountCompletedTasksEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFCE0),
          elevation: 0,
          title: Column(
            children: const [
              SizedBox(height: 4),
              Text(
                'Bonjour ! 😊',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 130, 176, 146),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          color: const Color(0xFFFFFCE0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Habit Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 130, 176, 146),
                  ),
                ),
                const SizedBox(height: 16),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 163, 253, 168),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 130, 176, 146),
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) {
                    if (_dayStatus.containsKey(day)) {
                      return [_dayStatus[day]!];
                    }
                    return [];
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return const SizedBox.shrink();
                      final status = events[0];

                      if (status == 'full') {
                        return _buildCircle(Color.fromARGB(255, 130, 176, 146), filled: true); 
                      } else if (status == 'empty') {
                        return _buildCircle(const Color.fromARGB(255, 185, 255, 153), filled: false);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Records',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 130, 176, 146),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 130, 176, 146),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'img/papillon.svg',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$completedDaysCount completed days',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 130, 176, 146),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: BlocBuilder<CardBloc, CardState>(
                          builder: (context, state) {
                            if (state is CardsLoading) {
                              return const CircularProgressIndicator();
                            } else if (state is CompletedTasksCounted) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'img/trèfle.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${state.count} completed tasks',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            } else if (state is CardsError) {
                              return const Text(
                                'Error loading tasks',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              );
                            }
                            return const Text(
                              'No data available',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(Color color, {required bool filled}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        border: Border.all(color: color, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }
}