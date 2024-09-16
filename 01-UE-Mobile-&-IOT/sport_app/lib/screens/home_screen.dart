import 'package:flutter/material.dart';
import 'add_seance_screen.dart';
import 'package:intl/intl.dart';
import 'seance_detail_screen.dart';
import '../db/db_helper.dart';
import '../models/seance.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Seance>> _seances;

  @override
  void initState() {
    super.initState();
    _seances = DBHelper().getSeances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSeanceScreen()),
                );
              },
              child: Text('Ajouter une séance'),
            ),
            Expanded(
              child: FutureBuilder<List<Seance>>(
                future: _seances,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune séance enregistrée'));
                  } else {
                    final seances = snapshot.data!;
                    return ListView.builder(
                      itemCount: seances.length,
                      itemBuilder: (context, index) {
                        final seance = seances[index];
                        return ListTile(
                          title: Text(seance.titre),
                          subtitle: Text(
                            '${DateFormat('dd/MM/yyyy').format(seance.date)} - ${seance.duree} min - ${seance.distance} km',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeanceDetailScreen(seance: seance),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
