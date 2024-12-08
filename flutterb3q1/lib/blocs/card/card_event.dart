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

class LoadCardsEvent extends CardEvent {}