import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardRepository {
  final FirebaseFirestore _firestore;

  CardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  //new card in the database (firebase)
  Future<void> addCard(String userId, String name, Color color, DateTime date, String hours, String frequency) async {
    await _firestore.collection('users').doc(userId).collection('cards').add({
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
  Stream<List<Map<String, dynamic>>> getCards(String userId) {
    return _firestore.collection('users').doc(userId).collection('cards').snapshots().map((snapshot) {
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
  Future<void> deleteCard(String userId, String id) async {
    await _firestore.collection('users').doc(userId).collection('cards').doc(id).delete();
  }

  Future<void> updateCardStatus(String userId, String id, bool isFinished) async {
    await _firestore.collection('users').doc(userId).collection('cards').doc(id).update({
      'isFinished': isFinished,
    });
  }

  Future<int> countCompletedTasks(String userId) async {
    final querySnapshot = await _firestore.collection('users').doc(userId).collection('cards').where('isFinished', isEqualTo: true).get();
    return querySnapshot.docs.length;
  }

  Future<int> countCompletedTasksForDay(String userId, DateTime day) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(Duration(days: 1));
    final querySnapshot = await _firestore.collection('users').doc(userId).collection('cards')
      .where('isFinished', isEqualTo: true)
      .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
      .where('date', isLessThan: endOfDay.toIso8601String())
      .get();
    return querySnapshot.docs.length;
  }

  Future<int> countTotalTasksForDay(String userId, DateTime day) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(Duration(days: 1));
    final querySnapshot = await _firestore.collection('users').doc(userId).collection('cards')
      .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
      .where('date', isLessThan: endOfDay.toIso8601String())
      .get();
    return querySnapshot.docs.length;
  }

  //update the donnees of a card
  Future<void> updateCard(String userId, String id, String name, Color color, DateTime date, String hours, String frequency) async {
    await _firestore.collection('users').doc(userId).collection('cards').doc(id).update({
      'name': name,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
      'date': date.toIso8601String(),
      'hours': hours,
      'frequency': frequency,
    });
  }

  //delete all cards with the same name and frequency
  Future<void> deleteOtherCards(String userId, String id, String name, String frequency) async {
    final querySnapshot = await _firestore
        .collection('users').doc(userId).collection('cards')
        .where('name', isEqualTo: name)
        .where('frequency', isEqualTo: frequency)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.id != id) {
        await _firestore.collection('users').doc(userId).collection('cards').doc(doc.id).delete();
      }
    }
  }

  //update all cards with the same name and frequency
  Future<void> updateAllCardsByName(String userId, String originalName, String newName, Color color, String hours, String frequency) async {
    final querySnapshot = await _firestore
        .collection('users').doc(userId).collection('cards')
        .where('name', isEqualTo: originalName)
        .get();

    for (var doc in querySnapshot.docs) {
      await _firestore.collection('users').doc(userId).collection('cards').doc(doc.id).update({
        'name': newName,
        'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
        'hours': hours,
        'frequency': frequency,
        });
      }
  }
}