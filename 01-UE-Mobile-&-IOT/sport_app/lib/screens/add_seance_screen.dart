import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/seance.dart';

class AddSeanceScreen extends StatefulWidget {
  @override
  _AddSeanceScreenState createState() => _AddSeanceScreenState();
}

class _AddSeanceScreenState extends State<AddSeanceScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String _titre = '';
  int _duree = 0;
  double _distance = 0.0;
  int _difficulte = 5;
  String _commentaire = '';

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  _saveSeance() async {
    if (_formKey.currentState!.validate()) {
      Seance seance = Seance(
        date: _selectedDate,
        titre: _titre,
        duree: _duree,
        distance: _distance,
        difficulte: _difficulte,
        commentaire: _commentaire,
      );
      await DBHelper().insertSeance(seance);
      // Retourner à la page précédente immédiatement après l'opération asynchrone
      if (mounted) { // Vérifie si le widget est encore monté
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une séance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Sélection de la date
              ListTile(
                title: Text('Date : ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text('Heure : ${DateFormat('HH:mm').format(_selectedDate)}'),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              // Champ pour le titre
              TextFormField(
                decoration: InputDecoration(labelText: 'Titre'),
                onChanged: (value) {
                  _titre = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le titre est requis';
                  }
                  return null;
                },
              ),
              // Champ pour la durée
              TextFormField(
                decoration: InputDecoration(labelText: 'Durée (min)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _duree = int.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Entrez une durée valide';
                  }
                  return null;
                },
              ),
              // Champ pour la distance
              TextFormField(
                decoration: InputDecoration(labelText: 'Distance (km)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _distance = double.tryParse(value) ?? 0.0;
                },
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Entrez une distance valide';
                  }
                  return null;
                },
              ),
              // Slider pour la difficulté
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Difficulté : $_difficulte'),
                    Slider(
                      value: _difficulte.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _difficulte.toString(),
                      onChanged: (value) {
                        setState(() {
                          _difficulte = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Champ pour le commentaire
              TextFormField(
                decoration: InputDecoration(labelText: 'Commentaire'),
                onChanged: (value) {
                  _commentaire = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSeance,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
