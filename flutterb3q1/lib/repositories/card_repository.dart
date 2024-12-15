import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardRepository {
  final FirebaseFirestore _firestore;

  CardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  //new card in the database (firebase)
  Future<void> addCard(String name, Color color, DateTime date, String hours, String frequency) async {
    await _firestore.collection('cards').add({
      'name': name,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
      'date': date.toIso8601String(),
      'hours': hours,
      'frequency': frequency,
      'isFinished': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  //get all cards from the database (firebase), and map them to a list of maps
  Stream<List<Map<String, dynamic>>> getCards() {
    return _firestore.collection('cards').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'color': Color(int.parse(data['color'].substring(1), radix: 16)),
          'date': DateTime.parse(data['date']),
          'hours': data['hours'],
          'frequency': data['frequency'],
          'isFinished': data['isFinished'],
        };
      }).toList();
    });
  }

  //delete a card base in the id
  Future<void> deleteCard(String id) async {
    await _firestore.collection('cards').doc(id).delete();
  }

  Future<void> updateCardStatus(String id, bool isFinished) async {
    await _firestore.collection('cards').doc(id).update({
      'isFinished': isFinished,
    });
  }

  Future<int> countCompletedTasks() async {
    final querySnapshot = await _firestore.collection('cards').where('isFinished', isEqualTo: true).get();
    return querySnapshot.docs.length;
  }

  //update the donnees of a card
  Future<void> updateCard(String id, String name, Color color, DateTime date, String hours, String frequency) async {
    await _firestore.collection('cards').doc(id).update({
      'name': name,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
      'date': date.toIso8601String(),
      'hours': hours,
      'frequency': frequency,
    });
  }

  //delete all cards with the same name and frequency
  Future<void> deleteOtherCards(String id, String name, String frequency) async {
    final querySnapshot = await _firestore
        .collection('cards')
        .where('name', isEqualTo: name)
        .where('frequency', isEqualTo: frequency)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.id != id) {
        await _firestore.collection('cards').doc(doc.id).delete();
      }
    }
  }

  //update all cards with the same name and frequency
  Future<void> updateAllCardsByName(String originalName, String newName, Color color, String hours, String frequency) async {
    final querySnapshot = await _firestore
        .collection('cards')
        .where('name', isEqualTo: originalName)
        .get();

    for (var doc in querySnapshot.docs) {
      await _firestore.collection('cards').doc(doc.id).update({
        'name': newName,
        'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
        'hours': hours,
        'frequency': frequency,
        });
      }
  }
}