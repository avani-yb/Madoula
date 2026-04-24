import 'package:flutter/material.dart';
import 'screens/accueil_screen.dart'; // on importe notre écran d'accueil

void main() {
  runApp(const MadoulaApp());
}

class MadoulaApp extends StatelessWidget {
  const MadoulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ── Informations de l'app ──────────────────────────────────────
      title: 'Madoula',
      debugShowCheckedModeBanner: false, // enlève le bandeau "DEBUG" en haut

      // ── Thème global vert pour toute l'app ────────────────────────
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2E7D32)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),

      // ── Écran de démarrage : l'accueil Madoula ────────────────────
      home: AccueilScreen(),
    );
  }
}