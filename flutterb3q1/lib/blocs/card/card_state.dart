// Represents various card management states (loading, successful data retrieval, error handling and task completion countdown) 
// These states are issued by the CardBloc according to the events triggered.
abstract class CardState {}

class CardsLoading extends CardState {}

class CardsLoaded extends CardState {
  final List<Map<String, dynamic>> cards;

  CardsLoaded(this.cards);
}

class CardsError extends CardState {
  final String error;

  CardsError(this.error);
}

class CompletedTasksCounted extends CardState {
  final int count;

  CompletedTasksCounted({required this.count});
}