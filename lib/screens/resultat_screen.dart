import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';       // pour lire les assets
import 'package:flutter_tts/flutter_tts.dart'; // synthèse vocale

class ResultatScreen extends StatefulWidget {
  final File imageFile;
  final String langue;

  const ResultatScreen({super.key, required this.imageFile, required this.langue});

  @override
  _ResultatScreenState createState() => _ResultatScreenState();
}

class _ResultatScreenState extends State<ResultatScreen> {

  // ── Variables d'état ──────────────────────────────────────────────
  bool isLoading = true;          // true pendant que l'IA analyse
  Map<String, dynamic>? maladie;  // données de la maladie trouvée
  String erreur = '';             // message d'erreur si besoin
  FlutterTts flutterTts = FlutterTts(); // moteur de synthèse vocale
  bool isReading = false;         // true pendant la lecture vocale

  // ── Au démarrage de l'écran ───────────────────────────────────────
  @override
  void initState() {
    super.initState();
    lancerAnalyse();
  }

  // ── Simulation de l'analyse IA ────────────────────────────────────
  // (Avany remplacera cette fonction par le vrai modèle TFLite)
  Future<void> lancerAnalyse() async {
    setState(() => isLoading = true);

    // Simulation : on attend 2 secondes (comme si l'IA analysait)
    await Future.delayed(Duration(seconds: 2));

    // On charge la base de données maladies depuis les assets
    try {
      String jsonString = await rootBundle.loadString('assets/maladies_madoula.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      List maladies = data['maladies'];

      // SIMULATION : on prend la première maladie comme résultat
      // Avany remplacera cette ligne par : int index = modeleIA.predire(imageFile);
      Map<String, dynamic> resultat = maladies[0];

      setState(() {
        maladie = resultat;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        erreur = 'Erreur lors de la lecture de la base de données.';
        isLoading = false;
      });
    }
  }

  // ── Récupérer le texte selon la langue choisie ────────────────────
  String getTexte(String champFr, String champEwo, String champFul) {
    switch (widget.langue) {
      case 'EWO': return maladie![champEwo] ?? maladie![champFr];
      case 'FUL': return maladie![champFul] ?? maladie![champFr];
      default:    return maladie![champFr];
    }
  }

  // ── Lire le diagnostic à voix haute ──────────────────────────────
  Future<void> lireVoixHaute() async {
    if (maladie == null) return;

    String nom = getTexte('nom_fr', 'nom_ewondo', 'nom_fulfulde');
    String desc = maladie!['description_fr'];
    String texteALire = 'Résultat : $nom. $desc';

    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setSpeechRate(0.45); // vitesse lente, plus claire

    setState(() => isReading = true);
    await flutterTts.speak(texteALire);
    setState(() => isReading = false);
  }

  // ── Couleur selon la gravité ──────────────────────────────────────
  Color getCouleurGravite() {
    if (maladie == null) return Colors.grey;
    int score = maladie!['gravite_score'] ?? 1;
    if (score >= 4) return Colors.red[700]!;
    if (score >= 3) return Colors.orange[700]!;
    if (score >= 2) return Colors.amber[700]!;
    return Colors.green[600]!;
  }

  // ── Icône selon la gravité ────────────────────────────────────────
  IconData getIconeGravite() {
    if (maladie == null) return Icons.help;
    int score = maladie!['gravite_score'] ?? 1;
    if (score >= 4) return Icons.dangerous;
    if (score >= 3) return Icons.warning;
    if (score >= 2) return Icons.info;
    return Icons.check_circle;
  }

  // ── Construction de l'interface ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ── Barre du haut ──────────────────────────────────────────────
      appBar: AppBar(
        title: Text(
          'Résultat du diagnostic',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      backgroundColor: Color(0xFFF1F8E9),

      body: isLoading
          ? _ecranChargement()   // pendant l'analyse
          : erreur.isNotEmpty
              ? _ecranErreur()   // si erreur
              : _ecranResultat(), // résultat normal
    );
  }

  // ── Écran de chargement ───────────────────────────────────────────
  Widget _ecranChargement() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF2E7D32),
            strokeWidth: 3,
          ),
          SizedBox(height: 24),
          Text(
            'Analyse en cours...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Le modèle IA examine la photo",
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // ── Écran d'erreur ────────────────────────────────────────────────
  Widget _ecranErreur() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(erreur, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.red[700])),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: lancerAnalyse,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2E7D32)),
              child: Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Écran résultat principal ──────────────────────────────────────
  Widget _ecranResultat() {
    String nomMaladie = getTexte('nom_fr', 'nom_ewondo', 'nom_fulfulde');
    List symptomes = maladie!['symptomes'] ?? [];
    List traitements = maladie!['traitements_locaux'] ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Carte principale : nom de la maladie ───────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
              ],
            ),
            child: Column(
              children: [
                // Icône gravité
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: getCouleurGravite().withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(getIconeGravite(), size: 40, color: getCouleurGravite()),
                ),
                SizedBox(height: 12),

                // Nom de la maladie
                Text(
                  nomMaladie,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Plante concernée
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🌱 ${maladie!['plante']}',
                    style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),

                // Niveau de gravité
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: getCouleurGravite().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Gravité : ${maladie!['gravite']}',
                    style: TextStyle(
                      color: getCouleurGravite(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Description
                Text(
                  maladie!['description_fr'],
                  style: TextStyle(fontSize: 13.5, color: Colors.grey[700], height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // ── Carte : symptômes ──────────────────────────────────────
          _carteSection(
            titre: '🔍 Symptômes observés',
            couleur: Colors.orange,
            items: symptomes,
          ),

          SizedBox(height: 16),

          // ── Carte : traitements ────────────────────────────────────
          _carteSection(
            titre: '💊 Traitements recommandés',
            couleur: Color(0xFF2E7D32),
            items: traitements,
          ),

          SizedBox(height: 24),

          // ── Bouton : lire à voix haute ─────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isReading ? null : lireVoixHaute,
              icon: Icon(isReading ? Icons.volume_up : Icons.record_voice_over),
              label: Text(
                isReading ? 'Lecture en cours...' : '🔊 Lire à voix haute',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isReading ? Colors.grey : Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          SizedBox(height: 12),

          // ── Bouton : nouvelle analyse ──────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Retour direct à l'écran Accueil (on retire tout)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(Icons.refresh),
              label: Text(
                'Nouvelle analyse',
                style: TextStyle(fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF2E7D32),
                side: BorderSide(color: Color(0xFF2E7D32), width: 2),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Widget réutilisable : carte de section (symptômes/traitements) ─
  Widget _carteSection({
    required String titre,
    required Color couleur,
    required List items,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section
          Text(
            titre,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: couleur,
            ),
          ),
          Divider(color: couleur.withValues(alpha: 0.3), thickness: 1.5),
          SizedBox(height: 4),

          // Liste des items
          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_right, color: couleur, size: 20),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: TextStyle(fontSize: 13.5, color: Colors.grey[800], height: 1.4),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}