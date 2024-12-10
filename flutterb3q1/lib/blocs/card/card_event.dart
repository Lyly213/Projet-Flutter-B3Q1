import 'package:flutter/material.dart';

abstract class CardEvent {}

class AddCardEvent extends CardEvent {
  final String name;
  final Color color;
  final DateTime date;
  final String hours;
  final String frequency;

  AddCardEvent({
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
  final String id;
  final String name;
  final String? originalName;
  final Color color;
  final DateTime date;
  final String hours;
  final String frequency;
  final String originalFrequency;

  UpdateCardEvent({
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

class DeleteCardEvent extends CardEvent {
  final String id;

  DeleteCardEvent({required this.id});
}

class LoadCardsEvent extends CardEvent {}