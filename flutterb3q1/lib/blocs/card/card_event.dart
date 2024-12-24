import 'package:flutter/material.dart';

//These events are used to trigger state changes in the CardBloc.
//(loading, adding, updating, deleting and the counting of completed tasks)
abstract class CardEvent {}

class LoadCardsEvent extends CardEvent {
  final String userId;

  LoadCardsEvent({required this.userId});
}

class AddCardEvent extends CardEvent {
  final String userId;
  final String name;
  final Color color;
  final DateTime date;
  final String hours;
  final String frequency;

  AddCardEvent({
    required this.userId,
    required this.name, 
    required this.color,
    required this.date,
    required this.hours,
    required this.frequency,
  });
}

class AddCardsEvent extends CardEvent {
  final List<Map<String, dynamic>> cards;

  AddCardsEvent({required this.cards});
}

class UpdateCardEvent extends CardEvent {
  final String userId;
  final String id;
  final String name;
  final String? originalName;
  final Color color;
  final DateTime date;
  final String hours;
  final String frequency;
  final String originalFrequency;

  UpdateCardEvent({
    required this.userId,
    required this.id,
    required this.name,
    this.originalName,
    required this.color,
    required this.date,
    required this.hours,
    required this.frequency,
    required this.originalFrequency,
  });
}

class CountCompletedTasksEvent extends CardEvent {
  final String userId;

  CountCompletedTasksEvent({required this.userId});
}

class DeleteCardEvent extends CardEvent {
  final String userId;
  final String id;
  final String originalName;
  final String originalFrequency;

  DeleteCardEvent({
    required this.userId,
    required this.id,
    required this.originalName,
    required this.originalFrequency,
    });

}

class UpdateCardStatusEvent extends CardEvent {
  final String userId;
  final String id;
  final bool isFinished;

  UpdateCardStatusEvent({
    required this.userId,
    required this.id, 
    required this.isFinished
  });
}