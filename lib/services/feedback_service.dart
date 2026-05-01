import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackService {
  static const String _cleStockage = 'madoula_feedbacks';

  // ── Sauvegarder un feedback utilisateur ──────────────────────────
  static Future<void> sauvegarder({
    required String classePredi, // ce que l'IA a prédit
    required double confiance, // score de confiance (0.0 → 1.0)
    required bool estCorrect, // true = like, false = dislike
    required String langue, // FR / EWO / FUL
    String versionModele = 'v1.0',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Récupérer les feedbacks existants
    List<dynamic> liste = [];
    String? jsonExistant = prefs.getString(_cleStockage);
    if (jsonExistant != null) {
      try {
        final decode = jsonDecode(jsonExistant);
        if (decode is List) {
          liste = decode;
        }
      } catch (_) {
        liste = [];
      }
    }

    // Créer le nouveau feedback
    Map<String, dynamic> feedback = {
      'classe_predite': classePredi,
      'confiance': confiance,
      'correct': estCorrect,
      'langue': langue,
      'date': DateTime.now().toIso8601String(),
      'version_modele': versionModele,
    };

    liste.add(feedback);

    // Sauvegarder
    await prefs.setString(_cleStockage, jsonEncode(liste));

    print('✅ Feedback sauvegardé : $classePredi → ${estCorrect ? "👍" : "👎"}');
    print('   Total feedbacks : ${liste.length}');
  }

  // ── Récupérer tous les feedbacks (pour debug ou export) ──────────
  static Future<List<Map<String, dynamic>>> recupererTous() async {
    final prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(_cleStockage);
    if (json == null) return [];
    List<dynamic> liste = jsonDecode(json);
    return liste.cast<Map<String, dynamic>>();
  }

  // ── Compter les retours (utile pour l'interface admin) ───────────
  static Future<Map<String, int>> compterRetours() async {
    List<Map<String, dynamic>> tous = await recupererTous();
    int likes = tous.where((f) => f['correct'] == true).length;
    int dislikes = tous.where((f) => f['correct'] == false).length;
    return {'likes': likes, 'dislikes': dislikes, 'total': tous.length};
  }
}
