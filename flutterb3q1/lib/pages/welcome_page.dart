import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterb3q1/blocs/card/card_bloc.dart';
import 'package:flutterb3q1/blocs/card/card_event.dart';
import 'package:flutterb3q1/blocs/card/card_state.dart';
import 'add_page.dart';
import 'edit_page.dart'; // Assurez-vous d'importer EditPage
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
  int _selectedDayIndex = 3;
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
            child: BlocBuilder<CardBloc, CardState>(
              builder: (context, state) {
                if (state is CardsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CardsLoaded) {
                  final cards = state.cards;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
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
                                  color: result['color'],
                                  date: result['date'],
                                  hours: result['hours'],
                                  frequency: result['frequency'],
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
                } else if (state is CardsError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const SizedBox.shrink();
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

                if (result != null && result is Map<String, dynamic>) {
                  context.read<CardBloc>().add(
                        AddCardEvent(
                          name: result['name'],
                          color: result['color'],
                          date: result['date'],
                          hours: result['hours'],
                          frequency: result['frequency'],
                        ),
                      );
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