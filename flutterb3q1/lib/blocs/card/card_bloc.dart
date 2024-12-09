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
        final cardStream = cardRepository.getCards();
        await emit.forEach(cardStream, onData: (cards) => CardsLoaded(cards));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    on<AddCardEvent>((event, emit) async {
      try {
        print("Event received: Adding card -> ${event.name}");
        await cardRepository.addCard(
          event.name,
          event.color,
          event.date,
          event.hours,
          event.frequency,
        );
        print("Event processed: Card added");
        add(LoadCardsEvent());
      } catch (e) {
        print("Error in AddCardEvent: $e");
        emit(CardsError(e.toString()));
      }
    });


    on<DeleteCardEvent>((event, emit) async {
      try {
        await cardRepository.deleteCard(event.id);
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    on<UpdateCardEvent>((event, emit) async {
      try {
        await cardRepository.updateCard(
          event.id,
          event.name,
          event.color,
          event.date,
          event.hours,
          event.frequency,
        );
        add(LoadCardsEvent());
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });
  }
}