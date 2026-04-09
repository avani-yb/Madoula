import 'package:flutter/material.dart';
import 'dart:io';
import 'resultat_screen.dart'; // on importera l'écran 3

class ApercuScreen extends StatelessWidget {
  // ── Données reçues depuis l'écran Accueil ─────────────────────────
  final File imageFile;     // la photo capturée
  final String langue;      // la langue choisie

  const ApercuScreen({super.key, required this.imageFile, required this.langue});

  // ── Construction de l'interface ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ── Barre du haut ──────────────────────────────────────────────
      appBar: AppBar(
        title: Text(
          'Vérifier la photo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme: IconThemeData(color: Colors.white), // flèche retour blanche
        elevation: 0,
      ),

      backgroundColor: Color(0xFF1B5E20), // fond vert foncé pour le contraste photo

      body: Column(
        children: [

          // ── Zone photo ─────────────────────────────────────────────
          Expanded(
            flex: 3, // la photo prend 3/4 de l'écran
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,   // remplit bien le cadre
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // ── Zone des boutons ───────────────────────────────────────
          Expanded(
            flex: 1, // les boutons prennent 1/4 de l'écran
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [

                  // ── Question ───────────────────────────────────────
                  Text(
                    'La photo est-elle nette et bien cadrée ?',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16),

                  // ── Boutons côte à côte ────────────────────────────
                  Row(
                    children: [

                      // Bouton : Reprendre
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context); // retour à l'écran Accueil
                          },
                          icon: Icon(Icons.refresh, size: 20),
                          label: Text('Reprendre'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF2E7D32),
                            side: BorderSide(color: Color(0xFF2E7D32), width: 2),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // Bouton : Analyser
                      Expanded(
                        flex: 2, // bouton analyser plus large
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // On navigue vers l'écran Résultat
                            // en passant la photo ET la langue
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultatScreen(
                                  imageFile: imageFile,
                                  langue: langue,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.search, size: 20),
                          label: Text(
                            'Analyser',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}