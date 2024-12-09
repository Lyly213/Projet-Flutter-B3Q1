import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardRepository {
  final FirebaseFirestore _firestore;

  CardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addCard(String name, Color color, DateTime date, String hours, String frequency) async {
    try {
      print("Adding card to firebase : $name, $color, $date, $hours, $frequency");
      await _firestore.collection('cards').add({
        'name': name,
        'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
        'date': date.toIso8601String(),
        'hours': hours,
        'frequency': frequency,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Card added successfully.");
    } catch (e) {
      print("Error adding card: $e");
      throw Exception('Failed to add card: $e');
    }
  }


  Stream<List<Map<String, dynamic>>> getCards() {
    return _firestore.collection('cards').snapshots().map((snapshot) {
      print("Snapshot received: ${snapshot.docs.length} documents");
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print("Processing card: $data");
        return {
          'id': doc.id,
          'name': data['name'],
          'color': Color(int.parse(data['color'].substring(1), radix: 16)),
          'date': DateTime.parse(data['date']),
          'hours': data['hours'],
          'frequency': data['frequency'],
        };
      }).toList();
    });
  }


  Future<void> deleteCard(String id) async {
    await _firestore.collection('cards').doc(id).delete();
  }

  Future<void> updateCard(String id, String name, Color color, DateTime date, String hours, String frequency) async {
    await _firestore.collection('cards').doc(id).update({
      'name': name,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
      'date': date.toIso8601String(),
      'hours': hours,
      'frequency': frequency,
    });
  }
}