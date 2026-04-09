import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'apercu_screen.dart'; // on importera l'écran 2

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  _AccueilScreenState createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  // ── Variables d'état ──────────────────────────────────────────────
  String langueChoisie = 'FR'; // langue sélectionnée par défaut
  final ImagePicker _picker = ImagePicker(); // outil pour ouvrir caméra/galerie

  // ── Méthode : ouvrir la caméra ────────────────────────────────────
  Future<void> prendrePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera, // ouvre la caméra
      imageQuality: 85,           // qualité 85% (bon équilibre taille/qualité)
    );

    if (photo != null) {
      // Si une photo a bien été prise, on navigue vers l'écran 2
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApercuScreen(
            imageFile: File(photo.path),  // on envoie le fichier photo
            langue: langueChoisie,        // on envoie la langue choisie
          ),
        ),
      );
    }
  }

  // ── Méthode : ouvrir la galerie ───────────────────────────────────
  Future<void> choisirDepuisGalerie() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery, // ouvre la galerie
      imageQuality: 85,
    );

    if (photo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApercuScreen(
            imageFile: File(photo.path),
            langue: langueChoisie,
          ),
        ),
      );
    }
  }

  // ── Construction de l'interface ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ── Barre du haut ──────────────────────────────────────────────
      appBar: AppBar(
        title: Text(
          '🌿 Madoula',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2E7D32), // vert foncé
        elevation: 0,
      ),

      // ── Corps de l'écran ───────────────────────────────────────────
      backgroundColor: Color(0xFFF1F8E9), // fond vert très pâle

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ── Logo / Icône de l'app ────────────────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.eco,         // icône feuille
                  size: 70,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 20),

              // ── Titre principal ──────────────────────────────────────
              Text(
                'Madoula',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),

              SizedBox(height: 8),

              // ── Sous-titre ───────────────────────────────────────────
              Text(
                'Détection de maladies agricoles',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48),

              // ── Bouton principal : Prendre une photo ─────────────────
              SizedBox(
                width: double.infinity, // bouton pleine largeur
                child: ElevatedButton.icon(
                  onPressed: prendrePhoto,
                  icon: Icon(Icons.camera_alt, size: 24),
                  label: Text(
                    'Prendre une photo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                ),
              ),

              SizedBox(height: 14),

              // ── Bouton secondaire : Choisir depuis la galerie ─────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: choisirDepuisGalerie,
                  icon: Icon(Icons.photo_library, size: 24),
                  label: Text(
                    'Choisir depuis la galerie',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF2E7D32),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Color(0xFF2E7D32), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 48),

              // ── Sélecteur de langue ───────────────────────────────────
              Text(
                'Choisir la langue',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _boutonLangue('FR', 'Français'),
                  SizedBox(width: 10),
                  _boutonLangue('EWO', 'Ewondo'),
                  SizedBox(width: 10),
                  _boutonLangue('FUL', 'Fulfulde'),
                ],
              ),

              SizedBox(height: 40),

              // ── Mention bas de page ───────────────────────────────────
              Text(
                'IAI Cameroun • 2025',
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widget réutilisable : bouton de langue ────────────────────────
  Widget _boutonLangue(String code, String label) {
    bool estSelectionne = langueChoisie == code;

    return GestureDetector(
      onTap: () {
        setState(() {
          langueChoisie = code; // met à jour la langue choisie
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: estSelectionne ? Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFF2E7D32),
            width: 1.5,
          ),
          boxShadow: estSelectionne
              ? [BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 8)]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: estSelectionne ? Colors.white : Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}