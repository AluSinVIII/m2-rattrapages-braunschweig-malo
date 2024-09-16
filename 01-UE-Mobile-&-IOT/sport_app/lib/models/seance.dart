class Seance {
  int? id;
  DateTime date;
  String titre;
  int duree; // minutes
  double distance; // km
  int difficulte; // 1 à 10
  String commentaire;

  Seance({
    this.id,
    required this.date,
    required this.titre,
    required this.duree,
    required this.distance,
    required this.difficulte,
    required this.commentaire,
  });

  // Convertir une séance en Map pour insertion dans la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'titre': titre,
      'duree': duree,
      'distance': distance,
      'difficulte': difficulte,
      'commentaire': commentaire,
    };
  }

  // Créer une instance de Seance depuis un Map (récupération de la base)
  factory Seance.fromMap(Map<String, dynamic> map) {
    return Seance(
      id: map['id'],
      date: DateTime.parse(map['date']),
      titre: map['titre'],
      duree: map['duree'],
      distance: map['distance'],
      difficulte: map['difficulte'],
      commentaire: map['commentaire'],
    );
  }
}
