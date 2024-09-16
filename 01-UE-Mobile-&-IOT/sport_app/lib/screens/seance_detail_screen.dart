import 'package:flutter/material.dart';
import '../models/seance.dart'; // Assure-toi que le chemin est correct
import 'package:intl/intl.dart';

class SeanceDetailScreen extends StatelessWidget {
  final Seance seance;

  SeanceDetailScreen({required this.seance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(seance.titre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Date: ${DateFormat('dd/MM/yyyy').format(seance.date)}', style: TextStyle(fontSize: 16)),
            Text('Heure: ${DateFormat('HH:mm').format(seance.date)}', style: TextStyle(fontSize: 16)),
            Text('Durée: ${seance.duree} min', style: TextStyle(fontSize: 16)),
            Text('Distance: ${seance.distance} km', style: TextStyle(fontSize: 16)),
            Text('Difficulté: ${seance.difficulte}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Commentaire:', style: TextStyle(fontSize: 16)),
            Text(seance.commentaire, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
