import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterb3q1/repositories/card_repository.dart';
import 'card_event.dart';
import 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;

  CardBloc({required this.cardRepository}) : super(CardsLoading()) {
    on<LoadCardsEvent>((event, emit) async {
      emit(CardsLoading());
      try {
        final cardStream = cardRepository.getCards(event.userId);
        await emit.forEach(cardStream, onData: (cards) => CardsLoaded(cards));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    on<AddCardEvent>((event, emit) async {
      try {
        await cardRepository.addCard(
          event.userId,
          event.name,
          event.color,
          event.date,
          event.hours,
          event.frequency,
        );
        add(LoadCardsEvent(userId: event.userId));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    on<DeleteCardEvent>((event, emit) async {
      try {
          await cardRepository.deleteCard(event.userId, event.id);
          await cardRepository.deleteOtherCards(event.userId, event.id, event.originalName, event.originalFrequency);
          add(LoadCardsEvent(userId: event.userId));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    on<UpdateCardStatusEvent>((event, emit) async {
      try {
        await cardRepository.updateCardStatus(event.userId, event.id, event.isFinished);
        add(LoadCardsEvent(userId: event.userId));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    on<CountCompletedTasksEvent>((event, emit) async {
      try {
        final count = await cardRepository.countCompletedTasks(event.userId);
        emit(CompletedTasksCounted(count: count));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    on<UpdateCardEvent>((event, emit) async {
      try {
        final bool isNameChanged = event.name != event.originalName;
        final bool isFrequencyChanged = event.frequency != event.originalFrequency;

        if (event.frequency == 'none') {
          await cardRepository.deleteOtherCards(event.userId, event.id, event.originalName ?? event.name, event.originalFrequency);
        
        } else if (isFrequencyChanged) {
          List<Map<String, dynamic>> newCards = [];
          if (event.frequency == 'daily') {
            for (int i = 1; i <= 6; i++) {
              newCards.add({
                'name': event.name,
                'color': event.color,
                'date': event.date.add(Duration(days: i)).toIso8601String(),
                'hours': event.hours,
                'frequency': event.frequency,
              });
            }
          } else if (event.frequency == 'weekly') {
            for (int i = 1; i <= 3; i++) {
              newCards.add({
                'name': event.name,
                'color': event.color,
                'date': event.date.add(Duration(days: i * 7)).toIso8601String(),
                'hours': event.hours,
                'frequency': event.frequency,
              });
            }
          }
      
          await cardRepository.deleteOtherCards(event.userId, event.id, event.originalName ?? event.name, event.originalFrequency);

          for(var card in newCards) {
            await cardRepository.addCard(
              event.userId,
              card['name'],
              card['color'],
              DateTime.parse(card['date']),
              card['hours'],
              card['frequency'],
            );
          }
        } 
        
        if(isNameChanged) {
          await cardRepository.updateAllCardsByName(
            event.userId,
            event.originalName ?? event.name,
            event.name,
            event.color,
            event.hours,
            event.frequency,
          );
        }

        await cardRepository.updateCard(
          event.userId,
          event.id,
          event.name,
          event.color,
          event.date,
          event.hours,
          event.frequency,
        );

        add(LoadCardsEvent(userId: event.userId));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });
  }
}