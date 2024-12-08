import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardRepository {
  final FirebaseFirestore _firestore;

  CardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addCard(String name, Color color, DateTime date, String hours, String frequency) async {
    await _firestore.collection('cards').add({
      'name': name,
      'color': '#${color.value.toRadixString(16)}',
      'date': date.toIso8601String(),
      'hours': hours,
      'frequency': frequency,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getCards() {
    return _firestore.collection('cards').orderBy('timestamp', descending: true).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'color': Color(int.parse(data['color'].substring(1), radix: 16)),
          'date': DateTime.parse(data['date']),
          'hours': data['hours'],
          'frequency': data['frequency'],
        };
      }).toList(),
    );
  }
}
