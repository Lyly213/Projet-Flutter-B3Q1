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