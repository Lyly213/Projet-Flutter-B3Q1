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
        await cardRepository.addCard(
          event.name, 
          event.color,
          event.date,
          event.hours,
          event.frequency,
        );
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });
  }
}